require 'spec_helper'
require "txtextcontrol/reportingcloud/template_info"

describe TXTextControl::ReportingCloud::TemplateInfo do
  let (:canned_response) { File.open(File.dirname(__FILE__) + '/../support/fixtures/get_template_info.json', 'rb') { |f| f.read } }

  describe ".from_camelized_hash" do
    it "creates an instance from a hash using camel case attributes" do
      info = TXTextControl::ReportingCloud::TemplateInfo::from_camelized_hash(JSON.parse(canned_response))
      expect(info.template_name).to eq("invoice.tx")
      expect(info.merge_blocks.length).to eq(1)
      expect(info.merge_blocks[0].name).to eq("Sales_SalesOrderDetail")
      expect(info.merge_fields.length).to eq(15)
      expect(info.merge_fields[5].name).to eq("Customer_Customer.Sales_CustomerAddress.Person_Address.City")
      expect(info.merge_blocks[0].merge_blocks.length).to eq(0)
    end
  end
end
