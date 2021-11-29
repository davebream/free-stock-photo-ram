module Tags
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
      @subscriptions = {}
    end

    def call
      subscribe(-> (event) { index_tags(event) }, [::Tagging::AutoTagsAdded, ::Tagging::TagsAdded])
      subscribe(-> (event) { delete_tag(event) }, [::Tagging::TagRemoved])
    end

    def rebuild
      call

      redis.del("#{base_redis_key}:popular_tags")

      @cqrs.event_store.read.of_type(@subscriptions.keys).each do |event|
        @subscriptions[event.class.to_s].each do |handler|
          handler.call(event)
        end
      end
    end

    private

    def subscribe(handler, events)
      @cqrs.subscribe(-> (event) { handler.call(event) }, events)

      events.each do |event_klass|
        @subscriptions[event_klass.to_s] ||= []
        @subscriptions[event_klass.to_s] << handler
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
