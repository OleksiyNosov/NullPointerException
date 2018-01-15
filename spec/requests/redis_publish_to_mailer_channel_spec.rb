require 'acceptance_helper'

RSpec.describe 'RedisPublishToMailerChannel', type: :request do
  let(:user_attrs) { attributes_for :user }

  let(:headers) { { 'Content-type' => 'application/json' } }

  describe 'POST /api/users' do
    publish_status = false

    before do
      #
      # Creates new redis listener in a different thread
      #
      Thread.new do
        Redis.new.subscribe('notifier.email') do |on|
          on.message do |channel, message|
            publish_status = true
          end
        end
      end
    end

    before { post '/api/users', params: { user: user_attrs }.to_json, headers: headers }

    it('returns status 201') { expect(response).to have_http_status 201 }

    it('publishes user attributes to redis mailer channel') { expect(publish_status).to eq true }
  end
end
