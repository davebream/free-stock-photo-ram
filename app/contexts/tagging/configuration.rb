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
              uid: event.data.fetch(:uid),
              tags: event.data.fetch(:tags),
              provider: event.data.fetch(:provider)
            )
          )
        end,
        [Tagging::Event::AutoTagsGenerated]
      )

      @cqrs.register(Tagging::Command::SetPath, Tagging::CommandHandler::OnSetPath.new)
      @cqrs.register(Tagging::Command::RequestAutoTagging, Tagging::CommandHandler::OnRequestAutoTagging.new)
      @cqrs.register(Tagging::Command::AddAutoTags, Tagging::CommandHandler::OnAddAutoTags.new)
      @cqrs.register(Tagging::Command::AddTags, Tagging::CommandHandler::OnAddTags.new)
      @cqrs.register(Tagging::Command::RemoveTag, Tagging::CommandHandler::OnRemoveTag.new)
    end
  end
end
