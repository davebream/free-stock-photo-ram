require_relative 'spec_helper'

RSpec.describe Tagging::RequestAutoTagging, :in_memory_integration do
  let(:photo_id) { SecureRandom.uuid }
  let(:filename) { 'test.jpg' }

  subject do
    run_command(request_auto_tagging)
  end

  it 'requests auto tagging' do
    run_command(assign_filename)

    expect { subject }.to publish(auto_tagging_requested).in(event_store)
  end

  it 'does nothing when already auto tagged' do
    run_commands([assign_filename, add_auto_tags])

    expect { subject }.to_not publish(auto_tagging_requested).in(event_store)
  end

  it 'raises exception when filename missing' do
    expect { subject }.to raise_error(Tagging::Photo::MissingFilename)
  end

  def assign_filename
    Tagging::AssignFilename.new(photo_id: photo_id, filename: filename)
  end

  def request_auto_tagging
    described_class.new(photo_id: photo_id)
  end

  def add_auto_tags
    Tagging::AddAutoTags.new(
      photo_id: photo_id,
      tags: [{ id: SecureRandom.uuid, name: 'tag' }],
      provider: 'test_provider'
    )
  end

  def auto_tagging_requested
    an_event(Tagging::AutoTaggingRequested).with_data(
      photo_id: photo_id,
      filename: filename
    )
  end
end
