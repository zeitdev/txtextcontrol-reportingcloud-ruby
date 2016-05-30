require "uri"
require "net/http"
require "json"
require "ostruct"

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
      
      def listTemplates
        res = get("/templates/list")
        if res.kind_of? Net::HTTPSuccess
          tmplNames = Array.new
          data = JSON.parse(res.body, object_class: OpenStruct)
          data.each do |elem|
            tmplNames.push(elem.Filename)
          end
          return tmplNames
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
          
        else 
        end
      end
      
      private
      def get(requestUri)
        http = Net::HTTP.new(@uri.host, @uri.port)
        req = Net::HTTP::Get.new("/#{@apiVersion}#{requestUri}", initheader = { "Content-Type" => "application/json" })
        req.basic_auth(@username, @password);
        return http.request(req)
      end
      
    end
  end
end