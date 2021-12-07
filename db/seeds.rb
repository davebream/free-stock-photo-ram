ActiveRecord::Base.transaction do
  Dir.glob(Rails.root.join('db/seeds/images/*')).each do |f|
    file = File.open(f)
    photo_id = SecureRandom.uuid
    uploading_service = ::UploadImage.new(photo_id, file)
    Uploading::UploadImage.new(uploading_service).call(photo_id)
  end
end
