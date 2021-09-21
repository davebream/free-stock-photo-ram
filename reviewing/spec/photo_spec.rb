require_relative 'spec_helper'

RSpec.describe Reviewing::Photo do
  let(:photo_id) { SecureRandom.uuid }

  subject(:photo) do
    described_class.new(photo_id)
  end

  describe '#reject' do
    it 'rejects a photo' do
      expect { photo.reject }.to apply(photo_rejected).once.in(photo).strict
    end

    it 'rejects pre approved photo' do
      photo.pre_approve

      expect { photo.reject }.to apply(photo_rejected).once.in(photo).strict
    end

    it 'rejects approved photo' do
      photo.pre_approve
      photo.approve

      expect { photo.reject }.to apply(photo_rejected).once.in(photo).strict
    end

    it 'does nothing when already rejected' do
      photo.reject

      expect { photo.reject }.to_not apply(photo_rejected).in(photo)
    end
  end

  describe '#pre_approve' do
    it 'pre approves a photo' do
      expect { photo.pre_approve }.to apply(photo_pre_approved).once.in(photo).strict
    end

    it 'pre approves a rejected photo' do
      photo.reject

      expect { photo.pre_approve }.to apply(photo_pre_approved).once.in(photo).strict
    end

    it 'does nothing when photo pre approved' do
      photo.pre_approve

      expect { photo.pre_approve }.to_not apply(photo_pre_approved).in(photo)
    end

    it 'does nothing when photo approved' do
      photo.pre_approve
      photo.approve

      expect { photo.pre_approve }.to_not apply(photo_pre_approved).in(photo)
    end
  end

  describe '#approve' do
    it 'approves a photo' do
      photo.pre_approve

      expect { photo.approve }.to apply(photo_approved).once.in(photo).strict
    end

    it 'does nothing when photo approved' do
      photo.pre_approve
      photo.approve

      expect { photo.approve }.to_not apply(photo_approved).in(photo)
    end

    it 'raises error when photo rejected' do
      photo.reject

      expect { photo.approve }.to raise_error(described_class::HasBeenRejected)
    end

    it 'raises error when photo not yet pre aproved' do
      expect { photo.approve }.to raise_error(described_class::NotYetPreApproved)
    end
  end

  def photo_rejected
    an_event(Reviewing::PhotoRejected).with_data(photo_id: photo_id)
  end

  def photo_pre_approved
    an_event(Reviewing::PhotoPreApproved).with_data(photo_id: photo_id)
  end

  def photo_approved
    an_event(Reviewing::PhotoApproved).with_data(photo_id: photo_id)
  end
end
