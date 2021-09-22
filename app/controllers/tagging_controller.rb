class TaggingController < ApplicationController
  def index
    @photos = Tags::Photo.tagged.order(last_tagging_at: :desc).includes(:tags)

    render :index
  end

  def create
    ActiveRecord::Base.transaction do
      command_bus.call(
        Tagging::AddTags.new(
          photo_id: params[:photo_id],
          tags: params[:tags].strip.split(',').map do |tag|
            { id: SecureRandom.uuid, name: tag.strip }
          end,
          correlation_id: params[:photo_id]
        )
      )
    end

    redirect_to action: 'index'
  end

  def destroy
    ActiveRecord::Base.transaction do
      command_bus.call(
        Tagging::RemoveTag.new(
          photo_id: params[:id],
          tag_id: params[:tag_id],
          correlation_id: params[:id]
        )
      )
    end

    redirect_to action: 'index'
  end
end
