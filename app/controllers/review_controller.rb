class ReviewController < ApplicationController
  def index
    @photos = Review::Photo.order(uploaded_at: :desc)

    render :index
  end

  def reject
    ActiveRecord::Base.transaction do
      command_bus.call(Reviewing::RejectPhoto.new(photo_id: params[:id]))
    end

    redirect_to action: 'index'
  end

  def pre_approve
    ActiveRecord::Base.transaction do
      command_bus.call(Reviewing::PreApprovePhoto.new(photo_id: params[:id]))
    end

    redirect_to action: 'index'
  end

  def approve
    ActiveRecord::Base.transaction do
      command_bus.call(Reviewing::ApprovePhoto.new(photo_id: params[:id]))
    end

    redirect_to action: 'index'
  rescue StandardError => e
    flash.keep

    case e
      when Reviewing::Photo::NotYetPreApproved
        flash[:error] = 'Photo not yet pre approved'
      when Reviewing::Photo::HasBeenRejected
        flash[:error] = 'Approving rejected photos forbidden'
      else
        raise e
    end

    redirect_to action: 'index'
  end
end
