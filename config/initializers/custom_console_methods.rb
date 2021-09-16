module CustomConsoleMethods
  def event_store
    Rails.configuration.event_store
  end

  def command_bus
    Rails.configuration.command_bus
  end
end

require 'rails/console/helpers'
Rails::ConsoleMethods.prepend(CustomConsoleMethods)
