# frozen_string_literal: true

module Pix
  # @private
  module Helpers
    def formata_data(data, formato: '%Y-%m-%d')
      data.strftime(formato)
    rescue StandardError
      raise Pix::Error, "#{data} precisa ser do tipo Date"
    end

    def formata_valor_float(valor, atributo, klass)
      raise Pix::Error, "#{klass}##{atributo}: Deve ser um Float" unless /\./.match?(valor.to_s)

      format('%.2f', valor.round(2))
    end

    def formata_valor(atributo)
      valor = send(atributo)

      formata_valor_float(valor, atributo, self.class)
    end

    def sanitize_documento(valor)
      return if valor.nil?

      valor.to_s.gsub(/[^\d]/, '')
    end

    def truncate(string, length)
      end_index = length - 1

      string[0..end_index]
    end
  end
end
