RSpec.configure do |config|
  config.include CarrierWave::Test::Matchers
end

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end