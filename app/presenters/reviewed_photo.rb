class ReviewedPhoto < SimpleDelegator
  include ApplicationHelper

  alias_method :photo, :__getobj__

  def self.wrap(collection)
    collection.map do |obj|
      new(obj)
    end
  end

  def status
    photo.status.humanize
  end

  def copyright
    photo.copyright&.humanize || 'searching...'
  end

  def status_classes
    case photo.status
      when 'processed'
        tailwind_gray_badge_classes
      when 'rejected'
        tailwind_red_badge_classes
      when 'pre_approved'
        tailwind_yellow_badge_classes
      when 'approved'
        tailwind_green_badge_classes
    end
  end

  def published
    published? ? 'Yes' : 'No'
  end

  def published_classes
    if photo.published?
      tailwind_green_badge_classes
    else
      tailwind_gray_badge_classes
    end
  end

  def copyright_classes
    case photo.copyright
      when 'ok'
        tailwind_green_badge_classes
      when 'found'
        tailwind_red_badge_classes
      else
        tailwind_gray_badge_classes
    end
  end
end
