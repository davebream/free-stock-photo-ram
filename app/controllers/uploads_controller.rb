class UploadsController < ApplicationController
  def index
    @uploads = UI::Uploads::File.order(uploaded_at: :desc)

    render :index
  end

  def create
    params[:files].each do |file|
      photo_id = SecureRandom.uuid
      image_id = SecureRandom.uuid

      ActiveRecord::Base.transaction do
        Uploading::UploadImage.call(photo_id, image_id, file)
      end
    end

    redirect_to action: 'index'
  end
end
