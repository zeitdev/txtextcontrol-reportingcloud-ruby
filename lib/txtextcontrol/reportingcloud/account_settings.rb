module TXTextControl
  module ReportingCloud
  
    # Represents ReportingCloud account settings.
    # @author T. Kummerow
    # @attr_reader [String, Symbol] serialNumber The serial number that is attached to the 
    #   account. Possible values are :free, :trial and a 13 character long serial number.
    # @attr_reader [Integer] createdDocuments The number of created documents in the 
    #   current month.
    # @attr_reader [Integer] uploadedTemplates The number of uploaded templates to the 
    #   template storage.
    # @attr_reader [Integer] maxDocuments The maximum number of documents that can be 
    #   created per month.
    # @attr_reader [Integer] maxTemplates The maximum number of templates that can be 
    #   uploaded to the template storage.
    # @attr_reader [DateTime] validUntil The date until the current subscription is valid.
    class AccountSettings
      attr_reader :serialNumber
      attr_reader :createdDocuments
      attr_reader :uploadedTemplates
      attr_reader :maxDocuments
      attr_reader :maxTemplates
      attr_reader :validUntil
      
      def initialize(serialNumber, createdDocuments, uploadedTemplates, maxDocuments, maxTemplates, validUntil = nil)
        case serialNumber.downcase
          when "trial"
            @serialNumber = :trial
          when "free"
            @serialNumber = :free
          else 
            @serialNumber = serialNumber
        end                
        @createdDocuments = Integer(createdDocuments)
        @uploadedTemplates = Integer(uploadedTemplates)
        @maxDocuments = Integer(maxDocuments)
        @maxTemplates = Integer(maxTemplates)
        case validUntil
          when DateTime
            @validUntil = validUntil
          when String
            @validUntil = DateTime.iso8601(validUntil)
          else
            @validUntil = nil      
        end
      end
      
      def self.from_hash(hash)
        sn = hash["serialNumber"]
        cd = hash["createdDocuments"]
        ut = hash["uploadedTemplates"]
        md = hash["maxDocuments"]
        mt = hash["maxTemplates"]
        vu = hash["validUntil"]
        return AccountSettings.new(sn, cd, ut, md, mt, vu)
      end
    end
  end
end
