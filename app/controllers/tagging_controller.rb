class TaggingController < ApplicationController
  def index
    @photos = PhotoTags::Photo.tagged.order(last_tagging_at: :desc).includes(:tags)

    render :index
  end

  def create
    result = ActiveRecord::Base.transaction do
      command_bus.call(
        Tagging::AddTags.new(
          photo_id: params[:photo_id],
          tags: params[:tags].strip.split(',').map do |tag|
            { id: SecureRandom.uuid, name: tag.strip }
          end
        )
      )
    end

    if result.failure?
      flash.keep
      flash[:error] = result.failure
    end

    redirect_to action: 'index'
  end

  def destroy
    ActiveRecord::Base.transaction do
      command_bus.call(
        Tagging::RemoveTag.new(photo_id: params[:id], tag_id: params[:tag_id])
      )
    end

    redirect_to action: 'index'
  end
end
