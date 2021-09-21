require 'rails_helper'

RSpec.describe PhotoPublishing, :in_memory do
  let(:photo_id) { '4a57d789-42dc-45b7-bb4a-23bae35b1928' }

  subject do
    with_events(events).each do |event|
      described_class.new(event_store, command_bus).call(event)
    end
  end

  context 'happy path' do
    let(:events) do
      [
        processing_finished,
        copyright_not_found,
        photo_approved
      ]
    end

    it 'publishes the photo' do
      expect(command_bus).to receive(:call).with(publish_photo).once
      subject
    end
  end

  context 'when copyright found' do
    let(:events) do
      [
        processing_finished,
        copyright_found,
        photo_approved
      ]
    end

    it 'does not publish the photo' do
      expect(command_bus).to_not receive(:call)
      subject
    end
  end

  context 'when photo rejected' do
    let(:events) do
      [
        processing_finished,
        copyright_not_found,
        photo_rejected
      ]
    end

    it 'does not publish the photo' do
      expect(command_bus).to_not receive(:call)
      subject
    end
  end

  context 'when photo published and then rejected' do
    let(:events) do
      [
        processing_finished,
        copyright_not_found,
        photo_approved,
        photo_published,
        photo_rejected
      ]
    end

    it 'unpublishes the photo' do
      allow(command_bus).to receive(:call).with(publish_photo)
      expect(command_bus).to receive(:call).with(unpublish_photo)
      subject
    end
  end

  def processing_finished
    FileProcessing::Event::ProcessingFinished.new(
      data: {
        photo_id: photo_id,
        average_color: [31, 26, 21],
        width: 1920,
        height: 1089
      }
    )
  end

  def copyright_found
    CopyrightChecking::Event::Found.new(data: { photo_id: photo_id })
  end

  def copyright_not_found
    CopyrightChecking::Event::NotFound.new(data: { photo_id: photo_id })
  end

  def photo_rejected
    Reviewing::Event::PhotoRejected.new(data: { photo_id: photo_id })
  end

  def photo_pre_approved
    Reviewing::Event::PhotoPreApproved.new(data: { photo_id: photo_id })
  end

  def photo_approved
    Reviewing::Event::PhotoApproved.new(data: { photo_id: photo_id })
  end

  def photo_published
    Publishing::Event::PhotoPublished.new(data: { photo_id: photo_id })
  end

  def photo_unpublished
    Publishing::Event::PhotoUnpublished.new(data: { photo_id: photo_id })
  end

  def publish_photo
    an_instance_of(Publishing::Command::PublishPhoto)
  end

  def unpublish_photo
    an_instance_of(Publishing::Command::UnpublishPhoto)
  end
end
