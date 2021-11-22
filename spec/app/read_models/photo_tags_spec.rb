require 'rails_helper'

RSpec.describe 'Photo Tags Read Models', :in_memory_integration do
  let(:photo_id) { SecureRandom.uuid }
  let(:photo) { PhotoTags::Photo.find_by(id: photo_id) }

  let(:auto_tag_id) { SecureRandom.uuid }
  let(:auto_tag) { PhotoTags::Tag.find_by(id: auto_tag_id) }
  let(:auto_tagging_at) { Time.new(2021, 9, 20, 21, 0).in_time_zone }

  let(:tag_id) { SecureRandom.uuid }
  let(:tag) { PhotoTags::Tag.find_by(id: tag_id) }
  let(:tagging_at) { Time.new(2021, 9, 20, 21, 10).in_time_zone }

  it 'changes records basing on events' do
    event_store.publish(filename_assigned)
    event_store.publish(auto_tags_added)
    event_store.publish(tags_added)

    expect(photo).to have_attributes(
      filename: 'test.jpg',
      last_tagging_at: tagging_at
    )

    expect(auto_tag).to have_attributes(
      name: 'auto tag',
      source: 'external',
      provider: 'test_provider',
      added_at: auto_tagging_at,
      photo: photo
    )

    expect(tag).to have_attributes(
      name: 'tag',
      source: 'admin',
      added_at: tagging_at,
      photo: photo
    )

    expect do
      event_store.publish(tag_removed)
    end.to change { PhotoTags::Tag.count }.by(-1)
  end

  def filename_assigned
    Tagging::FilenameAssigned.new(data: { photo_id: photo_id, filename: 'test.jpg' })
  end

  def auto_tags_added
    Tagging::AutoTagsAdded.new(
      data: { photo_id: photo_id, tags: [{ id: auto_tag_id, name: 'auto tag' }], provider: 'test_provider' },
      metadata: { timestamp: auto_tagging_at }
    )
  end

  def tags_added
    Tagging::TagsAdded.new(
      data: { photo_id: photo_id, tags: [{ id: tag_id, name: 'tag' }] },
      metadata: { timestamp: tagging_at }
    )
  end

  def tag_removed
    Tagging::TagRemoved.new(data: { photo_id: photo_id, tag_id: auto_tag_id })
  end
end
