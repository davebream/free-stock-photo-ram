class ReviewController < ApplicationController
  def index
    @photos = ::ReviewedPhoto.wrap(Review::Photo.order(uploaded_at: :desc))

    render :index
  end

  def reject
    with_transaction do
      cqrs.run(
        Reviewing::RejectPhoto.new(photo_id: params[:id])
      )
    end

    redirect_to action: 'index'
  end

  def pre_approve
    with_transaction do
      cqrs.run(Reviewing::PreApprovePhoto.new(photo_id: params[:id]))
    end

    redirect_to action: 'index'
  end

  def approve
    result = with_transaction do
      cqrs.run(Reviewing::ApprovePhoto.new(photo_id: params[:id]))
    end

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
