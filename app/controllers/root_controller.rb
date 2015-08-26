class RootController < Sinatra::Base
  get "/" do
    %{
      <h1>It works!</h1>
      <h2>Strategies:</h2>
      <pre>#{STRATEGIES.strategies.keys.to_json}</pre>
      <h2>Assets:</h2>
      <strong>Total:</strong> #{DB[:assets].count}
    }
  end
end
