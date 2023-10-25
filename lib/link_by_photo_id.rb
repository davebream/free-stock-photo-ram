class LinkByPhotoId
  def initialize(cqrs)
    @cqrs = cqrs
  end

  def call(event)
    photo_id = event.data[:photo_id].presence
    return if photo_id.blank?

    @cqrs.link_event_to_stream(event, "$by_photo_id_#{photo_id}")
  end
end
