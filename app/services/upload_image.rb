class UploadImage
  def initialize(photo_id, file)
    @photo_id = photo_id
    @file = file
  end

  def call
    filename = photo_id + File.extname(file)
    directory = Rails.public_path.join('images')
    FileUtils.mkdir_p(directory) unless File.directory?(directory)
    path = File.join(directory, filename)
    File.binwrite(path, file.read)

    filename
  end

  private

  attr_reader :photo_id, :file
end
