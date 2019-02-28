require 'spec_helper'
require 'base64'
require "txtextcontrol/reportingcloud/merge_body"
require "txtextcontrol/reportingcloud/find_and_replace_body"
require "txtextcontrol/reportingcloud/append_body"

$api_key = ""

describe TXTextControl::ReportingCloud do  
  it 'has a version number' do
    expect(TXTextControl::ReportingCloud::VERSION).not_to be nil
  end
end
  
describe TXTextControl::ReportingCloud::ReportingCloud do
  let(:r) { TXTextControl::ReportingCloud::ReportingCloud.new("<USERNAME>", "<PASSWORD>") }
  let(:template_data) { File.open(File.dirname(__FILE__) + "/../support/fixtures/__ruby_wrapper_test.tx", "rb") { |f| f.read } }
  let(:template_data_B64) { Base64.strict_encode64(template_data) }
      
  describe "#list_templates" do  
    it "returns three templates" do
      canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/list_templates.json'
      stub_request(:get, "https://api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)    
      
      templates = r.list_templates    
      expect(templates.length).to be(3)
    end
    
    it "contains expected template names" do
      canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/list_templates.json'
      stub_request(:get, "https://api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)
      
      templates = r.list_templates    
      expect(templates[0].template_name).to eq("new_template.docx") 
      expect(templates[1].template_name).to eq("sample_invoice.tx") 
      expect(templates[2].template_name).to eq("labels.tx") 
    end
    
    it "contains expected modification dates" do
      canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/list_templates.json'
      stub_request(:get, "https://api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)
      
      templates = r.list_templates    
      expect(templates[0].modified).to eq(DateTime.iso8601("2016-05-30T12:07:45+00:00"))
      expect(templates[1].modified).to eq(DateTime.iso8601("2016-05-24T15:24:57+00:00"))
      expect(templates[2].modified).to eq(DateTime.iso8601("2016-05-26T15:24:57+00:00"))
    end
    
    it "contains expected file sizes" do
      canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/list_templates.json'
      stub_request(:get, "https://api.reporting.cloud/v1/templates/list").to_return(:body => canned_response)
      
      templates = r.list_templates
      expect(templates[0].size).to be(3705)    
      expect(templates[1].size).to be(34845)    
      expect(templates[2].size).to be(34212)    
    end
  end

  describe "#get_template_count" do  
    it "parses result correctly" do
      stub_request(:get, "https://api.reporting.cloud/v1/templates/count").to_return(:body => "5")
      expect(r.get_template_count).to be(5)
    end
  end

  def is_png(data) 
    return data[0].ord == 0x89 &&
      data[1].ord == 0x50 &&
      data[2].ord == 0x4E &&
      data[3].ord == 0x47 &&
      data[4].ord == 0x0D
  end

  describe "#get_template_thumbnails" do  
    it "returns two images" do
      canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/get_template_thumbnails.json'
      stub_request(:get, "https://api.reporting.cloud/v1/templates/thumbnails?templateName=new_template.docx&zoomFactor=25&fromPage=1&toPage=0").to_return(:body => canned_response)
      
      thumbnails = r.get_template_thumbnails("new_template.docx", 25, 1, 0)
      expect(thumbnails.length).to be(2)
    end
    
    it "returns png images" do      
      WebMock.allow_net_connect!
      thumbnails = r.get_template_thumbnails("sample_invoice.tx", 25, 1, 0)
      data = Base64.strict_decode64(thumbnails[0]);

      # Check for PNG magic number
      expect(is_png(data)).to be(true)
    end
    
    it "returns jpg images" do
      thumbnails = r.get_template_thumbnails("sample_invoice.tx", 25, 1, 0, :jpg)
      data = Base64.strict_decode64(thumbnails[0])

      # Check for JPG magic number
      expect(data[0].ord).to be(0xFF)
      expect(data[1].ord).to be(0xD8)
    end
  end

  describe "#get_template_info" do
    let (:info) { r.get_template_info("invoice.tx") }

    it "returns the correct template name" do
      expect(info.template_name).to eq("invoice.tx")
    end    
  end  

  describe "#merge_document" do
    it "generates PDF documents" do
      # Some dummy merge data
      merge_data = [
        {
          "billto_name" => "Will Ferrell",
          "recipient_name" => "Colin Farrell",
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
          "billto_name" => "Morgan Freeman",
          "recipient_name" => "Martin Freeman",
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
        
      mb = TXTextControl::ReportingCloud::MergeBody.new(merge_data)
      merge_res = r.merge_document(mb, "sample_invoice.tx")
      data = Base64.strict_decode64(merge_res[0])
      
      # Check for PDF magic number
      expect(is_pdf(data)).to be(true)
    end
  end

  describe "#append_documents" do
    it "appends documents" do 
      documents = [
        TXTextControl::ReportingCloud::AppendDocument.new(template_data_B64),
        TXTextControl::ReportingCloud::AppendDocument.new(template_data_B64, :new_section)
      ]

      ds = TXTextControl::ReportingCloud::DocumentSettings.new
      ds.author = "John Doe"
      ds.creator_application = "That App™"

      ab = TXTextControl::ReportingCloud::AppendBody.new(documents, ds)

      # Append the documents
      res = r.append_documents(ab)
      expect(res).not_to be(nil)
      expect(res).to be_a(String)
      data = Base64.strict_decode64(res)

      expect(data.length).to be(18789)

      # Check for PDF magic number
      expect(is_pdf(data)).to be(true)
    end    
  end

  describe "#get_api_keys" do
    it "returns all API keys" do
      keys = r.get_api_keys
      expect(keys.length).to be(2)
      keys.each do |key| 
        expect(key.key).to match(/[a-zA-Z0-9]*/)
      end
    end    
  end

  describe "#create_api_key" do
    it "creates an API key" do
      $api_key = r.create_api_key
      expect($api_key).to match(/[a-zA-Z0-9]*/)
      keys = r.get_api_keys
      expect(keys.length).to be(3)
      expect(keys.any? { |k| k.key == $api_key }).to be(true)
    end
  end

  describe "#delete_api_key" do
    it "deletes an API key" do
      expect($api_key).not_to be_empty
      r.delete_api_key($api_key)
      keys = r.get_api_keys
      expect(keys.length).to be(2)
      expect(keys.any? { |k| k.key == $api_key }).to be(false)
    end
  end

  describe "#get_account_settings" do
    it "gets trial settings" do
      canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/get_account_settings_trial.json'
      stub_request(:get, "https://api.reporting.cloud/v1/account/settings").to_return(:body => canned_response)
      
      as = r.get_account_settings

      # Check attributes
      expect(as.serial_number).to be(:trial)
      expect(as.created_documents).to be(7)
      expect(as.uploaded_templates).to be(2)
      expect(as.max_documents).to be(30000)
      expect(as.max_templates).to be(100)
      expect(as.valid_until).to eq(DateTime.iso8601("2016-07-03T16:13:13+00:00"))
    end    

    it "gets paid version settings" do
      canned_response = File.new File.dirname(__FILE__) + '/../support/fixtures/get_account_settings_sn.json'
      stub_request(:get, "https://api.reporting.cloud/v1/account/settings").to_return(:body => canned_response)
      
      as = r.get_account_settings

      # Check attributes
      expect(as.serial_number).to eq("3546372837463")
      expect(as.created_documents).to be(7)
      expect(as.uploaded_templates).to be(2)
      expect(as.max_documents).to be(30000)
      expect(as.max_templates).to be(100)
      expect(as.valid_until).to eq(DateTime.iso8601("2016-05-30T12:07:45+00:00"))
    end
  end

  describe "#template_exists" do
    it "returns true for existing template names" do
      templates = r.list_templates
      expect(r.template_exists?(templates[0].template_name)).to be(true)
    end
    
    it "returns false for non existing template names" do
      expect(r.template_exists?("sdfsdfsdfsdf.fsdf")).to be(false)
    end
  end

  def is_pdf(data)
    # Check for PDF magic number
    return data[0].ord == 0x25 &&
      data[1].ord == 0x50 &&
      data[2].ord == 0x44 &&
      data[3].ord == 0x46
  end

  def is_doc(data)
    return data[0].ord == 0xD0 &&
      data[1].ord == 0xCF &&
      data[2].ord == 0x11 &&
      data[3].ord == 0xE0 &&
      data[4].ord == 0xA1 &&
      data[5].ord == 0xB1 &&
      data[6].ord == 0x1A &&
      data[7].ord == 0xE1
  end

  describe "#convert_document" do
    it "converts the document to pdf" do
      dataB64 = r.convert_document(template_data_B64)
      data = Base64.strict_decode64(dataB64)
      expect(is_pdf(data)).to be(true)
    end
    
    it "converts the document to doc" do
      dataB64 = r.convert_document(template_data_B64, :doc)
      data = Base64.strict_decode64(dataB64)
      
      # Check for DOC magic number
      expect(is_doc(data)).to be(true)
    end
  end

  describe "#upload_template" do
    it "uploads a template" do
      r.upload_template("__ruby_wrapper_test.tx", template_data_B64)
      expect(r.template_exists?("__ruby_wrapper_test.tx")).to be(true)   
    end
  end
  
  describe "#get_template_page_count" do
    it "counts three pages" do
      expect(r.get_template_page_count("__ruby_wrapper_test.tx")).to be(3)
    end
  end
  
  describe "#download_template" do
    it "downloads a template" do
      downloaded = r.download_template("__ruby_wrapper_test.tx")
      expect(downloaded).to eq(template_data_B64)
    end
  end
  
  describe "#delete_template" do
    it "deletes a template" do
      templates = r.list_templates
      expect(templates.any? { |t| t.template_name == "__ruby_wrapper_test.tx" }).to be (true)
      r.delete_template("__ruby_wrapper_test.tx")
      templates = r.list_templates
      expect(templates.any? { |t| t.template_name == "__ruby_wrapper_test.tx" }).to be (false)
    end
  end

  describe "#find_and_replace" do
    # Adapt template name and replaced strings to one of your templates.
    it "replaces two substrings correctly" do            
      template_name = "invoice.tx"
      templates = r.list_templates
      expect(templates.any? { |t| t.template_name == template_name }).to be(true)
      find_and_replace_body = TXTextControl::ReportingCloud::FindAndReplaceBody.new([["Quick Facts", "Awesome Facts"], ["Total Due", "IOU"]])
      result_b64 = r.find_and_replace(find_and_replace_body, template_name, :html, true)
      html = Base64.strict_decode64(result_b64)
      expect(html).to include("Awesome Facts")
      expect(html).to include("IOU")
      expect(html).not_to include("Quick Facts")
      expect(html).not_to include("Total Due")
    end
  end  

  describe "#list_fonts" do
    it "returns an array of strings" do
      fonts = r.list_fonts
      expect(fonts).to all(be_a(String))
    end    
  end  

  describe "#check_text" do
    it "returns expected incorrect words" do
      incorrect_words = r.check_text("Thiss is a testt", "en_US.dic")
      expect(incorrect_words.length).to be(2)
      word = incorrect_words[0]
      expect(word.length).to be(5)
      expect(word.start).to be(0)
      expect(word.text).to eq("Thiss")
      expect(word.is_duplicate?).to be(false)
      expect(word.language).to eq("en_US.dic")
      word = incorrect_words[1]
      expect(word.length).to be(5)
      expect(word.start).to be(11)
      expect(word.text).to eq("testt")
      expect(word.is_duplicate?).to be(false)
      expect(word.language).to eq("en_US.dic")
    end

    it "raises ArgumentError" do
      expect { r.check_text(nil, "en_US.dic") }.to raise_error(ArgumentError)
      expect { r.check_text("foo bar", nil) }.to raise_error(ArgumentError)
    end
  end

  describe "#get_available_dictionaries" do
    it "returns all available dictionaries" do
      dictionaries = r.get_available_dictionaries
      expect(dictionaries).not_to be_empty 
      expect(dictionaries).to all(be_a(String))
      expect(dictionaries).to include("en_US.dic", "fr.dic", "en_GB.dic")
    end
  end

  describe "#get_suggestions" do
    it "returns correct suggestions" do
      sug = r.get_suggestions("Thiss", "en_US.dic", 10)
      expect(sug).not_to be_empty
      expect(sug.length).to eq(10)
      expect(sug).to all(be_a(String))
      expect(sug[0]).to eq("This")
      expect(sug[1]).to eq("Hiss")
      expect(sug[2]).to eq("Thesis")
    end

    it "raises ArgumentError" do
      expect { r.get_suggestions() }.to raise_error(ArgumentError)
      expect { r.get_suggestions(nil, "en_US.dic", 10) }.to raise_error(ArgumentError)
      expect { r.get_suggestions("Thiss", nil, 10) }.to raise_error(ArgumentError)
      expect { r.get_suggestions("Thiss", "en_US.dic", "bla") }.to raise_error(ArgumentError)
      expect { r.get_suggestions("Thiss", "en_US.dic") }.to raise_error(ArgumentError)
    end
  end
end
