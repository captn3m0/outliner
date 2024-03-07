require 'outliner'
require 'minitest/autorun'
require 'webmock/minitest'
require 'json'

class ClientTest < Minitest::Test
  TOKEN = "c4302eFAKE_TOKEN9b6e27bccb7"
  BASE_URI='https://kb.example.com'
  FILE_OPERATION_ID = "08d5db26-bf43-4ec9-ac62-8769fd828e94"
  def setup
    ENV['OUTLINE_TOKEN'] = TOKEN
    @client = Outliner::Client.new BASE_URI
  end

  def test_client_initialized
    assert_kind_of Outliner::Client, @client
  end

  def test_auth_info_api
    mock('auth.info')
    r = @client.auth__info
    assert_equal "https://kb.example.com", r['data']['team']['url']
  end

  def test_export
    mock('collections.export_all')
    r = @client.collections__export_all
    assert_equal FILE_OPERATION_ID, r['data']['fileOperation']['id']
    assert_equal 200, r['status']
    assert_equal true, r['ok']
  end

  def test_retrieve_file_operation
    mock("fileOperations.redirect", {
      id: FILE_OPERATION_ID
    }, {
      "X-Download-Options" => "noopen",
      "X-Content-Type-Options" => "nosniff",
      "Content-Type" => "text/plain; charset=utf-8",
      "Content-Length" => "459",
      "Location" => "https://s3.example.com/#{FILE_OPERATION_ID}"
    }, 302)
    begin
    r = @client.fileOperations__redirect({id: FILE_OPERATION_ID}, format: nil, no_follow: true)
    rescue HTTParty::RedirectionTooDeep => e
      assert_equal "302", e.response.code
      assert_equal "https://s3.example.com/#{FILE_OPERATION_ID}", e.response.header['location']
    end

  end

  private

  def read_fixture(file)
    File.read "test/fixtures/#{file}.json"
  end

  def mock(method_name, params = {}, response_headers = {}, status = 200)
    stub_request(:post, BASE_URI + "/api/" + method_name)
    .with(
        body: params.to_json,
        headers: {
            'Accept'=>'application/json',
            'User-Agent'=>"Outliner/#{Outliner::VERSION}",
            'Content-Type'=> 'application/json',
            "Authorization"=> "Bearer #{TOKEN}"
        }
    ).to_return(body: read_fixture(method_name + ".#{status}"), headers: response_headers, status: 302)
  end
end
