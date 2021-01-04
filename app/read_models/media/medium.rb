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
          medium = find_or_initialize_by(id: event.data[:uid])
          medium.status = 'registered'
          medium.save!
        when Curation::PhotoRejected
          medium = find_or_initialize_by(id: event.data[:uid])
          medium.status = 'rejected'
          medium.save!
        when Curation::PhotoPublished
          medium = find_or_initialize_by(id: event.data[:uid])
          medium.status = 'published'
          medium.publish_at = event.data[:publish_at]
          medium.save!
        when Curation::PhotoCopyrightFound
          medium = find_or_initialize_by(id: event.data[:uid])
          medium.copyright = 'found'
          medium.save!
        when Curation::PhotoCopyrightNotFound
          medium = find_or_initialize_by(id: event.data[:uid])
          medium.copyright = 'ok'
          medium.save!
        end
      end

      def rebuild
        delete_all

        Rails.configuration.event_store.read.forward.of_type(EVENTS).each do |event|
          self.call(event)
        end
      end
    end
  end
end
