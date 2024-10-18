require 'rails_helper'

describe 'User view task list' do
  it 'and must be authenticated' do
    #Arrange
    
    #Act
    visit tasks_path
    
    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para realizar essa ação!'
  end

  it 'from home successfully' do
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
    task1 = Task.create!(url: 'https://www.webmotors.com.br/comprar/chevrolet')
    task2 = Task.create!(url: 'https://www.webmotors.com.br/comprar/toyota')
    task2 = Task.create!(url: 'https://www.webmotors.com.br/comprar/fiat')
    
    #Act
    visit root_path
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    
    #Assert
    expect(current_path).to eq tasks_path
    expect(page).to have_content 'Lista de Tarefas'
    expect(page).to have_content 'https://www.webmotors.com.br/comprar/chevrolet'
    expect(page).to have_content 'https://www.webmotors.com.br/comprar/toyota'
    expect(page).to have_content 'https://www.webmotors.com.br/comprar/fiat'
  end
end