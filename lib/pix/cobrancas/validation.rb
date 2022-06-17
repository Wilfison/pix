# frozen_string_literal: true

module Pix
  module Cobrancas
    # Valida principais campos para evitar chamadas incorretas a api
    module Validation
      def add_validation_vencimento
        self.class.validates_presence_of :validade_apos_vencimento, message: blank_msg

        valida_chave_pix
        valida_devedor
      end

      private

      def blank_msg
        'não pode ficar em branco.'
      end

      def valida_devedor
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
    end
  end
end
