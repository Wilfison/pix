# frozen_string_literal: true

require 'httparty'

module Pix
  module API
    # Classe base para comunicação via API
    class Base
      include HTTParty

      headers 'Content-type' => 'application/json'

      # @return [String] Token JWS válido
      attr_accessor :access_token
      # @return [String] Tipo de Token (default: Bearer)
      attr_accessor :token_type
      # @return [Integer] Tempo para expiração do Token (em segundos)
      attr_accessor :expires_in

      # @return [Pix::API::Credenciais]
      attr_reader :credenciais

      # Classe de conexão com o PSP
      #
      # @param credenciais Pix::API::Credenciais
      def initialize(credenciais)
        @credenciais = credenciais

        # self.class.pem(credenciais.certificado_pem, credenciais.password)
      end

      def get_access_token
        raise Pix::ImplementationError, 'Deve ser implementado na class do PSP'
      end

      private

      def set_autorization
        raise Pix::ImplementationError, 'Deve ser implementado na class do PSP'
      end
    end
  end
end
