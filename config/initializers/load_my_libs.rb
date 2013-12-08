SidelinedRails3::Application.config.paths['lib'].each do |lib_path|
  Dir[File.join(Rails.root, lib_path, '**', '*.rb')].each { |f| require f}
end
