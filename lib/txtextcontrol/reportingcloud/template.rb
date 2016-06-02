require 'date'

module TXTextControl
  module ReportingCloud
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