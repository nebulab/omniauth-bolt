# frozen_string_literal: true

require 'spec_helper'

describe OmniAuth::Strategies::Bolt do
  let(:request) { double('Request', params: {}, cookies: {}, env: {}) }

  describe 'client options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('bolt')
    end
  end
end
