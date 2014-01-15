require 'dm-core'
require 'data_mapper'
require 'dm-migrations' 
require 'dm-timestamps'
require 'dm-validations'
require 'bcrypt'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class User
	include DataMapper::Resource
	# property :id, 		Serial
	property :npm, 		String,		:required => true, 	:key => true, :unique => true,
				:messages => {
			    	  :presence  => "Kolom NPM harus di isi",
			     	 :is_unique => "Nomor NPM anda sudah terdaftar, dan sedang dalam proses verifikasi",
			    }
	property :nama, 	String,		:required => true,
				:messages => {
			      	:presence  => "Kolom nama harus di isi",
		    	}
	property :password, String,		:required => true, 
				:messages => {
			     	:presence  => "Kolom password harus di isi",
		    	}
	property :email, String, 		:required => true, :unique => true,
		    	:format   => :email_address,
		    	:messages => {
		      		:presence  => "Kolom alamat email harus di isi, untuk pengiriman konfirmasi",
		      		:is_unique => "Alamat email yang anda masukan sudah terdaftar",
		      		:format    => "Harap isi dengan alamat email yang benar!"
		    	}
	property :hp, 		String,		:required => true,
			:messages => {
		      :presence  => "Kolom hp harus di isi, untuk pengiriman konfirmasi",
		    }
	property :status, 	Boolean,	:default => false
	property :statik,	Boolean,	:default =>	false
	property :ipnum, 	Integer
	property :laptop, String
	property :macaddr, 	String
	property :created_at, 	DateTime


	validates_length_of :password, :min => 6, :message => "Kata sandi minimal 6 karakter"
	validates_presence_of :unit_id, :message => "Kolom unit kerja / prodi harus diisi!"
	belongs_to :ip
	belongs_to :unit
	
	before :save do

		# if self.mailreq == true
		# 	self.emailreq 
		# end

		if User.all.max(:ipnum) == nil
	    	self.ipnum = 10
	    else
	  		self.ipnum = User.all.max(:ipnum) + 1
	    end
	end
end

class Login
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash
end

class Ip
  include DataMapper::Resource
  property :id, Serial
  property :ipcat, String
end

class Unit
  include DataMapper::Resource
  property :id, Serial
  property :slug, String
  property :kategori, String
end

# class Status
# 	include DataMapper::Resource
# 	# property :id,		Serial
# 	property :status, 	Boolean,	:default => false
# 	property :statik,	Boolean,	:default =>	true

# 	belongs_to :user, :key => true
# end
DataMapper.finalize
DataMapper.auto_upgrade!
