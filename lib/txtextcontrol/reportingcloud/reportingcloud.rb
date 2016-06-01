require "uri"
require "net/http"
require "json"
require "ostruct"
require "cgi"
require 'txtextcontrol/reportingcloud/template'
require 'txtextcontrol/reportingcloud/account_settings'
require 'txtextcontrol/reportingcloud/template_name_validator'

module TXTextControl
  module ReportingCloud
    class ReportingCloud
      attr_accessor :username
      attr_accessor :password
      attr_accessor :baseUri
      attr_accessor :apiVersion
            
      def initialize(username, password, baseUrl = nil)
        baseUrl ||= DEFAULT_BASE_URI
        @username = username
        @password = password
        @apiVersion = DEFAULT_VERSION        
        @baseUri = URI.parse(baseUrl)
      end
      
      # Lists all templates from the template storage.
      # @return [Array<Template>] An array of Template objects.
      def listTemplates
        res = request("/templates/list", :get)
        if res.kind_of? Net::HTTPSuccess
          templates = Array.new
          data = JSON.parse(res.body, object_class: OpenStruct)
          data.each do |elem|
            templates.push(Template.new(elem.templateName, elem.modified, elem.size))
          end
          return templates
        else
          raise res.body
        end
      end
      
      # Returns the number of templates in the template storage.
      # @return [Integer] The number of templates in the template storage.
      def getTemplateCount
        res = request("/templates/count", :get)
        if res.kind_of? Net::HTTPSuccess
          return Integer(res.body)
        else
          raise res.body
        end
      end
      
      # Merges and returns a template from the template storage or an 
      # uploaded template with JSON data.
      # @param returnFormat [Symbol] The format of the created document. Possible 
      #   values are :pdf, :rtf, :doc, :docx, :html and :tx.
      # @param mergeBody [MergeBody] The MergeBody object contains the datasource 
      #   as a JSON data object and optionally, a template encoded as a Base64 string.
      # @param templateName [String] The name of the template in the template storage. 
      #   If no template name is specified, the template must be uploaded in the 
      #   MergeBody object of this request.
      # @param append [Boolean]  
      # @return [Array<String>] An array of the created documents as 
      #   Base64 encoded strings. 
      def merge(mergeBody, templateName = nil, returnFormat = :pdf, append = false)
        if !templateName.to_s.empty? && !mergeBody.template.nil?   # .to_s.empty: check for nil or ''
          raise ArgumentError, "Template name and template data must not be present at the same time."
        elsif templateName.to_s.empty? && mergeBody.template.nil?
          raise ArgumentError, "Either a template name or template data have to be present."
        end
        
        # Create query parameters
        params = {
          :returnFormat => returnFormat,
          :append => append
        }
        unless templateName.to_s.empty? 
          params[:templateName] = templateName
        end
        
        # Send request
        res = request("/document/merge", :post, params, mergeBody)
        if res.kind_of? Net::HTTPSuccess
          return JSON.parse(res.body)
        else
          raise res.body 
        end        
      end
      
      # Returns the account settings.
      # @return [AccountSettings] The account settings.
      def getAccountSettings
        res = request("/account/settings", :get)
        if res.kind_of? Net::HTTPSuccess
          return AccountSettings.from_hash(JSON.parse(res.body))
        else
          raise res.body 
        end
      end      
      
      # Returns a list of thumbnails of a specific template.
      # @param templateName [String] The filename of the template in the template storage.
      # @param zoomFactor [Integer] An Integer value between 1 and 400 to set the
      #   percentage zoom factor of the created thumbnail images.
      # @param fromPage [Integer] An Integer value that specifies the first page.
      # @param toPage [Integer] An Integer value that specifies the last page.
      # @param imageFormat [Symbol] Defines the image format of the returned thumbnails.
      #   Possible values are :png, :jpg, :gif and :bmp.
      # @return [Array<String>] An array of Base64 encoded images.
      def getTemplateThumbnails(templateName, zoomFactor, fromPage = 1, toPage = 0, imageFormat = :png)
        # Prepare query parameters
        params = {
          :templateName => templateName,
          :zoomFactor => zoomFactor,
          :fromPage => fromPage,
          :toPage => toPage,
        }
        if imageFormat != :png
          params[:imageFormat] = imageFormat 
        end
        
        # Send request
        res = request("/templates/thumbnails", :get, params)
        if res.kind_of? Net::HTTPSuccess
          return JSON.parse(res.body)
        else
          raise res.body
        end        
      end
      
      # Deletes a template from the template storage.
      # @param templateName [String] The filename of the template to be deleted 
      #   from the template storage.
      def deleteTemplate(templateName)
        # Parameter validation
        TemplateNameValidator.validate(templateName)
        
        res = request("/templates/delete", :delete, { :templateName => templateName })
        unless res.kind_of? Net::HTTPSuccess
          raise res.body 
        end
      end
      
      # Stores an uploaded template in the template storage (*.doc, *.docx, *.rtf and *.tx)
      # @param templateName [String] The filename of the template in the template storage.
      #   Existing files with the same filename will be overwritten.
      # @param templateData [String] A document encoded as a Base64 string. 
      #   The supported formats are DOC, DOCX, RTF and TX.
      def uploadTemplate(templateName, templateData)
        # Parameter validation
        TemplateNameValidator.validate(templateName)
        raise ArgumentError, "Template data must be a Base64 encoded string." if !templateData.kind_of? String
        raise ArgumentError, "No template data given." if templateData.to_s.empty?
        
        res = request("/templates/upload", :post, { :templateName => templateName }, templateData)
        unless res.kind_of? Net::HTTPSuccess
          raise res.body 
        end        
      end
      
      # Checks whether a template exists in the template storage.
      # @param templateName [String] The filename of the template to be 
      #   checked for availability in the template storage.
      # @return [Boolean] Returns if the template with the given name exists in
      #   the template storage.
      def templateExists?(templateName)
        # Parameter validation
        TemplateNameValidator.validate(templateName)

        res = request("/templates/exists", :get, { :templateName => templateName })                       
        if res.kind_of? Net::HTTPBadRequest then return false
        elsif res.kind_of? Net::HTTPSuccess then return true
        else raise res.body 
        end        
      end
      
      # Returns the number of pages of a template in the template storage.
      # @param templateName [String] The filename of the template in the template
      #   storage to retrieve the number of pages for.
      # @return [Integer] The number of pages in the template.
      def getTemplatePageCount(templateName)
        # Parameter validation
        TemplateNameValidator.validate(templateName)
        
        res = request("/templates/pagecount", :get, { :templateName => templateName })
        if res.kind_of? Net::HTTPSuccess
          return Integer(res.body)
        else
          raise res.body
        end        
      end
      
      # Performs a HTTP request of a given type.
      # @param requestType [Symbol] The type of the request. Possible values are :get, 
      # :post and :delete.
      # @param params [Hash] The query parameters.
      # @param body [Object, Hash, String] 
      # @return [Net::HTTPResponse] The HTTP response.
      private
      def request(requestUri, requestType = :get, params = nil, body = nil)
        # Generate query string from given parameters
        queryString = queryStringFromHash(params)
        
        http = Net::HTTP.new(@baseUri.host, @baseUri.port)
        
        # Get correct request type
        reqType = nil
        case requestType
          when :get
            reqType = Net::HTTP::Get
          when :post
            reqType = Net::HTTP::Post
          when :delete 
            reqType = Net::HTTP::Delete
          else raise "Unknown HTTP request type."
        end 
        
        # Create HTTP request
        req = reqType.new("/#{@apiVersion}#{requestUri}#{queryString}", initheader = { "Content-Type" => "application/json" })
        req.basic_auth(@username, @password);
        # If body data is present, use it directly if it is a string or 
        # convert it to json and set request body
        if !body.nil?
          if body.kind_of? String
            req.body = "\"" + body + "\""
          elsif body.kind_of? Hash
            req.body = body.to_json
          elsif body.respond_to?(:to_hash)
            req.body = body.to_hash.to_json
          end
        end
        # Send request
        return http.request(req)
      end
      
      # Generates a query string from a hash
      private
      def queryStringFromHash(hash)
        return "?" + hash.collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&') unless hash.nil?
        return ""
      end
      
    end
  end
end