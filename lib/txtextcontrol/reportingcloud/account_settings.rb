module TXTextControl
  module ReportingCloud
  
    # Represents ReportingCloud account settings.
    # @author Thorsten Kummerow
    # @attr_reader [String, Symbol] serial_number The serial number that is attached to the 
    #   account. Possible values are :free, :trial and a 13 character long serial number.
    # @attr_reader [Integer] created_documents The number of created documents in the 
    #   current month.
    # @attr_reader [Integer] uploaded_templates The number of uploaded templates to the 
    #   template storage.
    # @attr_reader [Integer] max_documents The maximum number of documents that can be 
    #   created per month.
    # @attr_reader [Integer] max_templates The maximum number of templates that can be 
    #   uploaded to the template storage.
    # @attr_reader [DateTime] valid_until The date until the current subscription is valid.
    #   Can be nil.
    class AccountSettings
      attr_reader :serial_number
      attr_reader :created_documents
      attr_reader :uploaded_templates
      attr_reader :max_documents
      attr_reader :max_templates
      attr_reader :valid_until
      
      # @param [String, Symbol] serial_number The serial number that is attached to the 
      #   account. Possible values are :free, :trial and a 13 character long serial number.
      # @param [Integer] created_documents The number of created documents in the 
      #   current month.
      # @param [Integer] uploaded_templates The number of uploaded templates to the 
      #   template storage.
      # @param [Integer] max_documents The maximum number of documents that can be 
      #   created per month.
      # @param [Integer] max_templates The maximum number of templates that can be 
      #   uploaded to the template storage.
      # @param [DateTime] valid_until The date until the current subscription is valid.
      #   Can be nil.
      def initialize(serial_number, created_documents, uploaded_templates, max_documents, max_templates, valid_until = nil)
        case serial_number.downcase
          when "trial"
            @serial_number = :trial
          when "free"
            @serial_number = :free
          else 
            @serial_number = serial_number
        end                
        @created_documents = Integer(created_documents)
        @uploaded_templates = Integer(uploaded_templates)
        @max_documents = Integer(max_documents)
        @max_templates = Integer(max_templates)
        case valid_until
          when DateTime
            @valid_until = valid_until
          when String
            @valid_until = DateTime.iso8601(valid_until)
          else
            @valid_until = nil      
        end
      end
      
      # Creates an AccountSettings instance from a hash.
      # @param [Hash] hash The hash to try and create an AccountSettings instance from.
      # @return [AccountSettings] A newly created AccountSettings instance.
      def self.from_camelized_hash(hash)
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
