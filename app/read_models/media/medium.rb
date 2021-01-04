module Media
  class Medium < ApplicationRecord
    self.table_name = 'read_model_media'

    EVENTS = [
      Curation::PhotoRegistered,
      Curation::PhotoRejected,
      Curation::PhotoPublished,
      Curation::PhotoCopyrightNotFound,
      Curation::PhotoCopyrightFound
    ].freeze

    class << self
      def call(event)
        case event
        when Curation::PhotoRegistered
          set_status(event.data[:uid], 'registered')
        when Curation::PhotoRejected
          set_status(event.data[:uid], 'rejected')
        when Curation::PhotoPublished
          medium = find_or_initialize_by(id: event.data[:uid])
          medium.status = 'published'
          medium.publish_at = event.data[:publish_at]
          medium.save!
        when Curation::PhotoCopyrightFound
          set_copyright(event.data[:uid], 'found')
        when Curation::PhotoCopyrightNotFound
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
