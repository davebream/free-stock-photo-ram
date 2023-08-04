module Tags
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
      @subscriptions = {}
    end

    def call
      subscribe(-> (event) { index_tags(event) }, [::Tagging::AutoTagsAdded, ::Tagging::TagsAdded])
      subscribe(-> (event) { delete_tag(event) }, [::Tagging::TagRemoved])

      cqrs.register_rebuilder('tags_read_model', public_method(:rebuild))
    end

    def rebuild
      redis.del("#{base_redis_key}:popular_tags")

      cqrs.event_store.read.of_type(subscriptions.keys).each do |event|
        subscriptions[event.class.to_s].each do |handler|
          handler.call(event)
        end
      end
    end

    private

    attr_reader :cqrs, :subscriptions

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
      tag_name = redis.get("free_stock_photo:photo_tags:#{tag_id}")

      redis.del("free_stock_photo:photo_tags:#{tag_id}")
      redis.zincrby('free_stock_photo:popular_tags', -1, tag_name)
    end

    def redis
      @redis ||= Redis.new
    end

    def base_redis_key
      'free_stock_photo'
    end

    class Rebuilder
      def initialize(configuration)
        @configuration = configuration
      end

      def name
        'tags_read_model'
      end

      def run
        configuration.redis.del("#{configuration.base_redis_key}:popular_tags")

        configuration.cqrs.event_store.read.of_type(configuration.subscriptions.keys).each do |event|
          configuration.subscriptions[event.class.to_s].each do |handler|
            handler.call(event)
          end
        end
      end

      private

      attr_reader :configuration
    end
  end
end
