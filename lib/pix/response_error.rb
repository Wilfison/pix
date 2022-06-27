# frozen_string_literal: true

module Pix
  # @abstract Exception gerado nas requisições a api
  class ResponseError < StandardError
    # @return [String] HTTP code
    attr_reader :code
    # The HTTP result message sent by the server. For example, ‘Not Found’.
    attr_reader :message
    # URI que gerou o erro
    attr_reader :uri

    # Instantiate an instance of ResponseError with a Net::HTTPResponse object
    # @param [Net::HTTPResponse]
    def initialize(response)
      @code = response.code
      @message = response.message
      @uri = response.uri

      super(response)
    end
  end
end
