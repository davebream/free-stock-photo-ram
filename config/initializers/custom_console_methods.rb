module CustomConsoleMethods
  def event_store
    cqrs.event_store
  end

  def command_bus
    Rails.configuration.command_bus
  end

  def cqrs
    Rails.configuration.cqrs
  end
end

require 'rails/console/helpers'
Rails::ConsoleMethods.prepend(CustomConsoleMethods)
