class RelatedStreamsQuery
  STREAM_NAMES = [
    'Reviewing::Photo',
    'Publishing::Photo',
    'Tagging::Photo',
    'PhotoPublishing',
    'ImageProcessing'
  ].freeze

  def call(stream_name)
    prefix, id = stream_name.split('$')
    return [] unless id

    (STREAM_NAMES - [prefix]).map { |stream_name| "#{stream_name}$#{id}" }
  end
end
