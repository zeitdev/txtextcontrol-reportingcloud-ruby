require 'spec_helper'
require "txtextcontrol/reportingcloud/document_settings"

describe TXTextControl::ReportingCloud::DocumentSettings do
  describe "#creation_date" do
    before do
      @ds = TXTextControl::ReportingCloud::DocumentSettings.new
    end
    
    it "accepts an iso 8601 date time string" do
      str = "2016-05-30T12:07:45+00:00"
      expect { @ds.creation_date = str }.not_to raise_error
      expect(@ds.creation_date).to eq(DateTime.iso8601(str))
    end
    
    it "accepts nil" do
      expect { @ds.creation_date = nil }.not_to raise_error
      expect(@ds.creation_date).to be(nil)
    end
    
    it "accepts a DateTime instance" do
      dt = DateTime.iso8601("2016-05-30T12:07:45+00:00")
      expect { @ds.creation_date = dt }.not_to raise_error
      expect(@ds.creation_date).to eq(dt)
    end
    
    it "raises ArgumentError on invalid date time string" do
      expect { @ds.creation_date = "sdfsdfsdf" }.to raise_error(ArgumentError)
    end
  end

  describe "#last_modification_date" do
    before do
      @ds = TXTextControl::ReportingCloud::DocumentSettings.new
    end
    
    it "accepts an iso 8601 date time string" do
      str = "2016-05-30T12:07:45+00:00"
      expect { @ds.last_modification_date = str }.not_to raise_error
      expect(@ds.last_modification_date).to eq(DateTime.iso8601(str))
    end
    
    it "accepts nil" do
      expect { @ds.last_modification_date = nil }.not_to raise_error
      expect(@ds.last_modification_date).to be(nil)
    end
    
    it "accepts a DateTime instance" do
      dt = DateTime.iso8601("2016-05-30T12:07:45+00:00")
      expect { @ds.last_modification_date = dt }.not_to raise_error
      expect(@ds.last_modification_date).to eq(dt)
    end
    
    it "raises ArgumentError on invalid date time string" do
      expect { @ds.last_modification_date = "sdfsdfsdf" }.to raise_error(ArgumentError)
    end

  end
end