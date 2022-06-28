# frozen_string_literal: true

require 'date'

require 'pix/helpers'

module Pix
  module Cobrancas
    # Informações adicionais que serão apresentadas ao pagador
    class InfoAdicional
      include Helpers

      # @return [String] Nome do campo.
      attr_reader :nome
      # @return [String] Dados do campo.
      attr_reader :valor

      # @param nome [String] Nome do campo.
      # @param valor [String] Dados do campo.
      def initialize(nome, valor)
        @nome = nome
        @valor = valor
      end

      # @return [Hash] Retorna valor formatado como JSON
      def serialize
        json = {}
        json['nome'] = nome
        json['valor'] = valor
        json
      end
    end
  end
end
