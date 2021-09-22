module FileProcessing
  class PhotoService
    include CommandHandler

    def finish_processing(command)
      event_store.publish(
        FileProcessing::ProcessingFinished.new(
          data: {
            image_id: command.image_id,
            average_color: command.average_color,
            width: command.width,
            height: command.height
          }
        )
      )
    end
  end
end
