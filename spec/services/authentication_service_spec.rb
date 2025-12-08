require 'rails_helper'

RSpec.describe AuthenticationService, type: :service do
  let(:service) { described_class.new }
  let!(:user) { create(:user, email: 'test@mail.com', password: 'password123') }

  describe '#login_user' do
    context 'when credentials are valid' do
      it 'returns JWT token' do
        # Mock token generation agar tidak panggil encode sungguhan
        allow(JwtUtil).to receive(:generate_token).and_return('mocked.jwt.token')

        result = service.login(email: 'test@mail.com', password: 'password123')

        expect(result[:token]).to eq('mocked.jwt.token')
        expect(JwtUtil).to have_received(:generate_token).with(user)
      end
    end

    context 'when email does not exist' do
      it 'returns nil' do
        result = service.login(email: 'absent@mail.com', password: 'password123')

        expect(result).to be_nil
      end
    end

    context 'when password is wrong' do
      it 'returns nil' do
        result = service.login(email: 'test@mail.com', password: 'wrong')

        expect(result).to be_nil
      end
    end
  end

  describe '#register_user' do
    it 'creates and returns a user' do
      params = {
        email: 'new@mail.com',
        password: 'secretpass',
        password_confirmation: 'secretpass'
      }

      result = service.register(params)

      expect(result).to be_a(User)
      expect(result).to be_persisted
      expect(result.email).to eq('new@mail.com')
    end
  end
end
