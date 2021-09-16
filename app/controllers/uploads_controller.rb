class UploadsController < ApplicationController
  def index
    @uploads = UI::Uploads::File.order(uploaded_at: :desc)

    render :index
  end

  def create
    params[:files].each do |file|
      uid = SecureRandom.uuid

      ActiveRecord::Base.transaction do
        Uploading::Operation::UploadImage.call(uid, file)
      end
    end

    redirect_to action: 'index'
  end
end
