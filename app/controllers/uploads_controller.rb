class UploadsController < ApplicationController
  def index
    @uploads = UI::Uploads::Photo.order(uploaded_at: :desc)

    render :index
  end

  def create
    params[:files].each do |file|
      photo_id = SecureRandom.uuid

      ActiveRecord::Base.transaction do
        Uploading::UploadPhoto.call(photo_id, file)
      end
    end

    redirect_to action: 'index'
  end
end
