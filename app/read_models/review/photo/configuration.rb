module Review
  class Photo
    class Configuration
      def initialize(cqrs)
        @cqrs = cqrs
      end

      def call
        @cqrs.subscribe(-> (event) { acknowledge_uploaded(event) }, [::Uploading::Event::PhotoUploaded])
        @cqrs.subscribe(-> (event) { acknowledge_processed(event) }, [::FileProcessing::Event::ProcessingFinished])
        @cqrs.subscribe(-> (event) { set_status(event, 'rejected') }, [::Reviewing::Event::PhotoRejected])
        @cqrs.subscribe(-> (event) { set_status(event, 'pre_approved') }, [::Reviewing::Event::PhotoPreApproved])
        @cqrs.subscribe(-> (event) { set_status(event, 'approved') }, [::Reviewing::Event::PhotoApproved])
        @cqrs.subscribe(-> (event) { mark_as_published(event) }, [::Publishing::Event::PhotoPublished])
        @cqrs.subscribe(-> (event) { mark_as_unpublished(event) }, [::Publishing::Event::PhotoUnpublished])
        @cqrs.subscribe(-> (event) { set_copyright(event, 'found') }, [::CopyrightCheck::Event::Found])
        @cqrs.subscribe(-> (event) { set_copyright(event, 'ok') }, [::CopyrightCheck::Event::NotFound])
      end

      private

      def mark_as_published(event)
        with_photo(event) do |photo|
          photo.publish_at = event.timestamp
        end
      end

      def mark_as_unpublished(event)
        with_photo(event) do |photo|
          photo.publish_at = nil
        end
      end

      def set_status(event, status)
        with_photo(event) do |photo|
          photo.status = status
        end
      end

      def set_copyright(event, copyright)
        with_photo(event) do |photo|
          photo.copyright = copyright
        end
      end

      def acknowledge_uploaded(event)
        with_photo(event) do |photo|
          photo.filename = event.data.fetch(:filename)
          photo.status = 'uploaded'
          photo.uploaded_at = event.timestamp
        end
      end

      def acknowledge_processed(event)
        with_photo(event) do |photo|
          photo.status = 'processed'
        end
      end

      def with_photo(event)
        Review::Photo.find_or_initialize_by(id: event.data.fetch(:photo_id)).tap do |photo|
          yield photo
          photo.save!
        end
      end
    end
  end
end
