require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET index' do
    it 'should return http ok' do
      get :index
      expect(response).to be_ok
    end
  end
end
