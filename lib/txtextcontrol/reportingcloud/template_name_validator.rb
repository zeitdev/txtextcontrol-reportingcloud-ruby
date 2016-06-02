module TXTextControl
  module ReportingCloud
  
    # Internal method parameter validator class.
    # @author Thorsten Kummerow
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