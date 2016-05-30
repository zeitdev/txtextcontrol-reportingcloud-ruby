require 'spec_helper'

describe TXTextControl::ReportingCloud do
  it 'has a version number' do
    expect(TXTextControl::ReportingCloud::VERSION).not_to be nil
  end
end

describe "#listTemplates" do
  before do
    @r = TXTextControl::ReportingCloud::ReportingCloud.new("username", "password")
  end
  
  it "should return three template file names" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/listTemplates.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)
    fileNames = @r.listTemplates
    expect(fileNames.length).to be(3)
  end
end