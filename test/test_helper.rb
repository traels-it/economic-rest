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

def stub_get_request(endpoint:, page_or_id: nil, pageindex: 0, fixture_name:, method: :get, paged: true, nested: false)
  url = "https://restapi.e-conomic.com/"
  url << endpoint.to_s if endpoint
  if paged && !nested
    url << if page_or_id.nil? || page_or_id.to_s.empty?
      "?skippages=#{pageindex}&pagesize=1000"
    else
      "/#{page_or_id}"
    end
  end
  stub_request(method, url).to_return(status: 200, body:
    File.read(json_fixture(fixture_name)), headers: {})
end

def json_fixture(name)
  "test/fixtures/json/#{name}.json"
end

def xml_fixture(name)
  "test/fixtures/xml/#{name}.xml"
end
