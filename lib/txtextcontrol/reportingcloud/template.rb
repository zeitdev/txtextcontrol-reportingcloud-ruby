require 'date'

module TXTextControl
  module ReportingCloud
    class Template
      attr_reader :templateName
      attr_reader :modified
      
      def initialize(templateName, modified)
        @templateName = templateName
        if modified.is_a?(DateTime)
          @modified = modified
        else
          @modified = DateTime.iso8601(modified) 
        end
      end      
    end
  end
end