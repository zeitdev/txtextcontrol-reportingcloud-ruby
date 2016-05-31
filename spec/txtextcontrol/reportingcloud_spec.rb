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
  
  it "returns three templates" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/listTemplates.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)    
    templates = @r.listTemplates
    
    expect(templates.length).to be(3)
  end
  
  it "contains expected file names" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/listTemplates.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)
    templates = @r.listTemplates
    
    expect(templates[0].fileName).to eq("new_template.docx") 
    expect(templates[1].fileName).to eq("sample_invoice.tx") 
    expect(templates[2].fileName).to eq("labels.tx") 
  end
  
  it "contains expected modification dates" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/listTemplates.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)
    templates = @r.listTemplates
    
    expect(templates[0].modified).to eq(DateTime.iso8601("2016-05-30T12:07:45.7633675+00:00")) 
    expect(templates[1].modified).to eq(DateTime.iso8601("2016-05-24T15:24:57.0335799+00:00")) 
    expect(templates[2].modified).to eq(DateTime.iso8601("2016-05-25T15:24:57.0335799+00:00"))     
  end
end

describe "#getTemplateCount" do
  before do
    @r = TXTextControl::ReportingCloud::ReportingCloud.new("username", "password")
  end
  
  it "returns five" do
    stub_request(:get, "api.reporting.cloud/v1/templates/count").to_return(:body => "5")
    expect(@r.getTemplateCount).to be(5)
  end
end

