module Api::V1
  class BaseController < ApplicationController
    before_action :check_params_visited_domains, only: :visited_domains
    before_action :check_params_visited_links, only: :visited_links

    def visited_links
      statistics = Statistics.new(visited_links_params, mode: 'write')
      response = statistics.write
      render json: response, status: 201
    end

    def visited_domains
      statistics = Statistics.new(visited_domains_params, mode = 'get')
      response = statistics.search_data
      render json: response, status: 200
    end

    private

    def visited_links_params
      params[:links]
    end

    def visited_domains_params
      params.permit(:from, :to)
    end

    def check_params_visited_domains
      unless params[:from] && params[:to]
        if params[:from].nil? && params[:to].nil?
          render json: { status: 'parametr :from and :to is required'}, status: 422
        elsif params[:to].nil?
          render json: { status: 'parametr :to is required'}, status: 422
        else
          render json: { status: 'parametr :from is required'}, status: 422
        end
      end
    end

    def check_params_visited_links
      if params[:links].nil?
        render json: { status: 'parametr :links and :to is required'}, status: 422
      elsif !params[:links].is_a? Array
        render json: { status: 'parametr :links has array'}, status: 422
      end
    end
  end
end