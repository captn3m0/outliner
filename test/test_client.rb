require 'outliner'
require 'minitest/autorun'
require 'webmock/minitest'
require 'json'

class ClientTest < Minitest::Test
  TOKEN = "c4302eFAKE_TOKEN9b6e27bccb7"
  BASE_URI='https://kb.example.com'
  def setup
    ENV['OUTLINE_TOKEN'] = TOKEN
    @client = Outliner::Client.new BASE_URI
  end

  def test_client_initialized
    assert_kind_of Outliner::Client, @client
  end

  def test_auth_info_api
    mock('auth.info', 'auth.info.200')
    auth_info = @client.auth_info
    assert_equal "https://kb.example.com", auth_info['data']['team']['url']
  end

  private

  def read_fixture(file)
    File.read "test/fixtures/#{file}.json"
  end

  def mock(method_name, fixture_file, params = {})
    stub_request(:post, BASE_URI + "/api/" + method_name)
    .with(
        body: params.merge({token: TOKEN}).to_json,
        headers: {
            'Accept'=>'application/json',
            'User-Agent'=>"Outliner/#{Outliner::VERSION}",
            'Content-Type'=> 'application/json'
        }
    ).to_return(body: read_fixture(fixture_file))
  end
end