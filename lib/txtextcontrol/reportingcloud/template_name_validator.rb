module TXTextControl
  module ReportingCloud
    class TemplateNameValidator
      def self.validate(templateName)
        raise ArgumentError, "Template name must be a String." if !templateName.kind_of? String 
        raise ArgumentError, "No template name given." if templateName.to_s.empty?
      end
    end
  end
end