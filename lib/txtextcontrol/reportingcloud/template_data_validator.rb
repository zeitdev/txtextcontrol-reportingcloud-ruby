module TXTextControl
  module ReportingCloud
    class TemplateDataValidator
      def self.validate(template_data)
        raise ArgumentError, "Template data must be a Base64 encoded string." if !template_data.kind_of? String
        raise ArgumentError, "No template data given." if template_data.to_s.empty?
      end
    end
  end
end