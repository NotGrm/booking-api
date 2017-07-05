require 'rails_helper'

RSpec.describe 'Api::Bookings', type: :request do
  let(:serializer) do
    JSONAPI::ResourceSerializer.new(Api::BookingResource)
  end
  let(:object_hash) { serializer.object_hash(Api::BookingResource.new(booking, nil)) }

  describe 'GET /api/bookings' do
    context 'when not authenticated' do
      it 'responds with a 401 http status code' do
        get '/api/bookings'
        expect(response).to have_http_status(401)
      end
    end

    context 'when authenticated' do
      before do
        create_list(:booking, 10)
        get '/api/bookings', headers: headers
      end

      it 'responds with a 200 http status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns all bookings' do
        expect(json_response['data'].length).to eq(10)
      end
    end
  end

  describe 'GET /api/bookings/:id' do
    let(:booking) { create(:booking) }

    context 'when not authenticated' do
      it 'responds with a 401 http status code' do
        get "/api/bookings/#{booking.id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'when authenticated and looking for existing booking' do
      before do
        get "/api/bookings/#{booking.id}", headers: headers
      end

      it 'responds with a 200 http status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns booking' do
        expect(json_response['data']['type']).to eq('bookings')
        expect(json_response['data']['id']).to eq(booking.id.to_s)
      end

      it 'returns booking attributes' do
        expect(json_response['data']['attributes']['client-email']).to eq(booking.client_email)
        expect(json_response['data']['attributes']['start-at']).to eq(booking.start_at.to_s)
        expect(json_response['data']['attributes']['end-at']).to eq(booking.end_at.to_s)
        expect(json_response['data']['attributes']['price']).to eq(booking.price)
      end
    end

    context 'when authenticated and when looking for a non existing booking' do
      before { get '/api/bookings/9999', headers: headers }

      it 'responds with a 404 http status code' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /api/bookings' do
    let(:booking) { build(:booking, rental: create(:rental)) }
    let(:booking_params) do
      {
        data: {
          type: object_hash.fetch('type'),
          attributes: object_hash.fetch('attributes').except('price'),
          relationships: object_hash.fetch('relationships')
        }
      }.to_json
    end

    context 'when not authenticated' do
      it 'responds with a 401 http status code' do
        post '/api/bookings', params: booking_params
        expect(response).to have_http_status(401)
      end
    end

    context 'when authenticated' do
      before do
        post '/api/bookings', params: booking_params, headers: headers
      end

      it 'responds with a 201 http status code' do
        expect(response).to have_http_status(201)
      end

      it 'creates a new booking' do
        expect(json_response['data']['type']).to eq('bookings')
        expect(json_response['data']['type']).not_to be_nil
      end

      it 'sets booking attributes' do
        expect(json_response['data']['attributes']['client-email']).to eq(booking[:client_email])
        expect(json_response['data']['attributes']['start-at']).to eq(booking[:start_at].to_s)
        expect(json_response['data']['attributes']['end-at']).to eq(booking[:end_at].to_s)
        expect(json_response['data']['attributes']['price']).to eq(100)
      end
    end
  end

  describe 'PATCH /api/bookings/:id' do
    let(:updated_client_email) { 'updated.email@example.org' }
    let(:updated_start_at) { '2017-07-03' }
    let(:updated_end_at) { '2017-07-04' }

    let(:booking) { create(:booking) }

    let(:booking_params) do
      booking.attributes = { client_email: updated_client_email, start_at: updated_start_at, end_at: updated_end_at }
      {
        data: {
          type: object_hash.fetch('type'),
          id: object_hash.fetch('id'),
          attributes: object_hash.fetch('attributes').except('price')
        }
      }.to_json
    end

    context 'when not authenticated' do
      it 'responds with a 401 http status code' do
        patch "/api/bookings/#{booking.id}", params: booking_params
        expect(response).to have_http_status(401)
      end
    end

    context 'when authenticated' do
      before do
        patch "/api/bookings/#{booking.id}", params: booking_params, headers: headers
      end

      it 'responds with a 200 http status code' do
        expect(response).to have_http_status(200)
      end

      it 'updates booking attributes' do
        expect(json_response['data']['attributes']['client-email']).to eq(updated_client_email)
        expect(json_response['data']['attributes']['start-at']).to eq(updated_start_at)
        expect(json_response['data']['attributes']['end-at']).to eq(updated_end_at)
      end
    end
  end

  describe 'DELETE /api/bookings/:id' do
    let(:booking) { create(:booking) }

    context 'when not authenticated' do
      it 'responds with a 401 http status code' do
        delete "/api/bookings/#{booking.id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'when authenticated' do
      before do
        delete "/api/bookings/#{booking.id}", headers: headers
      end

      it 'deletes the booking' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
