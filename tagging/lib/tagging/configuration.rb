module Tagging
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.subscribe(Tagging::Worker::AutoTagPhoto, [Tagging::Event::AutoTaggingRequested])

      @cqrs.subscribe(
        lambda do |event|
          @cqrs.run(
            Tagging::Command::AddAutoTags.new(
              photo_id: event.data.fetch(:photo_id),
              tags: event.data.fetch(:tags),
              provider: event.data.fetch(:provider)
            )
          )
        end,
        [Tagging::Event::AutoTagsGenerated]
      )

      @cqrs.register(Tagging::Command::AssignFilename, Tagging::PhotoService.new)
      @cqrs.register(Tagging::Command::RequestAutoTagging, Tagging::PhotoService.new)
      @cqrs.register(Tagging::Command::AddAutoTags, Tagging::PhotoService.new)
      @cqrs.register(Tagging::Command::AddTags, Tagging::PhotoService.new)
      @cqrs.register(Tagging::Command::RemoveTag, Tagging::PhotoService.new)
    end
  end
end
