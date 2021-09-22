class UploadsController < ApplicationController
  def index
    @uploads = Uploads::Image.order(uploaded_at: :desc)

    render :index
  end

  def create
    params[:files].each do |file|
      photo_id = SecureRandom.uuid
      image_id = SecureRandom.uuid

      uploading_service = ::UploadImage.new(photo_id, file)

      ActiveRecord::Base.transaction do
        Uploading::UploadPhoto.new(uploading_service).call(image_id)
      end
    end

    redirect_to action: 'index'
  end
end
