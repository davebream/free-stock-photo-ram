module UI
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.subscribe(UI::Uploads::OnImageUploaded.new, [::Uploading::Event::ImageUploaded])
      @cqrs.subscribe(UI::Uploads::OnImageProcessingFinished.new, [::ImageProcessing::Event::ProcessingFinished])

      @cqrs.subscribe(UI::Reviewing::OnImageUploaded.new, [::Uploading::Event::ImageUploaded])
      @cqrs.subscribe(UI::Reviewing::OnImageProcessingFinished.new, [::ImageProcessing::Event::ProcessingFinished])
      @cqrs.subscribe(UI::Reviewing::OnPhotoRejected.new, [::Reviewing::Event::PhotoRejected])
      @cqrs.subscribe(UI::Reviewing::OnPhotoPreApproved.new, [::Reviewing::Event::PhotoPreApproved])
      @cqrs.subscribe(UI::Reviewing::OnPhotoApproved.new, [::Reviewing::Event::PhotoApproved])

      @cqrs.subscribe(UI::Reviewing::OnPhotoPublished.new, [::Publishing::Event::PhotoPublished])
      @cqrs.subscribe(UI::Reviewing::OnPhotoUnpublished.new, [::Publishing::Event::PhotoUnpublished])

      @cqrs.subscribe(UI::Reviewing::OnCopyrightFound.new, [::CopyrightCheck::Event::Found])
      @cqrs.subscribe(UI::Reviewing::OnCopyrightNotFound.new, [::CopyrightCheck::Event::NotFound])

      @cqrs.subscribe(UI::Tagging::OnImageUploaded.new, [::Uploading::Event::ImageUploaded])
      @cqrs.subscribe(UI::Tagging::OnAutoTagsAdded.new, [::Tagging::Event::AutoTagsAdded])
      @cqrs.subscribe(UI::Tagging::OnTagsAdded.new, [::Tagging::Event::TagsAdded])
      @cqrs.subscribe(UI::Tagging::OnTagRemoved.new, [::Tagging::Event::TagRemoved])
    end
  end
end
