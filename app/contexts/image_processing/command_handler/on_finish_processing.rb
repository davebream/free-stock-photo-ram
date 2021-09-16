module ImageProcessing
  module CommandHandler
    class OnFinishProcessing
      include ::CommandHandler

      def call(command)
        event_store.publish(
          Event::ProcessingFinished.new(
            data: {
              uid: command.uid,
              average_color: command.average_color,
              width: command.width,
              height: command.height,
            }
          )
        )
      end
    end
  end
end
