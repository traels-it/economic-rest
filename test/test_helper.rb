$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "simplecov"
SimpleCov.start
require "coveralls"
Coveralls.wear!
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

def stub_soap_authentication
  stub_request(:get, "https://api.e-conomic.com/secure/api1/EconomicWebService.asmx?WSDL")
    .to_return(status: 200, body: File.read(xml_fixture("wsdl")), headers: {})

  stub_request(:post, "https://api.e-conomic.com/secure/api1/EconomicWebService.asmx")
    .to_return(status: 200, body: File.read(xml_fixture("connect_with_token")), headers: {})
end

def stub_soap_get_request(soap_action:)
  stub_request(:post, "https://api.e-conomic.com/secure/api1/EconomicWebService.asmx")
    .with(headers: {"Soapaction" => '"http://e-conomic.com/' + soap_action + '"'})
    .to_return(status: 200, body: File.read(xml_fixture(soap_action.snakecase)), headers: {})
end

def xml_fixture(name)
  "test/fixtures/xml/#{name}.xml"
end
