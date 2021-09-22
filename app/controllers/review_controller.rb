class ReviewController < ApplicationController
  def index
    @photos = Review::Photo.order(uploaded_at: :desc)

    render :index
  end

  def reject
    with_transaction do
      command_bus.call(reject_photo_command)
    end

    redirect_to action: 'index'
  end

  def pre_approve
    with_transaction do
      command_bus.call(pre_approve_photo_command)
    end

    redirect_to action: 'index'
  end

  def approve
    with_transaction do
      command_bus.call(approve_photo_command)
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

  private

  def reject_photo_command
    Reviewing::RejectPhoto.new(photo_id: params[:id], correlation_id: params[:id])
  end

  def pre_approve_photo_command
    Reviewing::PreApprovePhoto.new(photo_id: params[:id], correlation_id: params[:id])
  end

  def approve_photo_command
    Reviewing::ApprovePhoto.new(photo_id: params[:id], correlation_id: params[:id])
  end
end
