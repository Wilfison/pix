# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'pry'
require 'pix'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

Dir["#{File.dirname(__FILE__)}/shared_examples/**/*.rb"].sort.each { |f| require f }
