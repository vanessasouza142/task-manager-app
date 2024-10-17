require 'rails_helper'

describe 'User register yourself' do
  it 'from home' do
    #Arrange

    #Act
    visit root_path
    click_on 'Registre-se'

    #Assert
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_button 'Registrar'
  end

  it 'with sucess' do
    #Arrange
    stub_request(:post, "#{ENV['AUTH_SERVICE_URL']}/api/v1/register")
    .with(
      body: { name: 'Maria da Silva', email: 'mariadasilva@mailinator.com', password: 'password' }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
    .to_return(
      status: 201,
      body: { user: { name: 'Maria da Silva', email: 'mariadasilva@mailinator.com' }, token: 'fake_token' }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    #Act
    visit root_path
    click_on 'Registre-se'
    fill_in 'Nome', with: 'Maria da Silva'
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Registrar'

    #Assert
    expect(current_path).to eq tasks_path
    expect(page).to have_content 'Boas-vindas! Seu registro foi realizado com sucesso!'
    expect(page).to have_content 'Maria da Silva'
    expect(page).to have_button 'Logout'
    expect(page).to have_content 'Lista de Tarefas'
  end

  it 'sem sucesso' do
    #Arrange

    #Act
    visit root_path
    click_on 'Registre-se'
    fill_in 'Nome', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    click_on 'Registrar'

    #Assert
    expect(current_path).to eq register_path
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end
end