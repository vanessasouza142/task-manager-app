require 'rails_helper'

describe 'User register a new task' do
  it 'and must be authenticated' do
    #Arrange
    
    #Act
    visit new_task_path
    
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
    
    #Act
    visit root_path
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    click_on 'Nova Tarefa'
    
    #Assert
    expect(current_path).to eq new_task_path
    expect(page).to have_content 'Cadastrar Nova Tarefa'
    expect(page).to have_field 'URL'
  end

  it 'successfully' do
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
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    click_on 'Nova Tarefa'
    fill_in 'URL', with: 'https://www.webmotors.com.br/comprar/chevrolet'
    click_on 'Cadastrar'
    
    #Assert
    expect(page).to have_content 'Tarefa cadastrada com sucesso!'
    expect(page).to have_content 'Pendente'
    expect(page).to have_content 'https://www.webmotors.com.br/comprar/chevrolet'
  end

  it 'with incompleted data' do
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
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    click_on 'Nova Tarefa'
    fill_in 'URL', with: ''
    click_on 'Cadastrar'
    
    #Assert
    expect(current_path).to eq tasks_path
    expect(page).to have_content 'Tarefa não cadastrada:'
    expect(page).to have_content 'URL não pode ficar em branco'
  end
end