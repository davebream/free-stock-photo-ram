module UI
  module Tagging
    class Photo < ApplicationRecord
      self.table_name = 'read_model_tagging_photos'

      has_many :tags
    end
  end
end
