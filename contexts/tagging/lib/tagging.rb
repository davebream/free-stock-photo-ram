module Tagging
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      cqrs.subscribe(Tagging::Worker::AutoTagPhoto, [Tagging::AutoTaggingRequested])

      cqrs.subscribe(
        lambda do |event|
          cqrs.run(
            Tagging::AddAutoTags.new(
              photo_id: event.data.fetch(:photo_id),
              tags: event.data.fetch(:tags),
              provider: event.data.fetch(:provider)
            )
          )
        end,
        [Tagging::AutoTagsGenerated]
      )

      photo_service = Tagging::PhotoService.new(cqrs)

      cqrs.register(Tagging::AssignFilename, photo_service.public_method(:assign_filename))
      cqrs.register(Tagging::RequestAutoTagging, photo_service.public_method(:request_auto_tagging))
      cqrs.register(Tagging::AddAutoTags, photo_service.public_method(:add_auto_tags))
      cqrs.register(Tagging::AddTags, photo_service.public_method(:add_tags))
      cqrs.register(Tagging::RemoveTag, photo_service.public_method(:remove_tag))
    end

    private

    attr_reader :cqrs
  end
end
