module Tags
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.subscribe(
        -> (event) { apply(event) },
        [::Tagging::AutoTagsAdded, ::Tagging::TagsAdded, ::Tagging::TagRemoved]
      )
    end

    delegate :apply, to: :class
    class << self
      def apply(event)
        case event
          when Tagging::AutoTagsAdded, Tagging::TagsAdded then index_tags(event)
          when Tagging::TagRemoved then delete_tag(event)
        end
      end

      def rebuild(event_store:)
        redis.del("#{base_redis_key}:popular_tags")

        event_store.read.of_type([::Tagging::AutoTagsAdded, ::Tagging::TagsAdded, ::Tagging::TagRemoved])
          .each_batch do |events|
            events.each do |event|
              apply(event)
            end
          end
      end

      def index_tags(event)
        tags = event.data.fetch(:tags)

        tags.each do |tag|
          redis.set("#{base_redis_key}:photo_tags:#{tag[:id]}", tag[:name])
          redis.zincrby("#{base_redis_key}:popular_tags", 1, tag[:name])
        end
      end

      def delete_tag(event)
        tag_id = event.data.fetch(:tag_id)
        tag_name = redis.get("week3_homework:photo_tags:#{tag_id}")

        redis.del("week3_homework:photo_tags:#{tag_id}")
        redis.zincrby('week3_homework:popular_tags', -1, tag_name)
      end

      def redis
        @redis ||= Redis.new
      end

      def base_redis_key
        'week3_homework'
      end
    end
  end
end
