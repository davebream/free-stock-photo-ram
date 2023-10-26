class UploadImage
  def initialize(photo_id, file)
    @photo_id = photo_id
    @file = file
  end

  def call
    filename = photo_id + File.extname(file)
    path = Rails.public_path.join('images', filename)
    File.binwrite(path, file.read)

    filename
  end

  private

  attr_reader :photo_id, :file
end
