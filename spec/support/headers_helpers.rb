shared_context 'JSON:API headers' do
  let(:headers) do
    {
      "Accept": 'application/vnd.api+json',
      "Content-Type": 'application/vnd.api+json'
    }
  end
end

RSpec.configure do |config|
  config.include_context 'JSON:API headers', type: :request
end
