# frozen_string_literal: true

require 'date'

require 'pix/helpers'

module Pix
  module Cobrancas
    class Desconto
      include Helpers

      # Data limite para o desconto absoluto da cobrança
      attr_reader :data

      # Desconto em valor absoluto ou percentual por dia, útil ou corrido,
      #   conforme Cobranca#desconto_modalidade
      attr_reader :valor

      # @param data [Date] Data limite para o desconto absoluto da cobrança
      # @param valor [Float] Desconto em valor absoluto ou percentual conforme Cobranca#desconto_modalidade
      def initialize(data, valor)
        @data = data
        @valor = valor

        validate!
      end

      # @return [Hash] Retorna valor formatado para valor.desconto.descontoDataFixa
      def serialize
        json = {}
        json['data'] = formata_data(data)
        json['valorPerc'] = formata_valor(:valor)
        json
      end

      private

      def validate!
        raise Pix::Error, 'Desconto#data deve ser do tipo Date' unless data.is_a?(Date)
        raise Pix::Error, 'Desconto#valor deve ser um Float' unless /\./.match?(valor.to_s)
      end
    end
  end
end
