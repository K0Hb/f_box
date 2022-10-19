module Api::V1
  class BaseController < ApplicationController
    def visited_links
      response = Statistics.call(visited_links_params, mode = 'write')
      render json: response, status: 201
    end

    def visited_domains
      response = Statistics.call(visited_domains_params, mode = 'get')
      render json: response, status: 200
    end

    private

    def visited_links_params
      params[:links]
    end

    def visited_domains_params
      params.permit(:from, :to)
    end
  end
end