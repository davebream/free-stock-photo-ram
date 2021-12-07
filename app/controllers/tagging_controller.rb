class TaggingController < ApplicationController
  def index
    @photos = PhotoTags::Photo.tagged.with_file.order(last_tagging_at: :desc).includes(:tags)

    render :index
  end

  def create
    result = with_transaction do
      cqrs.run(
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
      flashes[:error] = result.failure
    end

    redirect_to action: 'index'
  end

  def destroy
    with_transaction do
      cqrs.run(Tagging::RemoveTag.new(photo_id: params[:id], tag_id: params[:tag_id]))
    end

    redirect_to action: 'index'
  end

  private

  def flashes
    flash[params[:photo_id]] ||= {}
  end
end
