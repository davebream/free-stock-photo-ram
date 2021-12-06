require 'rails_helper'

RSpec.describe ImageProcessing, :in_memory do
  let(:photo_id) { '4a57d789-42dc-45b7-bb4a-23bae35b1928' }

  subject do
    with_events(events).each do |event|
      described_class.new(cqrs).call(event)
    end
  end

  context 'happy path' do
    let(:events) do
      [
        dimensions_recognized,
        average_color_extracted
      ]
    end

    it 'finishes processing' do
      subject
      expect(command_bus.received).to eq(finish_processing)
    end
  end

  context 'color not extracted' do
    let(:events) do
      [dimensions_recognized]
    end

    it 'does not finish processing' do
      subject
      expect(command_bus.received).to be_nil
    end
  end

  context 'dimensions not recognized' do
    let(:events) do
      [average_color_extracted]
    end

    it 'does not finish processing' do
      subject
      expect(command_bus.received).to be_nil
    end
  end

  def dimensions_recognized
    FileProcessing::DimensionsRecognized.new(
      data: {
        photo_id: photo_id,
        width: 1920,
        height: 1080
      }
    )
  end

  def average_color_extracted
    FileProcessing::AverageColorExtracted.new(
      data: {
        photo_id: photo_id,
        rgb: [31, 26, 21]
      }
    )
  end

  def finish_processing
    FileProcessing::FinishProcessing.new(
      photo_id: photo_id,
      width: 1920,
      height: 1080,
      average_color: [31, 26, 21]
    )
  end
end
