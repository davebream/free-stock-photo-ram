SUBDOMAINS = %w(reviewing file_processing tagging).freeze

Rails.autoloaders.each do |autoloader|
  SUBDOMAINS.each do |sub|
    domain_events_dir = Rails.root.join("#{sub}/lib/#{sub}/domain_events")
    commands_dir = Rails.root.join("#{sub}/lib/#{sub}/commands")

    autoloader.collapse(domain_events_dir)
    autoloader.collapse(commands_dir)
  end
end
