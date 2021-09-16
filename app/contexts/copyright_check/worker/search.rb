module CopyrightCheck
  module Worker
    class Search
      include Sidekiq::Worker

      def perform(uid)
        sleep (8..20).to_a.sample

        events = [
          Event::Found.new(data: { uid: uid }),
          Event::NotFound.new(data: { uid: uid })
        ]

        Rails.configuration.event_store.publish(events.sample)
      end
    end
  end
end
