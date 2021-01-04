module Curation
end

require_dependency 'curation/register_photo'
require_dependency 'curation/mark_copyright_as_not_found'
require_dependency 'curation/publish_photo'

require_dependency 'curation/on_register_photo'
require_dependency 'curation/on_mark_copyright_as_not_found'
require_dependency 'curation/on_publish_photo'

require_dependency 'curation/photo_copyright_found'
require_dependency 'curation/photo_copyright_not_found'
require_dependency 'curation/photo_published'
require_dependency 'curation/photo_registered'
require_dependency 'curation/photo_rejected'

require_dependency 'curation/photo'
