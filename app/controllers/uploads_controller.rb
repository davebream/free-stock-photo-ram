class UploadsController < ApplicationController
  def index
    @uploads = UI::Uploads::File.order(uploaded_at: :desc)

    render :index
  end

  def create
    params[:files].each do |file|
      image_id = SecureRandom.uuid

      ActiveRecord::Base.transaction do
        Uploading::UploadImage.call(image_id, file)
      end
    end

    redirect_to action: 'index'
  end
end
