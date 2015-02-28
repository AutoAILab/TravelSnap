require 'rails_helper'

RSpec.feature 'Profile' do
  scenario 'Going to the profile page and uploading an image' do
    user = create :user

    sign_in_with user

    click_on 'Profile'
    expect(page).to have_content user.email

    expect(page).to have_content 'Avatar'

    expect(find('#avatar_img')['src']).to have_content 'missing_large.png'

    attach_file 'Avatar', "#{File.dirname(__FILE__)}/../files/flower0.jpg"
    click_on 'Save Changes'

    expect(find('#avatar_img')['src']).to have_content 'flower0.jpg'
  end

  scenario 'Going to the profile page and clicking update without selecting an image' do
    user = create :user

    sign_in_with user

    click_on 'Profile'
    expect(page).to have_content user.email

    expect(page).to have_content 'Avatar'

    click_on 'Save Changes'
  end

  scenario 'Going to the profile page and updating the secret token' do
    user = create :user

    using_session :user1 do
      sign_in_with user

      click_on 'Profile'
      click_on 'Generate new public link!'

      user.reload
      token1 = user.public_link_token

      expect(page).to have_content "Public link: #{public_url(user.public_link_token)}"

      click_on 'Generate new public link!'

      user.reload
      token2 = user.public_link_token

      expect(page).to have_content "Public link: #{public_url(user.public_link_token)}"
      expect(token1).to_not eq token2
    end
  end
end
