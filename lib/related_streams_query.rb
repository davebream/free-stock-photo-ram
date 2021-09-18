class RelatedStreamsQuery
  STREAM_NAMES = [
    'Reviewing::Aggregate::Photo',
    'Publishing::Aggregate::Photo',
    'Tagging::Aggregate::Photo',
    'PhotoPublishing',
    'ImageProcessing::Process'
  ].freeze

  def call(stream_name)
    prefix, id = stream_name.split('$')
    return [] unless id

    (STREAM_NAMES - [prefix]).map { |stream_name| "#{stream_name}$#{id}" }
  end
end
