require 'rails_helper'

RSpec.describe PhotoPublishing, :in_memory do
  let(:photo_id) { SecureRandom.uuid }

  subject do
    with_events(events).each do |event|
      described_class.new(cqrs).call(event)
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
      subject
      expect(command_bus.received).to eq(publish_photo)
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
      subject
      expect(command_bus.received).to be_nil
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
      subject
      expect(command_bus.received).to be_nil
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
      # allow(command_bus).to receive(:call).with(publish_photo)
      subject
      expect(command_bus.received).to eq(unpublish_photo)
    end
  end

  def processing_finished(id: photo_id)
    FileProcessing::ProcessingFinished.new(
      data: {
        photo_id: id,
        average_color: [31, 26, 21],
        width: 1920,
        height: 1089
      }
    )
  end

  def copyright_found(id: photo_id)
    CopyrightChecking::Found.new(data: { photo_id: id })
  end

  def copyright_not_found(id: photo_id)
    CopyrightChecking::NotFound.new(data: { photo_id: id })
  end

  def photo_rejected(id: photo_id)
    Reviewing::PhotoRejected.new(data: { photo_id: id })
  end

  def photo_pre_approved(id: photo_id)
    Reviewing::PhotoPreApproved.new(data: { photo_id: id })
  end

  def photo_approved(id: photo_id)
    Reviewing::PhotoApproved.new(data: { photo_id: id })
  end

  def photo_published(id: photo_id)
    Publishing::PhotoPublished.new(data: { photo_id: id })
  end

  def photo_unpublished(id: photo_id)
    Publishing::PhotoUnpublished.new(data: { photo_id: id })
  end

  def publish_photo
    Publishing::PublishPhoto.new(photo_id: photo_id)
  end

  def unpublish_photo
    Publishing::UnpublishPhoto.new(photo_id: photo_id)
  end
end
