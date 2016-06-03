require 'spec_helper'
require "txtextcontrol/reportingcloud/merge_body"

describe TXTextControl::ReportingCloud::MergeBody do
  describe "#to_camelized_hash" do
    it "converts a MergeBody instance to a hash with camel case keys" do
      s = TXTextControl::ReportingCloud::MergeSettings.new
      merge_data = [
        { "Test" => "Test" },
        { "Test" => "Test" }
      ]
      b = TXTextControl::ReportingCloud::MergeBody.new(merge_data, s, "test")
      h = b.to_camelized_hash
      expect(h).to have_key("mergeData")
      expect(h).to have_key("template")
      expect(h).to have_key("mergeSettings")
      expect(h["mergeSettings"]).to be_kind_of(Hash)
    end
  end
end
