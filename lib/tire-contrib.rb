# Require all Tire::Contrib components
#
Dir[ File.join File.expand_path('../', __FILE__), 'tire', '*.rb' ].each do |component|
  # require component
end
