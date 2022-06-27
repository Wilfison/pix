# frozen_string_literal: true

require 'pix/api/base'

module Pix
  module API
    # Classe para comunicação via API
    class Bradesco < Base
      base_uri Pix.producao? ? 'https://qrpix.bradesco.com.br' : 'https://qrpix-h.bradesco.com.br'

      # Solicita ao PSP o token de acesso
      #
      # * +access_token+: Token de acesso em formato JWT
      # * +token_type+: Bearer (token de portador)
      # * +expires_in+: Tempo para expiração do Token (em segundos)
      #
      # @return [Hash]
      def get_access_token
        options = {
          headers: {
            'Content-type' => 'application/x-www-form-urlencoded',
            'Authorization' => "Basic #{credenciais.encoded_token}"
          },
          query: {
            grant_type: 'client_credentials'
          }
        }

        response = self.class.post('/auth/server/oauth/token', options)

        if response.code >= 500
          raise Pix::ResponseError.new(response.response),
                "#{response.code}: #{response.response.message}"
        end

        response_body = JSON.parse(response.body)

        set_access_token_attributes(response_body)
      rescue HTTParty::ResponseError => e
        raise Pix::ResponseError.new(e), "#{e.code}: #{e.message}"
      end

      private

      def set_autorization
        self.class.headers 'Authorization' => "#{token_type} #{access_token}"
      end

      def set_access_token_attributes(response_body)
        self.expires_in = response_body['expires_in']
        self.token_type = response_body['token_type']
        self.access_token = response_body['access_token']

        set_autorization
        response_body
      end
    end
  end
end
