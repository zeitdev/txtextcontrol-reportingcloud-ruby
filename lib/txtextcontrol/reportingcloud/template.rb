# ReportingCloud Ruby Wrapper
#
# Official wrapper (authored by Text Control GmbH, publisher of ReportingCloud) to access 
# ReportingCloud in Ruby.
#
# Go to http://www.reporting.cloud to learn more about ReportingCloud
# Go to https://github.com/TextControl/txtextcontrol-reportingcloud-ruby for the 
# canonical source repository.
#
# License: https://raw.githubusercontent.com/TextControl/txtextcontrol-reportingcloud-ruby/master/LICENSE.md
#
# Copyright: © 2016 Text Control GmbH

require 'date'

module TXTextControl
  module ReportingCloud
  
    # Holds information about a template in the template storage.
    # @attr_reader template_name [String] The template file name.
    # @attr_reader modified [DateTime] The date and time the template file was
    #   last modified.
    # @attr_reader size [Integer] The size of the template file in bytes.
    # @author Thorsten Kummerow (@thomerow)
    class Template
      attr_reader :template_name
      attr_reader :modified
      attr_reader :size
      
      def initialize(template_name, modified, size)
        @template_name = template_name
        if modified.is_a?(DateTime)
          @modified = modified
        else
          @modified = DateTime.iso8601(modified) 
        end
        @size = size
      end      
    end
  end
end