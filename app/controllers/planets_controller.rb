class PlanetsController < ApplicationController
  before_action :set_planet, only: %i[ show update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_response

  # GET /planets
  def index
    planets = Planet.all
    render json: planets, serializer: PlanetSerializer
  end

  def show
    planet = find_planet
    render json: planet, status: :ok, serializer: :PlanetSerializer
  end

  def create 
    planet = Planet.create!(planet_params)
    render json: planet, status: :created
  end

  def update
    planet = find_planet
    planet.update(planet_params_patch)
    render json: planet, status: :ok
  end

  def destroy
    planet = find_planet
    planet.destroy
    head :no_content
  end

  private
  
  def planet_params
    params.permit(:name, :distance_from_earth, :nearest_start, :image)
  end

  def planet_params_patch
    params.permit(:name, :distance_from_earth, :nearest_start, :image)
  end

  def find_planet
    Planet.find(params[:id])
  end

  def render_not_found_response
    render json: { error: "Planet not found" }, status: :not_found
  end

  def render_invalid_record_response(exception)
    render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
  end

end
