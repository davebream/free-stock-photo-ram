module FileProcessing
  class ImageService
    include CommandHandler

    def finish_processing(command)
      event_store.publish(
        Event::ProcessingFinished.new(
          data: {
            image_id: command.image_id,
            photo_id: command.photo_id,
            average_color: command.average_color,
            width: command.width,
            height: command.height,
          }
        )
      )
    end
  end
end
