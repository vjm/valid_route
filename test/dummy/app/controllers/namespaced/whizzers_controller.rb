module Namespaced
	class WhizzersController < ApplicationController
		before_action :set_namespaced_whizzer, only: [:show, :edit, :update, :destroy]

		# GET /namespaced/whizzers
		def index
			@namespaced_whizzers = Namespaced::Whizzer.all
		end

		# GET /namespaced/whizzers/1
		def show
		end

		# GET /namespaced/whizzers/new
		def new
			@namespaced_whizzer = Namespaced::Whizzer.new
		end

		# GET /namespaced/whizzers/1/edit
		def edit
		end

		# POST /namespaced/whizzers
		def create
			@namespaced_whizzer = Namespaced::Whizzer.new(namespaced_whizzer_params)

			if @namespaced_whizzer.save
				redirect_to @namespaced_whizzer, notice: 'Whizzer was successfully created.'
			else
				render action: 'new'
			end
		end

		# PATCH/PUT /namespaced/whizzers/1
		def update
			if @namespaced_whizzer.update(namespaced_whizzer_params)
				redirect_to @namespaced_whizzer, notice: 'Whizzer was successfully updated.'
			else
				render action: 'edit'
			end
		end

		# DELETE /namespaced/whizzers/1
		def destroy
			@namespaced_whizzer.destroy
			redirect_to namespaced_whizzers_url, notice: 'Whizzer was successfully destroyed.'
		end

		private
		# Use callbacks to share common setup or constraints between actions.
		def set_namespaced_whizzer
			@namespaced_whizzer = Namespaced::Whizzer.find(params[:id])
		end

		# Only allow a trusted parameter "white list" through.
		def namespaced_whizzer_params
			params.require(:namespaced_whizzer).permit(:permalink)
		end
	end
end