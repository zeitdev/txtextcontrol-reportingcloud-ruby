require "uri"
require "net/http"
require "json"
require "ostruct"
require "cgi"
require 'txtextcontrol/reportingcloud/template'
require 'txtextcontrol/reportingcloud/account_settings'
require 'txtextcontrol/reportingcloud/template_name_validator'
require 'txtextcontrol/reportingcloud/template_data_validator'
require 'core_ext/string'

module TXTextControl
  module ReportingCloud
  
    # The main wrapper class.
    # @attr username [String] The user name.
    # @attr password [String] The password.
    # @attr base_uri [String] The API base url. Is set to "http://api.reporting.cloud" 
    #   by default.
    # @attr api_version [String] The API version. Is set to "v1" by default.
    # @attr read_timeout [Integer] The timeout for HTTP requests in seconds. Is set to
    #   10 by default.
    # @author Thorsten Kummerow
    class ReportingCloud
      attr_accessor :username
      attr_accessor :password
      attr_accessor :base_uri
      attr_accessor :api_version
      attr_accessor :read_timeout
                   
      # @param username [String] The user name.
      # @param password [String] The password.
      # @param base_url [String] The API base url. Is set to "http://api.reporting.cloud" 
      #   by default.
      def initialize(username, password, base_url = nil)
        base_url ||= DEFAULT_BASE_URI
        @username = username
        @password = password
        @api_version = DEFAULT_VERSION
        @read_timeout = DEFAULT_TIMEOUT   
        @base_uri = URI.parse(base_url)
      end
      
      # Lists all templates from the template storage.
      # @return [Array<Template>] An array of Template objects.
      def list_templates
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
      def get_template_count
        res = request("/templates/count", :get)
        if res.kind_of? Net::HTTPSuccess
          return Integer(res.body)
        else
          raise res.body
        end
      end
      
      # Merges and returns a template from the template storage or an 
      # uploaded template with JSON data.
      # @param return_format [Symbol] The format of the created document. Possible 
      #   values are :pdf, :rtf, :doc, :docx, :html and :tx.
      # @param merge_body [MergeBody] The MergeBody object contains the datasource 
      #   as a JSON data object and optionally, a template encoded as a Base64 string.
      # @param template_name [String] The name of the template in the template storage. 
      #   If no template name is specified, the template must be uploaded in the 
      #   MergeBody object of this request.
      # @param append [Boolean]  
      # @return [Array<String>] An array of the created documents as 
      #   Base64 encoded strings. 
      def merge(merge_body, template_name = nil, return_format = :pdf, append = false)
        if !template_name.to_s.empty? && !merge_body.template.nil?   # .to_s.empty: check for nil or ''
          raise ArgumentError, "Template name and template data must not be present at the same time."
        elsif template_name.to_s.empty? && merge_body.template.nil?
          raise ArgumentError, "Either a template name or template data have to be present."
        end
        
        # Create query parameters
        params = {
          :returnFormat => return_format,
          :append => append
        }
        unless template_name.to_s.empty? 
          params[:templateName] = template_name
        end
        
        # Send request
        res = request("/document/merge", :post, params, merge_body)
        if res.kind_of? Net::HTTPSuccess
          return JSON.parse(res.body)
        else
          raise res.body 
        end        
      end
      
      # Returns the account settings.
      # @return [AccountSettings] The account settings.
      def get_account_settings
        res = request("/account/settings", :get)
        if res.kind_of? Net::HTTPSuccess
          return AccountSettings.from_camelized_hash(JSON.parse(res.body))
        else
          raise res.body 
        end
      end      
      
      # Returns a list of thumbnails of a specific template.
      # @param template_name [String] The filename of the template in the template storage.
      # @param zoom_factor [Integer] An Integer value between 1 and 400 to set the
      #   percentage zoom factor of the created thumbnail images.
      # @param from_page [Integer] An Integer value that specifies the first page.
      # @param to_page [Integer] An Integer value that specifies the last page.
      # @param image_format [Symbol] Defines the image format of the returned thumbnails.
      #   Possible values are :png, :jpg, :gif and :bmp.
      # @return [Array<String>] An array of Base64 encoded images.
      def get_template_thumbnails(template_name, zoom_factor, from_page = 1, to_page = 0, image_format = :png)
        # Prepare query parameters
        params = {
          :templateName => template_name,
          :zoomFactor => zoom_factor,
          :fromPage => from_page,
          :toPage => to_page,
        }
        if image_format != :png
          params[:imageFormat] = image_format 
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
      # @param template_name [String] The filename of the template to be deleted 
      #   from the template storage.
      # @return [void]
      def delete_template(template_name)
        # Parameter validation
        TemplateNameValidator.validate(template_name)
        
        res = request("/templates/delete", :delete, { :templateName => template_name })
        unless res.kind_of? Net::HTTPSuccess
          raise res.body 
        end
      end
      
      # Stores an uploaded template in the template storage (*.doc, *.docx, *.rtf and *.tx)
      # @param template_name [String] The filename of the template in the template storage.
      #   Existing files with the same filename will be overwritten.
      # @param template_data [String] A document encoded as a Base64 string. 
      #   The supported formats are DOC, DOCX, RTF and TX.
      # @return [void]
      def upload_template(template_name, template_data)
        # Parameter validation
        TemplateNameValidator.validate(template_name)
        TemplateDataValidator.validate(template_data)
        
        res = request("/templates/upload", :post, { :templateName => template_name }, template_data)
        unless res.kind_of? Net::HTTPSuccess
          raise res.body 
        end        
      end
      
      # Returns the selected template from the storage.
      # @param template_name [String] The filename of the template in the template storage.
      # @return [String] The template document data as a Base64 encoded string.
      def download_template(template_name)
        # Parameter validation
        TemplateNameValidator.validate(template_name)

        res = request("/templates/download", :get, { :templateName => template_name })        
        if res.kind_of? Net::HTTPSuccess
          return res.body.remove_first_and_last
        else
          raise res.body
        end
      end
      
      # Checks whether a template exists in the template storage.
      # @param template_name [String] The filename of the template to be 
      #   checked for availability in the template storage.
      # @return [Boolean] Returns if the template with the given name exists in
      #   the template storage.
      def template_exists?(template_name)
        # Parameter validation
        TemplateNameValidator.validate(template_name)

        res = request("/templates/exists", :get, { :templateName => template_name })                       
        if res.kind_of? Net::HTTPSuccess
          case res.body
            when "true"
              return true
            when "false"
              return false
            else raise "Unknown response value received." 
          end
        else
          raise res.body
        end
      end
      
      # Returns the number of pages of a template in the template storage.
      # @param template_name [String] The filename of the template in the template
      #   storage to retrieve the number of pages for.
      # @return [Integer] The number of pages in the template.
      def get_template_page_count(template_name)
        # Parameter validation
        TemplateNameValidator.validate(template_name)
        
        res = request("/templates/pagecount", :get, { :templateName => template_name })
        if res.kind_of? Net::HTTPSuccess
          return Integer(res.body)
        else
          raise res.body
        end        
      end
      
      # Converts a document to another format.
      # @param template_data [String] The source document encoded as a Base64 string. 
      #   The supported document formats are .rtf, .doc, .docx, .html, .pdf and .tx.
      # @param return_format [Symbol] The format of the created document.
      #   Possible values are: :pdf, :rtf, :doc, :docx, :html and :tx.
      # @return [String] The created document encoded as a Base64 string.
      def convert(template_data, return_format = :pdf)
        # Parameter validation
        TemplateDataValidator.validate(template_data)
        
        res = request("/document/convert", :post, { :returnFormat => return_format }, template_data)
        if res.kind_of? Net::HTTPSuccess
          # Remove leading and trailing quote from string 
          # (inexplicably JSON.parse chokes on simple strings)
          return res.body.remove_first_and_last
        else
          raise res.body 
        end                
      end
      
      # Performs a HTTP request of a given type.
      # @param request_type [Symbol] The type of the request. Possible values are :get, 
      # :post and :delete.
      # @param params [Hash] The query parameters.
      # @param body [Object, Hash, String] 
      # @return [Net::HTTPResponse] The HTTP response.
      private
      def request(request_uri, request_type = :get, params = nil, body = nil)
        # Generate query string from given parameters
        query_string = query_string_from_hash(params)
        
        http = Net::HTTP.new(@base_uri.host, @base_uri.port)
        http.read_timeout = read_timeout
        
        # Get correct request type
        req_type = nil
        case request_type
          when :get
            req_type = Net::HTTP::Get
          when :post
            req_type = Net::HTTP::Post
          when :delete 
            req_type = Net::HTTP::Delete
          else raise "Unknown HTTP request type."
        end 
        
        # Create HTTP request
        req = req_type.new("/#{@api_version}#{request_uri}#{query_string}", initheader = { "Content-Type" => "application/json" })
        req.basic_auth(@username, @password);
        # If body data is present, use it directly if it is a string or 
        # else convert it to json
        if !body.nil?
          if body.kind_of? String
            req.body = "\"" + body + "\""
          elsif body.kind_of? Hash
            req.body = body.to_json
          elsif body.respond_to?(:to_camelized_hash)
            req.body = body.to_camelized_hash.to_json
          elsif body.respond_to?(:to_hash)
            req.body = body.to_hash.to_json
          end
        end
        # Send request
        return http.request(req)
      end
      
      # Generates a query string from a hash
      private
      def query_string_from_hash(hash)
        return "?" + hash.collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&') unless hash.nil?
        return ""
      end
      
    end    
  end
end
