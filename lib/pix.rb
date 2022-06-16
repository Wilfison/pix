# frozen_string_literal: true

require 'pix/cobranca'
require 'pix/version'
require 'pix/validations'

require 'pix/cobrancas/json'
require 'pix/cobrancas/desconto'

module Pix
  class Error < StandardError; end

  # Exception lançada quando os dados de cobrança informados estão inválidos.
  #
  # Você pode usar assim na sua aplicação:
  #   rescue Pix::CobrancaInvalida => e
  #   puts e.errors
  class CobrancaInvalida < StandardError
    # Pega os erros de validação
    def initialize(cobranca)
      errors = cobranca.errors.full_messages.join(', ')
      super(errors)
    end
  end
end
