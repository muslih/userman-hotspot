require "sinatra"
require "./user"
require "sinatra/flash"
require "sinatra/captcha"
require "./helpers/sinatra"
require "pdfkit"
require "sinatra/prawn"


# use Rack::Session::Cookie
enable :sessions
register Sinatra::Prawn
# use PDFKit::Middleware
# set :environment, :production

get '/coba.pdf' do	
	attachment
	content_type :pdf
	@message = "hello from pdf"
	prawn :samplepdf
end

get '/pdfkit.pdf' do
  	# attachment
  	@unit = Unit.all
  	content_type :pdf
	html = erb :tambah, 
	kit = PDFKit.new(html)
	kit.stylesheets << "#{settings.root}/public/css/style.css"
	kit.to_pdf
end

get '/data' do 	
	protected!
	@judul = "List Data"
	@users = User.all
	erb :data
end

get '/data/cari' do
	@cari = params[:query]
	@users = User.all(:npm.like => "%#{params[:query]}%") | User.all(:nama.like => "%#{params[:query]}%") | User.all(:email.like => "%#{params[:query]}%") | User.all(:hp.like => "%#{params[:query]}%")
	@jumlah = @users.count
	erb :data
end


# ubah status akun detail data
get '/data/:user/status/:boolean' do
	protected!
	@user = User.get(params[:user])
	@user.status = params[:boolean]
	if @user.save
		redirect '/data'
	else
		redirect '/data'
	end
end

# ubah status ip
get '/data/:user/statik/:boolean' do
	protected!
	@user = User.get(params[:user])
	@user.statik = params[:boolean]

	if @user.save
		redirect '/data'
	else
		redirect '/data'
	end
end

# ubah akun email
get '/data/:user/mail/:boolean' do
	@user = User.get(params[:user])
	@user.mailstatus = params[:boolean]
	if @user.save
		redirect '/data'
	else
		redirect '/data'
	end
end


# data detail
get '/data/:npm' do
	protected!
	@user = User.get(params[:npm])
	@judul = "Detail user #{@user.npm}"
	erb :detail
end


get '/data/:npm/surat' do
	protected!
	@user = User.get(params[:npm])
	@time = @user.created_at
	@judul = "Formulir Pendaftaran Internet"

	erb :surat
end

get '/data/:npm/surat.pdf' do
  	attachment
  	protected!
	@user = User.get(params[:npm])
	@time = @user.created_at
	@judul = "Formulir Pendaftaran Internet"

  	content_type :pdf
	html = erb :surat, :layout => :nopopup
	kit = PDFKit.new(html)
	kit.stylesheets << "#{settings.root}/public/css/style.css"
	kit.to_pdf
end

# edit data
get '/data/:npm/edit' do
	protected!
	@user = User.get(params[:npm])
	@unit = Unit.all
	@judul = "Edit user #{@user.npm}"
	erb :edit
end

get 'data/:wall' do
	"datanya adalah #{params[:wall]}"
end

# registrasi data
post '/daftar' do
	#if captcha_pass?
		@user = User.create(params[:user])
		if @user.save
			flash[:sukses] = "Data telah disimpan dan sedang dalam proses verifikasi<br/> kami akan mengirimkan hasil verifikasi dalam waktu maksimal 2 x 24 Jam"
			redirect to('/')
		else
			# flash[:galat] = @user.errors
			# flash[:error] = @user.errors.full_messages.join(", ")
			flash[:error] = @user.errors.full_messages.join("<br/> ")
			redirect '/'
		end	
	#else
		# flash[:error] = @user.errors #.full_messages.join(", ")
		#flash[:halt] = "Harap isi cahptcha  dengan benar!"
		#redirect '/halt'
	#end
end

#edit data
put '/daftar/:npm' do 
	protected!
	@user = User.get(params[:npm])

	if @user.update(params[:user])
		flash[:sukses] = "Data user #{params[:npm]} telah berhasil diubah!"
	else
		flash[:error] = "Data user #{params[:npm]} telah gagal diubah!"
	end
	redirect to("/data/#{@user.npm}")
end

#hapus data
delete '/daftar/:npm' do
	protected!

	@user = User.get(params[:npm]).destroy
	if @user
		flash[:sukses] = "Data user #{params[:npm]} telah berhasil dihapus!"
		redirect to("/data")
	else
		flash[:error] = "Data user #{params[:npm]} gagal dihapus!"
		redirect to("/data")
	end
end
not_found {@judul ='Ouch! Halaman Kosong';erb :'404' }

get '/halt' do
	@judul = "Ada Kesalahan"
	@unit = Unit.all		
	status 401
	erb :tambah
end

get '/' do
	@user = User.new
	@unit = Unit.all
	erb :tambah
end

#lupa sandi
get '/lupa' do
	@judul = "Reset Password"
	erb :lupa
end

post '/lupa' do 
	# require 'net/smtp'
	# @npm = params[:npm]
	# @mail = params[:email]
	# @telp = params[:telp]
	# @judul = "Reset Password Hotspot >> #{@npm}"
	# @body = "User dengan #{@npm} , email #{@mail} , telp #{@telp} minta restart password"

 #   @serv = "smtp.gmail.com"
 #   @port = "587"
 #   @from = "stikesmuhbjm@gmail.com"
 #   @to = "info@stikes-mb.ac.id"
 #   @pass = "merdeka!"

 #   smtp = Net::SMTP.start(@serv,@port)
 #   smtp.enable_starttls
 #   smtp.start(@serv,@from,@pass, :login) do

 #   	sent = smtp.send_message(@body, @from)
 #   	if sent
 #   		redirect '/reset'
 #   	end
 #   end

 	require 'pony'
 	@npm = params[:npm]
	@mail = params[:email]
	@telp = params[:telp]
    Pony.mail(
      
      :from => @npm + "<" + @mail + ">",
      :to => 'info@stikes-mb.ac.id',
      :subject => "Reset hotspot " + @npm,
      :body => "Reset password npm #{@npm} demgam telp #{@telp} ",
      :via => :smtp,
      :via_options => { 
        :address              => 'smtp.gmail.com', 
        :port                 => '587', 
        :enable_starttls_auto => true, 
        :user_name            => 'stikesmuhbjm', 
        :password             => 'merdeka!', 
        :authentication       => :plain, 
        :domain               => 'localhost.localdomain'
      })
    redirect '/reset'     
end


get '/reset' do
	erb :reseted
end

# authentikasi
set :username,'muslih'
set :token,'ngalihbanardiingat'
set :password,'dodol'

get('/logout'){ response.set_cookie(settings.username, false) ; redirect '/login' }

get '/login' do
	@judul = "Login"
	erb :login
end

post '/login' do
	if params['username']==settings.username&&params['password']==settings.password
      response.set_cookie(settings.username,settings.token) 
      redirect '/data'
    else
      "Username or Password incorrect"
    end	
end
