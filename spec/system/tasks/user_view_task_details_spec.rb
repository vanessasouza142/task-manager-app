require 'rails_helper'

describe 'User view task details' do
  it 'and must be authenticated' do
    #Arrange
    task = Task.create!(url: 'https://www.webmotors.com.br/comprar/chevrolet')

    #Act
    visit task_path(task)
    
    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para realizar essa ação!'
  end

  it 'from home' do
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
    task = Task.create!(url: 'https://www.webmotors.com.br/comprar/chevrolet')
    
    #Act
    visit root_path
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    click_on 'Visualizar'
    
    #Assert
    expect(current_path).to eq task_path(task)
    expect(page).to have_content 'Tarefa #1'
    expect(page).to have_content 'Resultado da Tarefa'
  end

end