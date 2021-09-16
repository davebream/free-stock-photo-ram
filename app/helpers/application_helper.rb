module ApplicationHelper
  def tailwind_flash_classes(flash_type)
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

end
