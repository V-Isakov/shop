require 'dox'

Dox.configure do |config|
  config.header_file_path = Rails.root.join('spec/docs/header.md')
  config.desc_folder_path = Rails.root.join('spec/docs/descriptions')
  config.headers_whitelist = ['Accept: application/json']
end