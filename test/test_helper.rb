$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "simplecov"
SimpleCov.start
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
      params = {skippages:, filter:, pagesize: 1000}.compact
      uri.query = URI.encode_www_form(params)
    else
      uri = "#{uri}/#{page_or_id}"
    end
  end

  stub_request(method, uri).to_return(status: 200, body:
    File.read(json_fixture(fixture_name)), headers: {})
end

def set_credentials
  Economic::Configuration.app_secret_token = "Demo"
  Economic::Configuration.agreement_grant_token = "Demo"
end

def json_fixture(name)
  "test/fixtures/json/#{name}.json"
end
