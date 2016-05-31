module TXTextControl
  module ReportingCloud
    class AccountSettings
      attr_reader :serialNumber
      attr_reader :createdDocuments
      attr_reader :uploadedTemplates
      attr_reader :maxDocuments
      attr_reader :maxTemplates
      attr_reader :validUntil
      
      def initialize(serialNumber, createdDocuments, uploadedTemplates, maxDocuments, maxTemplates, validUntil = nil)
        @serialNumber = serialNumber
        @createdDocuments = createdDocuments
        @uploadedTemplates = uploadedTemplates
        @maxDocuments = maxDocuments
        @maxTemplates = maxTemplates
        @validUntil = validUntil
      end
    end
  end
end
