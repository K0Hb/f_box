require 'rails_helper'

RSpec.describe 'Base', type: :request do
  after(:each) do
    redis = Redis::Namespace.new('f_box', redis: Redis.new)
    redis.del('links')
  end

  describe 'POST /visited_links' do
    let(:headers) { { 'Content-Type' => 'application/json' } }

    it 'returns status: ok' do
      headers = { 'Content-Type' => 'application/json' }
      post '/api/v1/visited_links', params: { links: %w[test_link1 test_link2] }.to_json, headers: headers

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['status']).to eq('OK')
    end

    it 'returns status: parametr :links and :to is required' do
      post '/api/v1/visited_links', params: { links: 'nil' }.to_json, headers: headers

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['status']).to eq('parametr :links has array')
    end

    context 'when miss parametrs' do
      it 'returns status: parametr :links and :to is required' do
        post '/api/v1/visited_links', headers: headers

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['status']).to eq('parametr :links and :to is required')
      end
    end
  end

  describe 'GET /visited_domains' do
    it 'returns status: OK' do
      get '/api/v1/visited_domains', params: { from: 1666178913, to: 1666178918 }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['status']).to eq('OK')
    end

    context 'when miss parametrs' do
      it 'returns status parametr :from and :to is required' do
        get '/api/v1/visited_domains'

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['status']).to eq('parametr :from and :to is required')
      end

      it 'returns status parametr :to is required' do
        get '/api/v1/visited_domains', params: { from: 1666178913 }

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['status']).to eq('parametr :to is required')
      end

      it 'returns status parametr :from and :to is required' do
        get '/api/v1/visited_domains', params: { to: 1666178913 }

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['status']).to eq('parametr :from is required')
      end
    end
  end

  describe 'GET /visited_domains and POST /visited_links' do
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:get_params) { { to: Time.now.to_i, from: Time.now.to_i + 5 } }

    it 'return correct domains' do
      post '/api/v1/visited_links', params: { links: %w[test_url1 test_url2] }.to_json, headers: headers

      get '/api/v1/visited_domains', params: get_params

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['status']).to eq('OK')
      expect(JSON.parse(response.body)['domains']).to eq(%w[test_url1 test_url2])
    end

    context 'when not iniq urls' do
      it 'return correct domains' do
        post '/api/v1/visited_links', params: { links: %w[test_url1 test_url2 test_url2] }.to_json, headers: headers

        get '/api/v1/visited_domains', params: get_params

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['status']).to eq('OK')
        expect(JSON.parse(response.body)['domains']).to eq(%w[test_url1 test_url2])
      end
    end

    context 'when two requests one moment' do
      it 'return correct domains' do
        post '/api/v1/visited_links', params: { links: %w[test_url1] }.to_json, headers: headers
        post '/api/v1/visited_links', params: { links: %w[test_url3] }.to_json, headers: headers

        get '/api/v1/visited_domains', params: get_params

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['status']).to eq('OK')
        expect(JSON.parse(response.body)['domains']).to eq(%w[test_url1 test_url3])
      end
    end

    context 'when two urls with the same domain' do
      it 'return correct domain' do
        post '/api/v1/visited_links',
          params: { links: %w[https://test_url1.ru https://test_url1.ru/user] }.to_json,
          headers: headers

        get '/api/v1/visited_domains', params: get_params

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['status']).to eq('OK')
        expect(JSON.parse(response.body)['domains']).to eq(['test_url1.ru'])
      end
    end

    context 'when sequential requests, interval 1 sec' do
      let(:headers) { { 'Content-Type' => 'application/json' } }
      let(:get_params) { { to: Time.now.to_i - 2, from: Time.now.to_i + 5 } }

      it 'return correct domains' do
        post '/api/v1/visited_links', params: { links: %w[test_url_10] }.to_json, headers: headers
        sleep(1)
        post '/api/v1/visited_links', params: { links: %w[test_url_20] }.to_json, headers: headers
        sleep(1)
        post '/api/v1/visited_links', params: { links: %w[test_url_30] }.to_json, headers: headers

        get '/api/v1/visited_domains', params: get_params

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['status']).to eq('OK')
        expect(JSON.parse(response.body)['domains']).to eq(%w[test_url_10 test_url_20 test_url_30])
      end
    end
  end
end