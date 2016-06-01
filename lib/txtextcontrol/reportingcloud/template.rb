require 'date'

module TXTextControl
  module ReportingCloud
    class Template
      attr_reader :templateName
      attr_reader :modified
      attr_reader :size
      
      def initialize(templateName, modified, size)
        @templateName = templateName
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