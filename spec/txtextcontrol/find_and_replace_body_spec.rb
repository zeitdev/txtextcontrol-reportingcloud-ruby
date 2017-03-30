require 'spec_helper'
require "txtextcontrol/reportingcloud/find_and_replace_body"

describe TXTextControl::ReportingCloud::FindAndReplaceBody do
  it "raises ArgumentError on wrong kind of array passed as find_and_replace_data parameter." do
    expect { body = TXTextControl::ReportingCloud::FindAndReplaceBody.new([["Foo", "Bar"], ["Baz", "Qux"], ["Quux", "Quuz", "Corge"]]) }.to raise_error(ArgumentError)
    expect { body = TXTextControl::ReportingCloud::FindAndReplaceBody.new(nil) }.to raise_error(ArgumentError)
    expect { body = TXTextControl::ReportingCloud::FindAndReplaceBody.new([]) }.to raise_error(ArgumentError)    
  end  

  it "accepts valid array of find and relace values." do
    expect { body = TXTextControl::ReportingCloud::FindAndReplaceBody.new([["Foo", "Bar"]]) }.not_to raise_error
    expect { body = TXTextControl::ReportingCloud::FindAndReplaceBody.new([["Foo", "Bar"], ["Baz", "Qux"], ["Quux", "Quuz"]]) }.not_to raise_error
  end  
end
