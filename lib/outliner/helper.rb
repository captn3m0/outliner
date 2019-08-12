module Outliner
  class Helper
    def find_or_create_collection(client, name)
      collections = client.collections_list(limit: 100)['data']
      collections.filter!{|c|c['name'] == name}
      if collections.size >= 1
        collections[0]['id']
      else
        client.collections_create(name: name, description: 'Imported Collection')['data']['id']
      end
    end
  end
end
