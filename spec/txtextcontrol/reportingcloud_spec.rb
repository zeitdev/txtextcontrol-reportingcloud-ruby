require 'spec_helper'
require 'base64'
require "txtextcontrol/reportingcloud/merge_body"

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
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/list_templates.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)    
    
    templates = @r.listTemplates    
    expect(templates.length).to be(3)
  end
  
  it "contains expected template names" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/list_templates.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)
    
    templates = @r.listTemplates    
    expect(templates[0].templateName).to eq("new_template.docx") 
    expect(templates[1].templateName).to eq("sample_invoice.tx") 
    expect(templates[2].templateName).to eq("labels.tx") 
  end
  
  it "contains expected modification dates" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/list_templates.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)
    
    templates = @r.listTemplates    
    expect(templates[0].modified).to eq(DateTime.iso8601("2016-05-30T12:07:45")) 
    expect(templates[1].modified).to eq(DateTime.iso8601("2016-05-24T15:24:57")) 
    expect(templates[2].modified).to eq(DateTime.iso8601("2016-05-26T15:24:57"))     
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

describe "#getTemplateThumbnails" do
  before do
    @r = TXTextControl::ReportingCloud::ReportingCloud.new("username", "password")
  end
  
  it "returns two images" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/get_template_thumbnails.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/thumbnails?templateName=new_template.docx&zoomFactor=25&fromPage=1&toPage=0").to_return(:body => canned_response)
    
    thumbnails = @r.getTemplateThumbnails("new_template.docx", 25, 1, 0)
    expect(thumbnails.length).to be(2)
  end
  
  it "returns png images" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/get_template_thumbnails.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/thumbnails?templateName=new_template.docx&zoomFactor=25&fromPage=1&toPage=0").to_return(:body => canned_response)
    
    thumbnails = @r.getTemplateThumbnails("new_template.docx", 25, 1, 0)
    data = Base64.decode64(thumbnails[0]);
    # Check for PNG magic number
    expect(data[0].ord).to be(0x89)
    expect(data[1].ord).to be(0x50)
    expect(data[2].ord).to be(0x4E)
    expect(data[3].ord).to be(0x47)
    expect(data[4].ord).to be(0x0d)
  end
  
  it "returns jpg images" do
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/get_template_thumbnails_jpg.json'
    stub_request(:get, "api.reporting.cloud/v1/templates/thumbnails?templateName=new_template.docx&zoomFactor=25&fromPage=1&toPage=0&imageFormat=jpg").to_return(:body => canned_response)
    
    thumbnails = @r.getTemplateThumbnails("new_template.docx", 25, 1, 0, :jpg)
    data = Base64.decode64(thumbnails[0])
    # Check for JPG magic number
    expect(data[0].ord).to be(0xFF)
    expect(data[1].ord).to be(0xD8)
  end
end

describe "#merge" do
  before do
    @r = TXTextControl::ReportingCloud::ReportingCloud.new("username", "password")
  end

  it "generates two documents" do
    # Get request body from file
    request_body = File.open(File.dirname(__FILE__) + '/../support/fixtures/merge_request_body.json', 'rb') { |f| f.read }
    canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/merge_result_two_pdfs.json'    
    stub_request(:post, "api.reporting.cloud/v1/document/merge?returnFormat=pdf&append=false&templateName=sample_invoice.tx").
      with(:body => request_body).
      to_return(:body => canned_response)
      
    # Some dummy merge data
    mergeData = [
      {
        "billto_name" => "Testy McTest",
        "recipient_name" => "Hans Musterfrau",
        "item" => [        
          {
            "item_no" => 23,
            "item_description" => "An Item.",
            "item_total" => 234.56
          }, 
          {
            "item_no" => 34,
            "item_description" => "Another Item.",
            "item_total" => 345.67
          }
        ]
      },
      {
        "billto_name" => "Hans Musterfrau",
        "recipient_name" => "Testy McTest",
        "item" => [        
          {
            "item_no" => 45,
            "item_description" => "Yet another item.",
            "item_total" => 456.78
          }, 
          {
            "item_no" => 56,
            "item_description" => "And another one.",
            "item_total" => 567.89
          }
        ]
      }
    ]
      
    mb = TXTextControl::ReportingCloud::MergeBody.new(mergeData)
    mergeRes = @r.merge(mb, "sample_invoice.tx")
    data = Base64.decode64(mergeRes[0])
    
    # Check for PDF magic number
    expect(data[0].ord).to be(0x25)
    expect(data[1].ord).to be(0x50)
    expect(data[2].ord).to be(0x44)
    expect(data[3].ord).to be(0x46)
  end
end