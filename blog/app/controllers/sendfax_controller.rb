class SendfaxController < ApplicationController


	def new
		@sendfax = Sendfax.new
	end

	def create
		require 'fileutils'
		require 'rest_client'
		require 'json'

		tmp = params[:create][:my_file].tempfile

		file = File.join("public", params[:create][:my_file].original_filename)
		FileUtils.cp tmp.path, file

		destination = params[:create][:destination]
		subject = params[:create][:subject]

		response = RestClient.post 'http://192.168.0.185:8080/public/api/outbound/fax', {
						:destination => destination,
						:subject => subject,
						:file => File.new(tmp.path, 'rb')
					},
					{
						:'api_key' => 'b5f8ce46e0c2a6e38729610c6caab8e3',  # Change this with your API Key
						:accept => :json # But you can also request XML
					}

		# parse the response
		faxResponse = JSON.parse response




		# get the jobID and get infos about it
		faxStatusResponse = RestClient.get 'http://192.168.0.185:8080/public/api/outbound/fax/' + faxResponse["response"]["jobId"],
								 {
									:'api_key' => 'b5f8ce46e0c2a6e38729610c6caab8e3',  # Change this with your API Key
									:accept => :json # But you can also request XML
								}

		# parse the status
		@faxStatus = JSON.parse faxStatusResponse




	end



	def edit
	end

	def show
	end

	def update
	end

	def update
	end

	def destroy
	end

end