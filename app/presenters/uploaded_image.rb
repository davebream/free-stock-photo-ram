class UploadedImage < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new(obj)
    end
  end

  def dimensions
    return 'processing...' unless width && height
    "w: #{width}, h: #{height}"
  end

  def average_color
    return 'extracting...' unless average_color_red && average_color_green && average_color_blue
    "rgb(#{[average_color_red, average_color_green, average_color_blue].compact.join(', ')})"
  end
end
