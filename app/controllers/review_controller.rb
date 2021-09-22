class ReviewController < ApplicationController
  def index
    @photos = Review::Photo.order(uploaded_at: :desc)

    render :index
  end

  def reject
    with_transaction do
      command_bus.call(
        Reviewing::RejectPhoto.new(photo_id: params[:id], correlation_id: params[:id])
      )
    end

    redirect_to action: 'index'
  end

  def pre_approve
    with_transaction do
      command_bus.call(
        Reviewing::PreApprovePhoto.new(photo_id: params[:id], correlation_id: params[:id])
      )
    end

    redirect_to action: 'index'
  end

  def approve
    result = ApprovePhoto.new.call(params[:id])

    if result.failure?
      flash.keep
      flash[:error] = result.failure[:message]
    end

    redirect_to action: 'index'
  end
end
