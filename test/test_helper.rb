$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'economic/rest'

require 'minitest/autorun'
require 'minitest/spec'
require 'webmock/minitest'

def stub_get_request(endpoint, page_or_id, fixture_name)
  url = 'https://restapi.e-conomic.com/'
  url << "#{endpoint}" if endpoint
  url << "/#{page_or_id}" unless page_or_id.nil? || page_or_id.to_s.empty?
  stub_request(:get, url)
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip, deflate',
        'Content-Type' => 'application/json',
        'Host' => 'restapi.e-conomic.com',
        'X-Agreementgranttoken' => 'Demo',
        'X-Appsecrettoken' => 'Demo'
      }
    )
    .to_return(status: 200, body:
    File.read(json_fixture(fixture_name)), headers: {})
end

def json_fixture(name)
  "test/fixtures/json/#{name}.json"
end
