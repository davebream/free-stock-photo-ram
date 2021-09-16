class ReviewingController < ApplicationController
  def index
    @photos = UI::Reviewing::Photo.order(uploaded_at: :desc)

    render :index
  end

  def reject
    ActiveRecord::Base.transaction do
      command_bus.call(Reviewing::Command::RejectPhoto.new(uid: params[:id]))
    end

    redirect_to action: 'index'
  end

  def pre_approve
    ActiveRecord::Base.transaction do
      command_bus.call(Reviewing::Command::PreApprovePhoto.new(uid: params[:id]))
    end

    redirect_to action: 'index'
  end

  def approve
    ActiveRecord::Base.transaction do
      command_bus.call(Reviewing::Command::ApprovePhoto.new(uid: params[:id]))
    end

    redirect_to action: 'index'
  rescue StandardError => e
    flash.keep

    case e
    when Reviewing::Aggregate::Photo::NotYetPreApproved
      flash[:error] = 'Photo not yet pre approved'
    when Reviewing::Aggregate::Photo::HasBeenRejected
      flash[:error] = 'Approving rejected photos forbidden'
    else
      raise e
    end

    redirect_to action: 'index'
  end

  def publish
    ActiveRecord::Base.transaction do
      command_bus.call(Reviewing::Command::PublishPhoto.new(uid: params[:id]))
    end

    redirect_to action: 'index'
  rescue StandardError => e
    flash.keep

    case e
    when Reviewing::Aggregate::Photo::NotYetApproved
      flash[:error] = 'Photo not yet approved'
    when Reviewing::Aggregate::Photo::HasBeenRejected
      flash[:error] = 'Publishing rejected photos forbidden'
    else
      raise e
    end

    redirect_to action: 'index'
  end
end
