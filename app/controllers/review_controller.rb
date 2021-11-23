class ReviewController < ApplicationController
  def index
    @photos = ::ReviewedPhoto.wrap(Review::Photo.order(uploaded_at: :desc))

    render :index
  end

  def reject
    with_transaction do
      command_bus.call(
        Reviewing::RejectPhoto.new(photo_id: params[:id])
      )
    end

    redirect_to action: 'index'
  end

  def pre_approve
    with_transaction do
      command_bus.call(
        Reviewing::PreApprovePhoto.new(photo_id: params[:id])
      )
    end

    redirect_to action: 'index'
  end

  def approve
    result = command_bus.call(Reviewing::ApprovePhoto.new(photo_id: params[:id]))

    if result.failure?
      flash.keep
      flashes[:error] = result.failure
    end

    redirect_to action: 'index'
  end

  private

  def flashes
    flash[params[:id]] ||= {}
  end
end
