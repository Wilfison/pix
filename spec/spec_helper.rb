# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'pry'
require 'pix'

Dir["#{File.dirname(__FILE__)}/shared_examples/**/*.rb"].sort.each { |f| require f }
