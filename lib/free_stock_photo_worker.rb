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

    def cqrs
      Rails.configuration.cqrs
    end

    def sleep_random
      sleep rand(3..8)
    end
  end
end
