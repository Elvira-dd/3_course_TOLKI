class Api::V1::ProfilesController < ApplicationController
    def index
        @profiles = Profile.all
        @themes = Theme.all
        end
    
        def show
            @profile = Profile.find(params[:id])
            @theme = Theme.find(params[:id])
        end
end
