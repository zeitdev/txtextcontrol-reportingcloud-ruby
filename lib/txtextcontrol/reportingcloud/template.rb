require 'date'

module TXTextControl
  module ReportingCloud
  
    # @attr_reader template_name [String] The template file name.
    # @attr_reader modified [DateTime] The date and time the template file was
    #   last modified.
    # @attr_reader size [Integer] The size of the template file in bytes.
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