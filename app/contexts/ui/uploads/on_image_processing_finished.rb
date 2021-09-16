module UI
  module Uploads
    class OnImageProcessingFinished
      def call(event)
        file = UI::Uploads::File.find_or_initialize_by(id: event.data.fetch(:uid))
        file.width = event.data.fetch(:width)
        file.height = event.data.fetch(:height)
        file.average_color = event.data.fetch(:average_color)
        file.save!
      end
    end
  end
end
