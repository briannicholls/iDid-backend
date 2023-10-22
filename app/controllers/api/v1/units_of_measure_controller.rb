class API::V1::UnitsOfMeasureController < ApplicationController
  def index
    units_of_measure = UnitOfMeasure.all
    render json: units_of_measure
  end

  def show
    unit_of_measure = UnitOfMeasure.find(params[:id])
    render json: unit_of_measure
  end

  def create
    unit_of_measure = UnitOfMeasure.new(unit_of_measure_params)

    if unit_of_measure.save
      render json: unit_of_measure, status: :created
    else
      render json: unit_of_measure.errors, status: :unprocessable_entity
    end
  end

  def update
    unit_of_measure = UnitOfMeasure.find(params[:id])

    if unit_of_measure.update(unit_of_measure_params)
      render json: unit_of_measure
    else
      render json: unit_of_measure.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unit_of_measure = UnitOfMeasure.find(params[:id])
    unit_of_measure.destroy
  end

  private

  def unit_of_measure_params
    params.require(:unit_of_measure).permit(:name, :abbreviation)
  end
end
