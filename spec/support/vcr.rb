# frozen_string_literal: true

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes, serialize_with: :syck }

  config.filter_sensitive_data('<BEARER_TOKEN>') do |interaction|
    auths = interaction.request.headers['Authorization']&.first
    if auths.present? && match = auths.match(/^Bearer\s+([^,\s]+)/)
      match.captures.first
    end
  end
end
