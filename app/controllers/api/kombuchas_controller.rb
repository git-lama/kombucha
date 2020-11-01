# frozen_string_literal: true

class Api::KombuchasController < ApiController
  before_action :authenticate_user!
  before_action :set_kombucha, only: [:show, :update]

  def index
    @kombuchas = Kombucha.all
    filtering_params(params).each do |key, value|
      @kombuchas = @kombuchas.public_send("filter_by_#{key}", value) if value.present?
    end

    render json: @kombuchas.map(&:to_h), status: :ok
  end

  def show
    render json: @kombucha.to_h
  end

  def create
    @kombucha = Kombucha.new(kombucha_params)

    if @kombucha.save
      render json: @kombucha.to_h
    else
      render json: { errors: @kombucha.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @kombucha.update(kombucha_params)
      render json: @kombucha.to_h
    else
      render json: { errors: @kombucha.errors }, status: :unprocessable_entity
    end
  end

  private
    def set_kombucha
      @kombucha = Kombucha.find(params[:id])
    end

    def kombucha_params
      params.require(:kombucha).permit(:name, :fizziness_level,
                                       ingredient: [:caffeine_free, :vegan])
    end

    def filtering_params(params)
      params.slice(:fizziness, :caffeine_free, :vegan, :ingredient_name, :exlude_ingredient_name)
    end
end
