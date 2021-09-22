require 'aggregate_root'

module Reviewing
  class Photo
    include AggregateRoot

    NotYetPreApproved = Class.new(StandardError)
    HasBeenRejected = Class.new(StandardError)

    def initialize(id)
      @id = id
      @state = :new
    end

    def reject
      return if rejected?
      apply PhotoRejected.new(data: { photo_id: id })
    end

    def pre_approve
      return if pre_approved? || approved?
      apply PhotoPreApproved.new(data: { photo_id: id })
    end

    def approve
      return if approved?
      raise HasBeenRejected if rejected?
      raise NotYetPreApproved unless pre_approved?

      apply PhotoApproved.new(data: { photo_id: id })
    end

    private

    on PhotoRejected do |_event|
      @state = :rejected
    end

    on PhotoPreApproved do |_event|
      @state = :pre_approved
    end

    on PhotoApproved do |_event|
      @state = :approved
    end

    def registered?
      @state == :registered
    end

    def pre_approved?
      @state == :pre_approved
    end

    def approved?
      @state == :approved
    end

    def rejected?
      @state == :rejected
    end

    attr_reader :state, :id
  end
end
