# ReportingCloud Ruby SDK
#
# Official Ruby SDK for the ReportingCloud Web API. Authored, maintained and fully supported 
# by Text Control GmbH. (http://www.textcontrol.com).
#
# Go to http://www.reporting.cloud to learn more about ReportingCloud
# Go to https://github.com/TextControl/txtextcontrol-reportingcloud-ruby for the 
# canonical source repository.
#
# License: https://raw.githubusercontent.com/TextControl/txtextcontrol-reportingcloud-ruby/master/LICENSE.md
#
# Copyright: © 2019 Text Control GmbH

module TXTextControl
  module ReportingCloud
  
    # Internal method parameter validator class.
    # @author Thorsten Kummerow (@thomerow)
    class TemplateNameValidator
    
      # Checks if a given value is a String, is not nil and not empty.
      # @param template_name [String] The string to validate.
      # @return [Boolean]
      def self.validate(template_name)
        raise ArgumentError, "Template name must be a String." if !template_name.kind_of? String 
        raise ArgumentError, "No template name given." if template_name.to_s.empty?
      end
    end
  end
end