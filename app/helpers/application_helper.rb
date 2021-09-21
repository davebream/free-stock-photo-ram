module ApplicationHelper
  def tailwind_flash_classes(flash_type) # rubocop:disable Metrics/MethodLength
    case flash_type
      when :success
        'bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative'
      when :error
        'bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative'
      when :alert
        'bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded relative'
      when :notice
        'bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded relative'
      else
        'border text-gray-700 px-4 py-3 rounded relative'
    end
  end

  def tailwind_tag_classes(source)
    return 'bg-white rounded-full text-blue-700 bg-blue-100 border border-blue-300' if source == 'admin'
    'bg-white rounded-full text-gray-700 bg-gray-100 border border-gray-300'
  end
end
