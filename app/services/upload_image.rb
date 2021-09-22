class UploadImage
  def initialize(photo_id, file)
    @photo_id = photo_id
    @file = file
  end

  def call
    filename = photo_id + File.extname(file)
    path = File.join(Rails.public_path, 'images', filename)
    IO.binwrite(path, file.read)

    yield photo_id, filename if block_given?
  end

  private

  attr_reader :photo_id, :file
end
