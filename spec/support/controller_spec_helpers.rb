module ControllerSpecHelpers
  def app
    described_class
  end

  def self.included(base)
    base.include Rack::Test::Methods
    base.send :alias_method, :response, :last_response

    base.let(:json) { JSON.parse(response.body) }
  end
end
