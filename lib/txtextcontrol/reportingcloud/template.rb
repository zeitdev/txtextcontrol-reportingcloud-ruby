module TXTextControl
  module ReportingCloud
    class Template
      attr_reader :fileName
      attr_reader :modified
      
      def initialize(fileName, modified)
        @fileName = fileName
        if modified.is_a?(DateTime)
          @modified = modified
        else
          @modified = DateTime.iso8601(modified) 
        end
      end      
    end
  end
end