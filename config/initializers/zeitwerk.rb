SUBDOMAINS = %w(reviewing file_processing tagging copyright_checking publishing).freeze

Rails.autoloaders.each do |autoloader|
  SUBDOMAINS.each do |sub|
    events_dir = Rails.root.join("#{sub}/lib/#{sub}/events")
    commands_dir = Rails.root.join("#{sub}/lib/#{sub}/commands")

    autoloader.collapse(events_dir)
    autoloader.collapse(commands_dir)
  end
end
