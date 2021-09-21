class RelatedStreamsQuery
  STREAM_NAMES = [
    'Reviewing::Photo',
    'Publishing::Photo',
    'Tagging::Photo',
    'PhotoPublishing',
    'ImageProcessing'
  ].freeze

  def call(stream)
    prefix, id = stream.split('$')
    return [] unless id

    (STREAM_NAMES - [prefix]).map { |stream_name| "#{stream_name}$#{id}" }
  end
end
