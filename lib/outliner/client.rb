require 'httparty'
require 'json'

module Outliner
  class Client
    include HTTParty

    def initialize(base_uri)
      self.class.base_uri (base_uri + "/api")
      @token = ENV['OUTLINE_TOKEN']
    end

    def find_or_create_collection(name)
      collections = self.collections_list(limit: 100)['data']
      collections.filter!{|c|c['name'] == name}
      if collections.size >= 1
        collections[0]['id']
      else
        self.collections_create(name: name, description: 'Imported Collection')['data']['id']
      end
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
