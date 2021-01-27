module Media
  class Medium < ApplicationRecord
    self.table_name = 'read_model_media'

    EVENTS = [
      Curation::Event::PhotoRegistered,
      Curation::Event::PhotoRejected,
      Curation::Event::PhotoPublished,
      Curation::Event::PhotoCopyrightNotFound,
      Curation::Event::PhotoCopyrightFound
    ].freeze

    class << self
      def call(event)
        case event
        when Curation::Event::PhotoRegistered
          set_status(event.data[:uid], 'registered')
        when Curation::Event::PhotoRejected
          set_status(event.data[:uid], 'rejected')
        when Curation::Event::PhotoPublished
          medium = find_or_initialize_by(id: event.data[:uid])
          medium.status = 'published'
          medium.publish_at = event.data[:publish_at]
          medium.save!
        when Curation::Event::PhotoCopyrightFound
          set_copyright(event.data[:uid], 'found')
        when Curation::Event::PhotoCopyrightNotFound
          set_copyright(event.data[:uid], 'ok')
        end
      end

      def rebuild
        delete_all

        Rails.configuration.event_store.read.forward.of_type(EVENTS).each do |event|
          self.call(event)
        end
      end

      private

      def set_status(uid, status)
        medium = find_or_initialize_by(id: uid)
        medium.status = status
        medium.save!
      end

      def set_copyright(uid, copyright)
        medium = find_or_initialize_by(id: uid)
        medium.copyright = copyright
        medium.save!
      end
    end
  end
end
