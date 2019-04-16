module ActsAsResource
  class ResourcesController < ApplicationController
    before_action :set_clazz
    before_action :set_resource, only: %i[show update destroy]

    # GET /resources
    def index
      filter_params = params.to_unsafe_h.keys.select { |i| i[/.*_id/] }
      @resources = if !filter_params.empty? && filter_params.size == 1
                     relation = filter_params[0]
                     @clazz.where(relation => params[relation]).all
                   else
                     @clazz.all
                   end

      render json: @resources
    end

    # GET /resources/1
    def show
      render json: @resource
    end

    # POST /resources
    def create
      @resource = @clazz.new(resource_params)

      if @resource.save
        render json: @resource, status: :created
      else
        render json: @resource.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /resources/1
    def update
      if @resource.update(resource_params)
        render json: @resource
      else
        render json: @resource.errors, status: :unprocessable_entity
      end
    end

    # DELETE /resources/1
    def destroy
      @resource.destroy
    end

    private

    def set_clazz
      @model_name = params[:resource_name].classify
      @clazz = @model_name.constantize
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = @clazz.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def resource_params
      params.require(@model_name.underscore).permit(@clazz.column_names)
    end
  end
end
