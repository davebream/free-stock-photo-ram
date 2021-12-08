module Tagging
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @cqrs.subscribe(Tagging::Worker::AutoTagPhoto, [Tagging::AutoTaggingRequested])

      @cqrs.subscribe(
        lambda do |event|
          @cqrs.run(
            Tagging::AddAutoTags.new(
              photo_id: event.data.fetch(:photo_id),
              tags: event.data.fetch(:tags),
              provider: event.data.fetch(:provider)
            )
          )
        end,
        [Tagging::AutoTagsGenerated]
      )

      @cqrs.register(Tagging::AssignFilename, Tagging::PhotoService.new)
      @cqrs.register(Tagging::RequestAutoTagging, Tagging::PhotoService.new)
      @cqrs.register(Tagging::AddAutoTags, Tagging::PhotoService.new)
      @cqrs.register(Tagging::AddTags, Tagging::PhotoService.new)
      @cqrs.register(Tagging::RemoveTag, Tagging::PhotoService.new)
    end
  end
end
