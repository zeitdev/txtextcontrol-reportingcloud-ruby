require "uri"
require "net/http"
require "json"
require "ostruct"
require 'txtextcontrol/reportingcloud/template'

module TXTextControl
  module ReportingCloud
    class ReportingCloud
      attr_accessor :username
      attr_accessor :password
      attr_accessor :uri
      attr_accessor :apiVersion
            
      def initialize(username, password, url = nil)
        url ||= DEFAULT_BASE_URI
        @username = username
        @password = password
        @apiVersion = DEFAULT_VERSION        
        @uri = URI.parse(url)
      end
      
      # Lists all templates from the template storage.
      # return [Array<Template>] An array of Template objects.
      def listTemplates
        res = get("/templates/list")
        if res.kind_of? Net::HTTPSuccess
          templates = Array.new
          data = JSON.parse(res.body, object_class: OpenStruct)
          data.each do |elem|
            templates.push(Template.new(elem.Filename, elem.Modified))
          end
          return templates
        else
          raise res.body
        end
      end
      
      def getTemplateCount
        res = get("/templates/count")
        if res.kind_of? Net::HTTPSuccess
          return Integer(res.body)
        else
          raise res.body
        end
      end
      
      def getAccountSettings
        res = get("/account/settings")
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
      def getTemplateThumbnails(temlateName, zoomFactor, fromPage = 1, toPage = 0, imageformat = :png)
        res = get("/templates/thumbnails")
        if res.kind_of? Net::HTTPSuccess
          # ToDo: implement
        else
          raise res.body 
        end        
      end
      
      private
      def get(requestUri)
        http = Net::HTTP.new(@uri.host, @uri.port)
        req = Net::HTTP::Get.new("/#{@apiVersion}#{requestUri}", initheader = { "Content-Type" => "application/json" })
        req.basic_auth(@username, @password);
        return http.request(req)
      end
      
      private
      def delete(requestUri)
        http = Net::HTTP.new(@uri.host, @uri.port)
        req = Net::HTTP::Delete.new("/#{@apiVersion}#{requestUri}", initheader = { "Content-Type" => "application/json" })
        req.basic_auth(@username, @password);
        return http.request(req)      
      end
      
    end
  end
end