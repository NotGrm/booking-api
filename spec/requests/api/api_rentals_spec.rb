require 'rails_helper'

RSpec.describe 'Api::Rentals', type: :request do
  let(:serializer) { JSONAPI::ResourceSerializer.new(Api::RentalResource) }
  let(:object_hash) { serializer.object_hash(Api::RentalResource.new(rental, nil)) }

  describe 'GET /api/rentals' do
    before do
      create_list(:rental, 10)
      get '/api/rentals', headers: headers
    end

    it 'responds with a 200 http status code' do
      expect(response).to have_http_status(200)
    end

    it 'returns all rentals' do
      expect(json_response['data'].length).to eq(10)
    end
  end

  describe 'GET /api/rentals/:id' do
    context 'when looking for existing rental' do
      let(:rental) { create(:rental) }

      before do
        get "/api/rentals/#{rental.id}", headers: headers
      end

      it 'responds with a 200 http status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns rental' do
        expect(json_response['data']['type']).to eq('rentals')
        expect(json_response['data']['id']).to eq(rental.id.to_s)
      end

      it 'returns rental attributes' do
        expect(json_response['data']['attributes']['name']).to eq(rental.name)
        expect(json_response['data']['attributes']['daily-rate']).to eq(rental.daily_rate)
      end
    end

    context 'when looking for a non existing rental' do
      before { get '/api/rentals/9999', headers: headers }

      it 'responds with a 404 http status code' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /api/rentals' do
    let(:rental) { build(:rental) }
    let(:rental_params) do
      {
        data: {
          type: object_hash.fetch('type'),
          attributes: object_hash.fetch('attributes')
        }
      }.to_json
    end

    before do
      post '/api/rentals', params: rental_params, headers: headers
    end

    it 'responds with a 201 http status code' do
      expect(response).to have_http_status(201)
    end

    it 'creates a new rental' do
      expect(json_response['data']['type']).to eq('rentals')
      expect(json_response['data']['type']).not_to be_nil
    end

    it 'sets rental attributes' do
      expect(json_response['data']['attributes']['name']).to eq(rental[:name])
      expect(json_response['data']['attributes']['daily-rate']).to eq(rental[:daily_rate])
    end
  end

  describe 'PATCH /api/rentals/:id' do
    let(:updated_name) { 'Updated Rental' }
    let(:updated_daily_rate) { 1000 }

    let(:rental) { create(:rental) }

    let(:rental_params) do
      rental.attributes = { name: updated_name, daily_rate: updated_daily_rate }
      {
        data: {
          type: object_hash.fetch('type'),
          id: object_hash.fetch('id'),
          attributes: object_hash.fetch('attributes')
        }
      }.to_json
    end

    before do
      patch "/api/rentals/#{rental.id}", params: rental_params, headers: headers
    end

    it 'responds with a 200 http status code' do
      expect(response).to have_http_status(200)
    end

    it 'updates rental attributes' do
      expect(json_response['data']['attributes']['name']).to eq(updated_name)
      expect(json_response['data']['attributes']['daily-rate']).to eq(updated_daily_rate)
    end
  end

  describe 'DELETE /api/rentals/:id' do
    let(:rental) { create(:rental) }

    before do
      delete "/api/rentals/#{rental.id}", headers: headers
    end

    it 'deletes the rental' do
      expect(response).to have_http_status(204)
    end
  end
end
