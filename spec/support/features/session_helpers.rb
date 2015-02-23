module FeatureHelpers
  def sign_in_with user
    visit root_path

    fill_in 'Email address', with: user.email
    fill_in 'Password', with: '12345'
    click_on 'Sign in'

    expect(page).to have_content 'Signed in successfully.'
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
