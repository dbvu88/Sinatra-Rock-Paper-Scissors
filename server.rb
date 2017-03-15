require "sinatra"
require "pry"

set :bind, '0.0.0.0'  # bind to all interfaces

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"

}

get '/index' do
  if session[:game_in_progess].nil?
    #game initialization
    session[:game_in_progess] = false
    session[:message] = "Well come to MMORPS Rock Paper Scissors"
    session[:player_score] = 0
    session[:computer_score] = 0

    redirect "/index"
  else
    if session[:computer_score] == 3
      session[:message] = "The computer beat you three times. You got defeated!"
    elsif session[:player_score] == 3
      session[:message] = "You beat the computer three times. You earned a victory!"
    else
      session[:message]
    end
    @message = session[:message]
    @player_score = session[:player_score]
    @computer_score = session[:computer_score]
    erb :index
  end


end

get '/play' do
  redirect "/index"
end

post '/play' do
  # game started
  session[:game_in_progess] = true
  if session[:player_score] < 3 && session[:computer_score] < 3
    throws = ["rock", "paper", "scissors"]
    player_choice = params[:choice]
    computer_choice = throws.sample

    session[:message] = "You chose #{player_choice}, the computer choose #{computer_choice}.\n"

    if player_choice == computer_choice
      session[:message] <<"Tie!"
    elsif
      player_choice == throws[0] && computer_choice == throws[2] ||
      player_choice == throws[1] && computer_choice == throws[0] ||
      player_choice == throws[2] && computer_choice == throws[1]
      session[:message] << "#{player_choice.capitalize} beats #{computer_choice}.\n"
      session[:message] << "Player won this round.\n"
      session[:player_score] += 1
    else
      session[:message] << "#{computer_choice.capitalize} beats #{player_choice}.\n"
      session[:message] << "The computer won this round.\n"
      session[:computer_score] += 1
    end
  elsif session[:computer_score] == 3
    session[:message] = "The computer beat you three times. You got defeated!"
  else
    session[:message] = "You beat the computer three times. You earned a victory!"
  end
  redirect "/index"
end

get '/reset' do
  session.clear
  redirect '/index'
end
