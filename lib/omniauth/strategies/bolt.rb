# frozen_string_literal: true

require 'omniauth-oauth'
require 'json'

module OmniAuth
  module Strategies
    class Bolt
      include OmniAuth::Strategy

      attr_reader :access_token, :user_uid

      option :name, 'bolt'

      ENVIRONMENT_URLS = {
        production: 'https://api.bolt.com',
        sandbox: 'https://api-sandbox.bolt.com',
        staging: 'https://api-staging.bolt.com'
      }.freeze

      args %i[publishable_key api_key]

      uid { user_uid }

      info do
        {
          'email' => raw_info['email'],
          'first_name' => raw_info['first_name'],
          'last_name' => raw_info['last_name'],
        }
      end

      def request_phase
        session[:authorization_code] = request.params['authorization_code']
        session[:scope] = request.params['scope']

        redirect callback_url
      end

      def callback_phase
        payload = {
          grant_type: 'authorization_code',
          code: session['authorization_code'],
          client_id: options['publishable_key'],
          # scope: 'openid+bolt.account.manage',
          scope: session['scope'],
          client_secret: options['api_key']
        }

        api_uri = "#{ENVIRONMENT_URLS[ENV['BOLT_ENVIRONMENT'].to_sym]}/v1/oauth/token"
        uri = URI(api_uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output $stdout
        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        req = Net::HTTP::Post.new(uri.request_uri)
        post_data = URI.encode_www_form(payload)
        res = http.request(req, post_data)
        response = JSON.parse(res.body)
        @expiration_time = Time.now.utc + response['expires_in']
        @refresh_token = response['refresh_token']
        @refresh_token_scope = response['refresh_token_scope']
        @access_token = response['access_token']
        @user_uid = response['id_token']

        super
      end

      def raw_info
        @raw_info ||= begin
          get_account_details = "#{ENVIRONMENT_URLS[ENV['BOLT_ENVIRONMENT'].to_sym]}/v1/account"
          uri = URI(get_account_details)
          http = Net::HTTP.new(uri.host, uri.port)
          http.set_debug_output $stdout
          if uri.scheme == 'https'
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          req = Net::HTTP::Get.new(uri.request_uri)

          req['Authorization'] = "Bearer #{access_token}"
          req['Content-Type'] = 'application/json'
          req['Accept'] = 'application/json'
          req['X-API-KEY'] = options['api_key']

          res = http.request(req)
          JSON.parse(res.body)['profile']
        end
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end
