module LiveQA
  ##
  # == LiveQA \Request
  #
  # Build request
  class Request
    class << self

      def execute(params = {})
        klass = new(params)

        if params[:method] == :post
          klass.post
        elsif params[:method] == :put
          klass.put
        elsif params[:method] == :delete
          klass.delete
        elsif params[:method] == :get
          klass.get
        else
          raise LiveQA::UnknownRequestMethod, "#{params[:method]} haven't been implemented"
        end
      end

      def post(params = {})
        new(params).post
      end

      def put(params = {})
        new(params).put
      end

      def get(params = {})
        new(params).get
      end

      def delete(params = {})
        new(params).delete
      end
    end

    attr_reader :params, :http, :request

    def initialize(params = {})
      @params = params
      @http   = Net::HTTP.new(uri.host, uri.port, uri_proxy.host, uri_proxy.port)

      setup_ssl if params[:use_ssl]
    end

    def post
      @request = Net::HTTP::Post.new(uri.path)

      set_header
      request.body = params[:payload]

      handle_request
    end

    def put
      @request = Net::HTTP::Put.new(uri.path)

      request.body = params[:payload]

      handle_request
    end

    def get
      @request = Net::HTTP::Get.new(uri)

      set_header

      handle_request
    end

    def delete
      @request = Net::HTTP::Delete.new(uri.path)

      request.body = params[:payload]

      handle_request
    end

    private

    def handle_request
      response = http.request(request)

      case [response.code_type]
      when [Net::HTTPOK], [Net::HTTPCreated], [Net::HTTPAccepted]
        response
      when [Net::HTTPUnauthorized]
        raise RequestError.new(response, message: 'Unauthorized, please check your api key')
      when [Net::HTTPNotFound]
        raise RequestError.new(response, message: 'Requested Resource not found')
      when [Net::HTTPRequestTimeOut]
        raise RequestError.new(response, message: 'Server timeout, verify status of the server')
      when [Net::HTTPInternalServerError]
        raise RequestError.new(response, message: 'Server Error, please check with LiveQA')
      else
        raise RequestError, response
      end
    end

    def set_header
      params[:headers].each do |(type, value)|
        formated_type = type.to_s.split(/_/).map(&:capitalize).join('-')
        request[formated_type] = value
      end
    end

    def setup_ssl
      http.use_ssl     = true
      http.ca_file     = params[:ca_file]
      http.verify_mode = params[:verify_mode]
    end

    def uri
      @uri ||= URI(params[:url])
    end

    def uri_proxy
      @uri_proxy ||=
        if params[:proxy]
          URI(params[:proxy])
        else
          OpenStruct.new
        end
    end

  end
end
