require 'json'

require './spec/spec_helper'
require './lib/pix/api/bradesco'

describe Pix::API::Bradesco do
  let(:base_uri) { 'https://qrpix.bradesco.com.br' }

  let(:credenciais) do
    Pix::API::Credenciais.new('./spec/suport/chave_privada.pem', '1234', '123', '456')
  end

  subject(:api) { described_class.new(credenciais) }

  describe '#get_access_token' do
    let(:api_target) { "#{base_uri}/auth/server/oauth/token?grant_type=client_credentials" }
    let(:api_response_body) { { expires_in: 300, token_type: 'Bearer', access_token: 'MEU_TOKEN' }.to_json }
    let(:api_headers) do
      { 'Authorization' => 'Basic MTIzOjQ1Ng==', 'Content-Type' => 'application/x-www-form-urlencoded' }
    end

    it 'solicitou ao PSP o token com sucesso' do
      stub_request(:post, api_target)
        .with(headers: api_headers)
        .to_return(status: 200, body: api_response_body)

      api.get_access_token

      expect(api.expires_in).to eq(300)
      expect(api.token_type).to eq('Bearer')
      expect(api.access_token).to eq('MEU_TOKEN')
    end

    it 'solicitou ao PSP o token com erro' do
      stub_request(:post, api_target)
        .with(headers: api_headers)
        .to_return(status: [500, 'Internal Server Error'])

      expect { api.get_access_token }.to raise_error(Pix::ResponseError, 'Internal Server Error')
    end
  end
end
