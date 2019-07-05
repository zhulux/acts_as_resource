# frozen_string_literal: true

module ActsAsResource
  class ResourcesController < ApplicationController
    before_action :set_clazz
    before_action :set_resource, only: %i[show update destroy]

    # GET /resources
    def index
      filter_params = params.to_unsafe_h.keys
      @resources = if !filter_params.empty?
                     # support where
                     h = {}
                     filter_params.each do |fp|
                       next unless @clazz.column_names.include?(fp)

                       # note: do not use string: nil query
                       # just support integer: nil -> integer IS NULL
                       if @clazz.columns_hash[fp].type == :integer
                         h[fp] = nil if params[fp] == '' # fix nil sql
                       else
                         h[fp] = params[fp]
                       end
                     end
                     @clazz.where(h).all
                   else
                     @clazz.all
                   end

      if params[:page].present? && params[:per_page].present?
        @resources = @resources.page(params[:page]).per(params[:per_page])

        response.set_header('X-limit', @resources.limit_value.to_s)
        response.set_header('X-offset', @resources.offset_value.to_s)
        response.set_header('X-total', @resources.total_count.to_s)
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
