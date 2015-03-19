feature 'Logo page pass in' do

  before {visit root_path}

  scenario 'Guest visit page Logo and see picture and two buttons' do
    expect(page).to have_content 'Мы все – родня!'
  end

  scenario 'Guest press button "Присоединиться" and move to signup page' do
    click_link 'Присоединится'
    expect(current_path).to eq(signup_path)
  end

  # scenario 'Guest press button "Присоединиться" and move to signup page', js: true, focus: true do
  #
  #   click_link 'Присоединится'
  #
  #   expect(page).to have_content 'Как Вас зовут?'
  # end




end