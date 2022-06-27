# frozen_string_literal: true

module Pix
  module API
    # PSPs suportados, seram adicinados novos em breve
    PSPS = {
      'Bradesco' => Pix::API::Bradesco
    }.freeze
  end
end
