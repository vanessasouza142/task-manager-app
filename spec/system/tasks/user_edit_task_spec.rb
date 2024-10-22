require 'rails_helper'

describe 'User edit a task' do
  it 'and must be authenticated' do
    #Arrange
    task = Task.create!(url: 'https://www.webmotors.com.br/comprar/chevrolet')
    
    #Act
    visit edit_task_path(task)
    
    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para realizar essa ação!'
  end

  it 'from home successfully' do
    #Arrange
    stub_request(:post, "#{ENV['AUTH_MICROSERVICE_URL']}/api/v1/login")
    .with(body: { email: 'mariadasilva@mailinator.com', password: 'password' }.to_json, headers: { 'Content-Type' => 'application/json' })
    .to_return( status: 200, body: { user: { id: 1, name: 'Maria da Silva', email: 'mariadasilva@mailinator.com' }, token: 'fake_token' }.to_json)
    
    stub_request(:post, "#{ENV['AUTH_MICROSERVICE_URL']}/api/v1/validate_token")
    .with(headers: { 'Authorization' => 'Bearer fake_token' })
    .to_return(status: 200, body: { user_id: 1, user_name: 'Maria da Silva' }.to_json)

    task = Task.create!(url: 'https://www.webmotors.com.br/comprar/chevrolet')
    
    #Act
    visit root_path
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    click_on 'Editar'
    fill_in 'URL', with: 'https://www.webmotors.com.br/comprar/chevrolet/cruze/14-turbo-lt-16v-flex-4p-automatico'
    click_on 'Atualizar'
    
    #Assert
    expect(current_path).to eq task_path(task)
    expect(page).to have_content 'Tarefa atualizada com sucesso!'
    expect(page).to have_content 'https://www.webmotors.com.br/comprar/chevrolet/cruze/14-turbo-lt-16v-flex-4p-automatico'
  end

  it 'with incompleted data' do
    #Arrange
    stub_request(:post, "#{ENV['AUTH_MICROSERVICE_URL']}/api/v1/login")
    .with(body: { email: 'mariadasilva@mailinator.com', password: 'password' }.to_json, headers: { 'Content-Type' => 'application/json' })
    .to_return( status: 200, body: { user: { id: 1, name: 'Maria da Silva', email: 'mariadasilva@mailinator.com' }, token: 'fake_token' }.to_json)
    
    stub_request(:post, "#{ENV['AUTH_MICROSERVICE_URL']}/api/v1/validate_token")
    .with(headers: { 'Authorization' => 'Bearer fake_token' })
    .to_return(status: 200, body: { user_id: 1, user_name: 'Maria da Silva' }.to_json)
    
    task = Task.create!(url: 'https://www.webmotors.com.br/comprar/chevrolet')
    
    #Act
    visit root_path
    fill_in 'E-mail', with: 'mariadasilva@mailinator.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    click_on 'Editar'
    fill_in 'URL', with: ''
    click_on 'Atualizar'
    
    #Assert
    expect(current_path).to eq task_path(task)
    expect(page).to have_content 'Tarefa não atualizada'
    expect(page).to have_content 'URL não pode ficar em branco'
  end
end