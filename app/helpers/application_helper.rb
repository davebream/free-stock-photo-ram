module ApplicationHelper
  def tailwind_flash_classes(flash_type) # rubocop:disable Metrics/MethodLength
    case flash_type
      when :success
        'bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded'
      when :error
        'bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded'
      when :alert
        'bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded'
      when :notice
        'bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded'
      else
        'border text-gray-700 px-4 py-3 rounded'
    end
  end

  def tailwind_tag_classes(source)
    return 'bg-white rounded-full text-blue-700 bg-blue-100 border border-blue-300' if source == 'admin'
    'bg-white rounded-full text-gray-700 bg-gray-100 border border-gray-300'
  end

  def tailwind_green_badge_classes
    "#{base_tailwind_bade_classes} text-white bg-green-400"
  end

  def tailwind_yellow_badge_classes
    "#{base_tailwind_bade_classes} text-white bg-yellow-400"
  end

  def tailwind_red_badge_classes
    "#{base_tailwind_bade_classes} text-white bg-red-400"
  end

  def tailwind_gray_badge_classes
    "#{base_tailwind_bade_classes} text-gray-600 bg-gray-100"
  end

  def base_tailwind_bade_classes
    'inline-block rounded-full px-3 py-1 text-sm font-bold mr-3'
  end
end
