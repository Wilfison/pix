# frozen_string_literal: true

require 'base64'

module Pix
  module API
    # Nefine credenciais para conexão com o PSP
    class Credenciais
      # @return [String] Diretório do Certificado Privado .pem
      attr_accessor :certificate_path
      # @return [String] Senha do Certificado .pem
      attr_accessor :password
      # @return [String] Credencial de acesso fornecido pelo PSP
      attr_accessor :client_id
      # @return [String] Credencial de acesso fornecido pelo PSP
      attr_accessor :client_secret

      # @param certificate_path Diretório do Certificado Privado .pem
      # @param password Senha do Certificado .pem
      # @param client_id Credencial de acesso fornecido pelo PSP
      # @param client_secret Credencial de acesso fornecido pelo PSP
      def initialize(certificate_path, password, client_id = Pix.client_id, client_secret = Pix.client_secret)
        @certificate_path = certificate_path
        @password = password
        @client_id = client_id
        @client_secret = client_secret
      end

      # @return [String] Conteúdo do certificado privado .pem
      def certificado_pem
        @certificado_pem ||= File.read(certificate_path)
      end

      # return [String] Token para autenticação básica com o PSP
      def encoded_token
        @encoded_token ||= Base64.strict_encode64("#{client_id}:#{client_secret}").strip
      end
    end
  end
end
