require 'spec_helper'
require "txtextcontrol/reportingcloud/merge_field"

describe TXTextControl::ReportingCloud::MergeField do
  let (:hash) {
    {
        "dateTimeFormat" => "DATE TIME FORMAT",
        "name" => "FIELD NAME",
        "numericFormat" => "NUMERIC FORMAT",
        "preserveFormatting" => true,
        "text" => "FIELD TEXT",
        "textAfter" => "TEXT AFTER",
        "textBefore" => "TEXT BEFORE"    
    }
  }

  describe ".from_camelized_hash" do
    it "creates an instance from a hash using camel case attributes" do
      field = TXTextControl::ReportingCloud::MergeField::from_camelized_hash(hash)
      expect(field.date_time_format).to eq("DATE TIME FORMAT")
      expect(field.name).to eq("FIELD NAME")
      expect(field.numeric_format).to eq("NUMERIC FORMAT")
      expect(field.preserve_formatting).to be true
      expect(field.text).to eq("FIELD TEXT")
      expect(field.text_after).to eq("TEXT AFTER")
      expect(field.text_before).to eq("TEXT BEFORE")
    end

    it "Accepts nil as date_time_format" do
      hash["dateTimeFormat"] = nil
      field = nil
      expect { field = TXTextControl::ReportingCloud::MergeField::from_camelized_hash(hash) }.not_to raise_error
      expect(field.date_time_format).to be nil
    end    

    it "Accepts nil as numeric_format" do
      hash["numericFormat"] = nil
      field = nil      
      expect { field = TXTextControl::ReportingCloud::MergeField::from_camelized_hash(hash) }.not_to raise_error
      expect(field.numeric_format).to be nil
    end    

    it "Accepts nil as text_after" do
      hash["textAfter"] = nil
      field = nil      
      expect { field = TXTextControl::ReportingCloud::MergeField::from_camelized_hash(hash) }.not_to raise_error
      expect(field.text_after).to be nil
    end    

    it "Accepts nil as text_before" do
      hash["textBefore"] = nil
      field = nil      
      expect { field = TXTextControl::ReportingCloud::MergeField::from_camelized_hash(hash) }.not_to raise_error
      expect(field.text_before).to be nil
    end    
  end
end