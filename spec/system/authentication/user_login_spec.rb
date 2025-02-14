require 'rails_helper'

describe 'User logs in' do
  it 'from home' do
    #Arrange

    #Act
    visit root_path

    #Assert
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_button 'Entrar'
  end

  it 'successfully' do
    #Arrange
    stub_request(:post, "#{ENV['AUTH_MICROSERVICE_URL']}/api/v1/login")
    .with(body: { email: 'mariadasilva@mailinator.com', password: 'password' }.to_json, headers: { 'Content-Type' => 'application/json' })
    .to_return( status: 200, body: { user: { id: 1, name: 'Maria da Silva', email: 'mariadasilva@mailinator.com' }, token: 'fake_token' }.to_json)
    
    stub_request(:post, "#{ENV['AUTH_MICROSERVICE_URL']}/api/v1/validate_token")
    .with(headers: { 'Authorization' => 'Bearer fake_token' })
    .to_return(status: 200, body: { user_id: 1, user_name: 'Maria da Silva' }.to_json)
  
    #Act
    visit root_path
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    
    #Assert
    expect(current_path).to eq tasks_path
    expect(page).to have_content 'Login realizado com sucesso!'
    expect(page).to have_content 'Maria da Silva'
    expect(page).to have_button 'Logout'
    expect(page).to have_content 'Lista de Tarefas'
  end

  it 'unsuccessfully' do
    #Arrange

    #Act
    visit root_path
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    click_on 'Entrar'

    #Assert
    expect(current_path).to eq login_path
    expect(page).to have_content 'Erro ao realizar login: Credenciais inválidas'
  end
end