# frozen_string_literal: true

require 'date'

module Pix
  module Cobrancas
    # Valida principais campos para evitar chamadas incorretas a api
    module Validation
      def add_cobv_validations
        valida_chave_pix
        valida_calendario_vencimento
        valida_devedor
        valida_multa
      end

      def add_cob_validations
        valida_calendario
        valida_chave_pix
        valida_devedor
      end

      private

      def blank_msg
        'não pode ficar em branco.'
      end

      def valida_devedor
        self.class.errors.add(:cpf_ou_cnpj, 'Documento devedor não pode ficar em branco') unless documento_present?

        self.class.validates_length_of :devedor_cpf, is: 11, allow_blank: true, message: 'deve possuir 11 caracteres'
        self.class.validates_length_of :devedor_cnpj, is: 14, allow_blank: true, message: 'deve possuir 14 caracteres'

        self.class.validates_numericality_of :devedor_cep, message: 'deve possuir somente números.'
        self.class.validates_length_of :devedor_cep, maximum: 8, message: 'deve possuir no máximo 8 caracteres'
        self.class.validates_length_of :devedor_uf, maximum: 2, message: 'deve possuir no máximo 2 caracteres'

        self.class.validates_length_of :devedor_cidade,
                                       :devedor_logradouro,
                                       maximum: 200,
                                       message: 'deve possuir no máximo 200 caracteres'
      end

      def valida_chave_pix
        self.class.validates_length_of :chave_pix, maximum: 77, message: 'deve possuir no máximo 77 caracteres'
      end

      def valida_calendario
        self.class.validates_presence_of :expiracao, message: blank_msg
        self.class.validates_numericality_of :expiracao, message: 'deve ser Inteiro'
      end

      def valida_calendario_vencimento
        self.class.validates_dates_of :data_vencimento, greater_than: Date.today, message: blank_msg
        self.class.validates_presence_of :validade_apos_vencimento, message: blank_msg
        self.class.validates_numericality_of :validade_apos_vencimento, message: 'deve ser Inteiro'
      end

      def valida_multa
        return unless multa_modalidade && multa_valor

        self.class.validates_each :multa_modalidade do |record, attr, value|
          record.errors.add attr, 'deve ser 1 ou 2' unless %w[1 2].include?(value.to_s)
        end

        errors.add :multa_valor, 'deve ser um Float' unless /\./.match?(multa_valor.to_s)
      end

      def valida_juros
        return unless juros_modalidade && juros_valor

        self.class.validates_each :juros_modalidade do |record, attr, value|
          record.errors.add attr, 'deve ser 1..8' unless (1..8).include?(value.to_i)
        end

        errors.add :juros_valor, 'deve ser um Float' unless /\./.match?(juros_valor.to_s)
      end

      def valida_descontos
        return unless desconto_modalidade

        self.class.validates_presence_of :desconto_valor, message: blank_msg unless descontos
      end
    end
  end
end
