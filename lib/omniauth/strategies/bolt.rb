# frozen_string_literal: true

require 'omniauth-oauth'
require 'json'

module OmniAuth
  module Strategies
    class Bolt < OmniAuth::Strategies::OAuth
      option :name, 'bolt'
    end
  end
end
