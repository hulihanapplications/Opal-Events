Dir.glob(File.join(File.dirname(__FILE__), "..", "app", "models", "*.rb")).each do |file|
  require file
end
