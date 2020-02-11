describe 'App' do
  before do
    add_endpoint '/foo' do
      get '/' do
        respond_with foo: 'bar'
      end
    end
  end

  it 'uses version from current accept header' do
    Travis::Api::Serialize.expects(:builder).with { |r, options| options[:version] == 'v1' }

    allow_any_instance_of(Travis::Api::App::Responders::Json).to receive(:apply?).and_return(false)

    response = get '/foo', {}, 'HTTP_ACCEPT' => 'application/json; version=2, application/json; version=1'
    expect(response.content_type).to eq('application/json;charset=utf-8')
  end

  it 'uses v1 by default' do
    Travis::Api::Serialize.expects(:builder).with { |r, options| options[:version] == 'v1' }
    get '/foo', {}, 'HTTP_ACCEPT' => 'application/json'
  end
end
