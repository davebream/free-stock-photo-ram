require 'rails_helper'

RSpec.describe PhotoPublishing, :in_memory do
  let(:image_id) { SecureRandom.uuid }
  let(:photo_id) { SecureRandom.uuid }

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

  context 'with incompatible correlation ids' do
    let(:events) do
      [
        processing_finished,
        copyright_not_found,
        photo_approved(SecureRandom.uuid)
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

  def processing_finished(correlation_id = photo_id)
    FileProcessing::ProcessingFinished.new(
      data: {
        image_id: image_id,
        average_color: [31, 26, 21],
        width: 1920,
        height: 1089
      }
    ).tap do |event|
      event.correlation_id = correlation_id
    end
  end

  def copyright_found(correlation_id = photo_id)
    CopyrightChecking::Event::Found.new(data: { image_id: image_id }).tap do |event|
      event.correlation_id = correlation_id
    end
  end

  def copyright_not_found(correlation_id = photo_id)
    CopyrightChecking::Event::NotFound.new(data: { image_id: image_id }).tap do |event|
      event.correlation_id = correlation_id
    end
  end

  def photo_rejected(correlation_id = photo_id)
    Reviewing::PhotoRejected.new(data: { photo_id: photo_id }).tap do |event|
      event.correlation_id = correlation_id
    end
  end

  def photo_pre_approved(correlation_id = photo_id)
    Reviewing::PhotoPreApproved.new(data: { photo_id: photo_id }).tap do |event|
      event.correlation_id = correlation_id
    end
  end

  def photo_approved(correlation_id = photo_id)
    Reviewing::PhotoApproved.new(data: { photo_id: photo_id }).tap do |event|
      event.correlation_id = correlation_id
    end
  end

  def photo_published(correlation_id = photo_id)
    Publishing::Event::PhotoPublished.new(data: { photo_id: photo_id }).tap do |event|
      event.correlation_id = correlation_id
    end
  end

  def photo_unpublished(correlation_id = photo_id)
    Publishing::Event::PhotoUnpublished.new(data: { photo_id: photo_id }).tap do |event|
      event.correlation_id = correlation_id
    end
  end

  def publish_photo
    an_instance_of(Publishing::Command::PublishPhoto)
  end

  def unpublish_photo
    an_instance_of(Publishing::Command::UnpublishPhoto)
  end
end
