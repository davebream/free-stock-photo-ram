module FileProcessing
  class PhotoService
    include CommandHandler

    def finish_processing(command)
      cqrs.publish(
        FileProcessing::ProcessingFinished.new(
          data: {
            photo_id: command.photo_id,
            average_color: command.average_color,
            width: command.width,
            height: command.height
          }
        )
      )
    end
  end
end
