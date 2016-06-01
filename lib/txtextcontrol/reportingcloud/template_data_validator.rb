module TXTextControl
  module ReportingCloud
    class TemplateDataValidator
      def self.validate(templateData)
        raise ArgumentError, "Template data must be a Base64 encoded string." if !templateData.kind_of? String
        raise ArgumentError, "No template data given." if templateData.to_s.empty?
      end
    end
  end
end