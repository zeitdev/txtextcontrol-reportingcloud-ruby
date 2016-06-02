require 'spec_helper'
require "txtextcontrol/reportingcloud/merge_settings"

describe "#creation_date" do
  before do
    @ms = TXTextControl::ReportingCloud::MergeSettings.new
  end
  
  it "accepts an iso 8601 date time string" do
    str = "2016-05-30T12:07:45"
    expect { @ms.creation_date = str }.not_to raise_error
    expect(@ms.creation_date).to eq(DateTime.iso8601(str))
  end
  
  it "accepts nil" do
    expect { @ms.creation_date = nil }.not_to raise_error
    expect(@ms.creation_date).to be(nil)
  end
  
  it "accepts a DateTime instance" do
    dt = DateTime.iso8601("2016-05-30T12:07:45")
    expect { @ms.creation_date = dt }.not_to raise_error
    expect(@ms.creation_date).to eq(dt)
  end
  
  it "raises ArgumentError on invalid date time string" do
    expect { @ms.creation_date = "sdfsdfsdf" }.to raise_error(ArgumentError)
  end
end

describe "#last_modification_date" do
  before do
    @ms = TXTextControl::ReportingCloud::MergeSettings.new
  end
  
  it "accepts an iso 8601 date time string" do
    str = "2016-05-30T12:07:45"
    expect { @ms.last_modification_date = str }.not_to raise_error
    expect(@ms.last_modification_date).to eq(DateTime.iso8601(str))
  end
  
  it "accepts nil" do
    expect { @ms.last_modification_date = nil }.not_to raise_error
    expect(@ms.last_modification_date).to be(nil)
  end
  
  it "accepts a DateTime instance" do
    dt = DateTime.iso8601("2016-05-30T12:07:45")
    expect { @ms.last_modification_date = dt }.not_to raise_error
    expect(@ms.last_modification_date).to eq(dt)
  end
  
  it "raises ArgumentError on invalid date time string" do
    expect { @ms.last_modification_date = "sdfsdfsdf" }.to raise_error(ArgumentError)
  end
end
