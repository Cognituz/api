require 'rails_helper'

RSpec.describe "Cognituz::Api::UsersControllers", type: :request do
  describe 'GET /v1/users' do
    context 'when searching users by taught subjects' do
      let(:filters) { { taught_subjects: subjects } }

      let!(:user_1) do
        create(:user).tap do |u|
          u
            .taught_subjects
            .build(
              level: 'Primario',
              name:  'Matemática'
            )
            .save!(validate: false)

          u
            .taught_subjects
            .build(
              level: 'Secundario',
              name:  'Biología'
            )
            .save!(validate: false)
        end
      end

      let!(:user_2) do
        create(:user).tap do |u|
          u
            .taught_subjects
            .build(
              level: 'Primario',
              name:  'Biología'
            )
            .save!(validate: false)

          u
            .taught_subjects
            .build(
              level: 'Secundario',
              name:  'Matemática'
            )
            .save!(validate: false)
        end
      end

      before(:each) do
        get '/v1/users', params: { filters: filters }
      end

      context 'with a single matching user' do
        let(:subjects) do
          [{
            level: 'Secundario',
            name: 'Matemática'
          },{
            level: 'Primario',
            name: 'Literatura'
          }]
        end

        it 'retrieves proper results' do
          data = JSON.parse(response.body)
          expect(data.length).to eq(1)
          expect(data.first['id']).to eq(user_2.id)
        end
      end

      context 'with a multiple matching users' do
        let(:subjects) do
          [{
            level: 'Secundario',
            name: 'Matemática'
          },{
            level: 'Primario',
            name: 'Matemática'
          }]
        end

        it 'retrieves proper results' do
          data = JSON.parse(response.body)
          expect(data.length).to eq(2)
        end
      end
    end
  end
end
