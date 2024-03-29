class UploadsController < ApplicationController
  def index
    @uploads = ::UploadedImage.wrap(Uploads::Image.order(uploaded_at: :desc))

    render :index
  end

  def create
    with_transaction do
      params[:files].each do |file|
        photo_id = SecureRandom.uuid

        uploading_service = ::UploadImage.new(photo_id, file)

        Uploading::UploadImage.new(uploading_service).call(photo_id)
      end
    end

    redirect_to action: 'index'
  end
end
