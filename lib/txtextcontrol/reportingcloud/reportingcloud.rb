require "uri"
require "net/http"
require "json"
require "ostruct"
require "cgi"
require 'txtextcontrol/reportingcloud/template'

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
      # return [Array<Template>] An array of Template objects.
      def listTemplates
        res = request("/templates/list", :get)
        if res.kind_of? Net::HTTPSuccess
          templates = Array.new
          data = JSON.parse(res.body, object_class: OpenStruct)
          data.each do |elem|
            templates.push(Template.new(elem.templateName, elem.modified))
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
      
      # Returns the account settings.
      # @return [AccountSettings] The account settings.
      def getAccountSettings
        res = request("/account/settings", :get)
        if res.kind_of? Net::HTTPSuccess
          # ToDo: implement
        else
          raise res.body 
        end
      end
      
      # Returns a list of thumbnails of a specific template.
      # @param templateName [String] The filename of the template in the template storage.
      # @param zoomFactor [Integer] An Integer value between 1 and 400 to set the
      #        percentage zoom factor of the created thumbnail images.
      # @param fromPage [Integer] An Integer value that specifies the first page.
      # @param toPage [Integer] An Integer value that specifies the last page.
      # @param imageFormat [Symbol] Defines the image format of the returned thumbnails.
      #        Possible values are :png, :jpg, :gif and :bmp.
      # @return [Array<String>] An array of Base64 encoded images.
      def getTemplateThumbnails(templateName, zoomFactor, fromPage = 1, toPage = 0, imageFormat = :png)
        # Prepare query parameters
        params = {
          "templateName" => templateName,
          "zoomFactor" => zoomFactor,
          "fromPage" => fromPage,
          "toPage" => toPage,
        }
        if imageFormat != :png
          params["imageFormat"] = imageFormat 
        end
        
        # Send request
        res = request("/templates/thumbnails", :get, params)
        if res.kind_of? Net::HTTPSuccess
          return JSON.parse(res.body)
        else
          raise res.body
        end        
      end
      
      # Performs a HTTP request of a given type.
      # @param requestType [Symbol] The type of the request. Possible values are :get, 
      # :post and :delete.
      # @return [Net::HTTPResponse] The HTTP response.
      private
      def request(requestUri, requestType = :get, params = nil)
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
        
        # Send HTTP request
        req = reqType.new("/#{@apiVersion}#{requestUri}#{queryString}", initheader = { "Content-Type" => "application/json" })
        req.basic_auth(@username, @password);
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