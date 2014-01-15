require 'sinatra'

class PmbApp < Sinatra::Base

	get '/' do 
		"Hello Dunia"
	end

	get '/input' do 
		"Hello Dunia"
	end
end