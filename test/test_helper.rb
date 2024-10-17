$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "simplecov"
SimpleCov.start
require "coveralls"
require "economic/rest"

require "minitest/autorun"
require "minitest/spec"
require "webmock/minitest"
require "minitest/unit"
require "mocha/minitest"

def stub_get_request(endpoint:, fixture_name:, page_or_id: nil, skippages: 0, filter: nil, method: :get, paged: true, nested: false)
  uri = URI("https://restapi.e-conomic.com/#{endpoint}")

  if paged && !nested
    if page_or_id.nil? || page_or_id.to_s.empty?
      uri.query = URI.encode_www_form(skippages:, filter:, pagesize: 1000)
    else
      uri.path = page_or_id
    end
  end

  stub_request(method, uri).to_return(status: 200, body:
    File.read(json_fixture(fixture_name)), headers: {})
end

def json_fixture(name)
  "test/fixtures/json/#{name}.json"
end

def xml_fixture(name)
  "test/fixtures/xml/#{name}.xml"
end
