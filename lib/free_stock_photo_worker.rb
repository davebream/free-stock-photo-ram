module FreeStockPhotoWorker
  def self.included(base)
    base.class_eval do
      include Sidekiq::Worker
      include HelperMethods
    end
  end

  module HelperMethods
    def perform(*)
      ActiveRecord::Base.transaction do
        super
      end
    end

    def event_store
      Rails.configuration.event_store
    end

    def command_bus
      Rails.configuration.command_bus
    end

    def sleep_random
      sleep rand(3..8)
    end
  end
end
