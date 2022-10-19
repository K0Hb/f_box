module Api::V1
  class BaseController < ApplicationController
    def visited_links
      render json: { success: true }
    end

    def visited_domains
      render json: { success: true }
    end
  end
end