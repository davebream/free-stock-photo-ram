class TaggingController < ApplicationController
  def index
    @photos = UI::Tagging::Photo
      .where.not(last_tagging_at: nil)
      .order(last_tagging_at: :desc)
      .includes(:tags)

    render :index
  end

  def create
    ActiveRecord::Base.transaction do
      command_bus.call(
        Tagging::Command::AddTags.new(
          photo_id: params[:photo_id],
          tags: params[:tags].strip.split(',').map do |tag|
            { id: SecureRandom.uuid, name: tag.strip }
          end
        )
      )
    end

    redirect_to action: 'index'
  end

  def destroy
    ActiveRecord::Base.transaction do
      command_bus.call(Tagging::Command::RemoveTag.new(uid: params[:id]))
    end

    redirect_to action: 'index'
  end
end
