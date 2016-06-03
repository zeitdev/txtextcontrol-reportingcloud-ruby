module TXTextControl
  module ReportingCloud
  
    # Internal method parameter validator class.
    class TemplateDataValidator
    
      # Checks if a given value is a String, is not nil and not empty.
      # @param template_data [String] The string to validate.
      # @return [Boolean]
      def self.validate(template_data)
        raise ArgumentError, "Template data must be a Base64 encoded string." if !template_data.kind_of? String
        raise ArgumentError, "No template data given." if template_data.to_s.empty?
      end
    end
  end
end