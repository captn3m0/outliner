require 'httparty'
require 'json'

module Outliner
  class Client
    include HTTParty

    def initialize(base_uri)
      self.class.base_uri (base_uri + "/api")
      @token = ENV['OUTLINE_TOKEN']
    end

    def method_missing(method_name, params = {})
      method_name = '/' + method_name.to_s.sub('_', '.')
      body = {token: @token}.merge(params).to_json
      options = { 
        body: body,
        headers: {
          'Accept'=>'application/json',
          'Content-Type': 'application/json',
          'User-Agent': "Outliner/#{Outliner::VERSION}"
        },
        format: :json
      }

      self.class.post(method_name, options)
    end
  end
end
