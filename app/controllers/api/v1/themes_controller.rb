class Api::V1::ThemesController < ApplicationController
    def index
  @themes = Theme.all
end
    def show
        @theme = Theme.find(params[:id])
    end
end
