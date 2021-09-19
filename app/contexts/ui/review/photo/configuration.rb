module UI
  module Review
    class Photo
      class Configuration
        def initialize(cqrs)
          @cqrs = cqrs
        end

        def call
          subscribe(-> (event) { acknowledge_image_uploaded(event) }, [::Uploading::Event::ImageUploaded])
          subscribe(-> (event) { set_photo_status(event, 'processed') }, [::FileProcessing::Event::ProcessingFinished])
          subscribe(-> (event) { set_photo_status(event, 'rejected') }, [::Reviewing::Event::PhotoRejected])
          subscribe(-> (event) { set_photo_status(event, 'pre_approved') }, [::Reviewing::Event::PhotoPreApproved])
          subscribe(-> (event) { set_photo_status(event, 'approved') }, [::Reviewing::Event::PhotoApproved])
          subscribe(-> (event) { mark_photo_as_published(event) }, [::Publishing::Event::PhotoPublished])
          subscribe(-> (event) { mark_photo_as_unpublished(event) }, [::Publishing::Event::PhotoUnpublished])
          subscribe(-> (event) { set_photo_copyright(event, 'found') }, [::CopyrightCheck::Event::Found])
          subscribe(-> (event) { set_photo_copyright(event, 'ok') }, [::CopyrightCheck::Event::NotFound])
        end

        private

        def mark_photo_as_published(event)
          with_photo(event) do |photo|
            photo.publish_at = event.timestamp
          end
        end

        def mark_photo_as_unpublished(event)
          with_photo(event) do |photo|
            photo.publish_at = nil
          end
        end

        def set_photo_status(event, status)
          with_photo(event) do |photo|
            photo.status = status
          end
        end

        def set_photo_copyright(event, copyright)
          with_photo(event) do |photo|
            photo.copyright = copyright
          end
        end

        def acknowledge_image_uploaded(event)
          with_photo(event) do |photo|
            photo.filename = event.data.fetch(:filename)
            photo.status = 'uploaded'
            photo.uploaded_at = event.timestamp
          end
        end

        def acknowledge_image_processed(event)
          with_photo(event) do |photo|
            photo.status = 'processed'
          end
        end

        def with_photo(event)
          UI::Reviewing::Photo.find_or_initialize_by(id: event.data.fetch(:photo_id)).tap do |photo|
            yield photo
            photo.save!
          end
        end

        def subscribe(handler, events)
          @cqrs.subscribe(
            lambda do |event|
              link_to_stream(event)
              handler.call(event)
            end,
            events
          )
        end

        def link_to_stream(event)
          @cqrs.link_event_to_stream(event, "UI::Reviewing::Photo$#{event.data.fetch(:photo_id)}")
        end
      end
    end
  end
end
