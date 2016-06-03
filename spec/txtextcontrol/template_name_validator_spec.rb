require 'spec_helper'
require "txtextcontrol/reportingcloud/template_name_validator"

describe TXTextControl::ReportingCloud::TemplateNameValidator do
  describe ".validate" do
    it "raises error on empty string or nil" do
      expect { TXTextControl::ReportingCloud::TemplateNameValidator.validate("") }.to raise_error(ArgumentError)
      expect { TXTextControl::ReportingCloud::TemplateNameValidator.validate(nil) }.to raise_error(ArgumentError)
    end
    
    it "validates a valid string" do
      expect { TXTextControl::ReportingCloud::TemplateNameValidator.validate("not empty") }.not_to raise_error
    end
  end
end