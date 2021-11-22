class PopularTags
  PopularTag = Struct.new(:name, :photos_count)

  class << self
    def call
      popular_tags.filter { |_, count| count >= 1 }.map do |name, count|
        PopularTag.new(name, count.to_i)
      end
    end

    private

    def popular_tags
      redis.zrevrange('week3_homework:popular_tags', 0, 100, with_scores: true) || []
    end

    def redis
      @redis ||= Redis.new
    end
  end
end
