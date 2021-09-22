class UploadImage
  def initialize(photo_id, file)
    @photo_id = photo_id
    @file = file
  end

  def call
    filename = photo_id + File.extname(file)
    url_path = File.join('images', filename)
    path = File.join(Rails.public_path, url_path)
    IO.binwrite(path, file.read)

    yield photo_id, filename, url_path, path if block_given?
  end

  private

  attr_reader :photo_id, :file
end
