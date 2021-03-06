require 'spec_helper'

describe Api::GuidesController, type: :controller do

  include ApiHelpers

  before do
    @beans_v2 = FactoryGirl.create(:guide, name: 'lee\'s mung bean')
    FactoryGirl.create_list(:guide, 2)
  end

  it 'should create guides' do
    sign_in FactoryGirl.create(:user)
    data = { name: 'brocolini in the desert',
             overview: 'something exotic',
             crop_id: FactoryGirl.create(:crop).id.to_s }
    post 'create', guide: data, format: :json

    expect(response.status).to eq(201)

    expect(json['guide']['name']).to eq(data[:name])
    expect(json['guide']['crop_id']).to eq(data[:crop_id])
  end

  it 'uploads a featured_image' do
    # PROBLEM: If someone wants to contribute and run the test suite on their
    # local machine, they will need to create an amazon bucket of their own. If
    # not, this test will always fail currently.
    # SOLUTION:
    # TODO: Install VCR in the test suite and remove the following line.
    skip 'You dont have an S3 bucket :(' unless ENV['S3_BUCKET_NAME'].present?
    params = { name: 'Bunnies',
               overview: 'A bunny from imgur.com',
               featured_image: 'http://i.imgur.com/AEe76j7.jpg',
               crop_id: FactoryGirl.create(:crop).id.to_s }
    sign_in FactoryGirl.create(:user)
    post 'create', guide: params

    expect(response.status).to eq(201)
    img_url = json['guide']['featured_image']
    expect(img_url).to include('.jpg')
    expect(img_url).to include('featured_images')
    expect(img_url).to include('http://')
    expect(img_url).to include('amazonaws.com')
  end

  it 'should return an error with wrong guide information'

  it 'should show a specific guide'

  it 'should return a not found error if a guide isn\'t found'

  it 'should update a guide'

  # it "lists crops." do
  #   get "index", format: :json, query: 'mung'
  #   expect(response.status).to eq(200)
  #   expect(json.length).to eq(1)
  #   expect(json['crops'][0]['_id']).to eq(@beans.id.to_s)
  # end

  # it 'returns [] for tiny searches' do
  #   get 'index', format: :json, query: 'mu'
  #   expect(response.status).to eq(200)
  #   expect(json).to eq('crops' => [])
  # end
end
