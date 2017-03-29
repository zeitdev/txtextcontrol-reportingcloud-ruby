require 'spec_helper'
require "txtextcontrol/reportingcloud/template"

describe TXTextControl::ReportingCloud::Template do
  describe "#initialize" do
    it "creates a Template instance converting a string to a DateTime object" do
      t = TXTextControl::ReportingCloud::Template.new("Name", "2016-05-30T12:07:45+00:00", 23456)
      expect(t.size).to be(23456)
      expect(t.template_name).to eq("Name")
      expect(t.modified).to eq(DateTime.iso8601("2016-05-30T12:07:45+00:00"))
    end
  end
end