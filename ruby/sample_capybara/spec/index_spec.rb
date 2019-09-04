require 'spec_helper'

RSpec.describe 'github pages' do
  before do
    visit 'http://localhost:8000/index.html'
  end

  it 'shows contents' do
    expect(page).to have_content 'Hello World'
  end
end
