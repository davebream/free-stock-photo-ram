module UI
  module Uploads
    class Photo < ApplicationRecord
      self.table_name = 'read_model_uploads_photos'

      def average_color=(rgb)
        self.average_color_red, self.average_color_green, self.average_color_blue = rgb
      end

      def average_color
        "rgb(#{[average_color_red, average_color_green, average_color_blue].compact.join(', ')})"
      end
    end
  end
end
