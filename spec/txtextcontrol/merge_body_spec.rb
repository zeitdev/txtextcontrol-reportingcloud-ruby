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
  
  describe "#merge_data" do
    it "raises ArgumentError in case of nil" do
      expect { merge_body = TXTextControl::ReportingCloud::MergeBody.new(nil) }.to raise_error(ArgumentError)
    end
    
    it "raises ArgumentError in case of empty array" do
      merge_data = []
      expect { merge_body = TXTextControl::ReportingCloud::MergeBody.new(merge_data) }.to raise_error(ArgumentError)
    end
    
    it "raises ArgumentError in case of wrong data type" do
      merge_data = "a string"
      expect { merge_body = TXTextControl::ReportingCloud::MergeBody.new(merge_data) }.to raise_error(ArgumentError)
    end
    
    it "raises ArgumentError in case of array of wrong data types" do
      merge_data = [
        "Test", 42
      ]
      expect { merge_body = TXTextControl::ReportingCloud::MergeBody.new(merge_data) }.to raise_error(ArgumentError)
    end
    
    it "accepts an array of hashes" do
      merge_data = [
        { "Test" => "Test" },
        { "Test" => "Test" }
      ]
      merge_body = nil
      expect { merge_body = TXTextControl::ReportingCloud::MergeBody.new(merge_data) }.not_to raise_error
    end
  end
end
