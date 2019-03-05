# frozen_string_literal: true

module HttpAuthProtection
  def self.included(base)
    base.class_eval do
      use Rack::Auth::Basic, 'Tessa Asset Manager' do |username, password|
        CREDENTIALS[username] == password
      end
    end
  end
end
