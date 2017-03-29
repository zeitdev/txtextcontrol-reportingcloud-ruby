require 'spec_helper'
require "txtextcontrol/reportingcloud/account_settings"

describe TXTextControl::ReportingCloud::AccountSettings do
  describe ".from_camelized_hash" do
    it "creates an instance from a hash using camel case attributes" do
      hash = {
        "serialNumber" => "1234567890123",
        "createdDocuments" => 2,
        "uploadedTemplates" => 3,
        "maxDocuments" => 40000,
        "maxTemplates" => 500,
        "validUntil" => "2016-05-24T15:24:57+00:00"
      }
      
      s = TXTextControl::ReportingCloud::AccountSettings::from_camelized_hash(hash)
      expect(s.serial_number).to eq("1234567890123")
      expect(s.created_documents).to be(2)
      expect(s.uploaded_templates).to be(3)
      expect(s.max_documents).to be(40000)
      expect(s.valid_until).to eq(DateTime.iso8601("2016-05-24T15:24:57+00:00"))
    end
  end
end