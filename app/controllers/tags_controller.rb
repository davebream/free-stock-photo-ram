class TagsController < ApplicationController
  def index
    @popular_tags = PopularTags.call

    render :index
  end
end
