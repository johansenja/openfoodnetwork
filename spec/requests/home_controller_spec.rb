# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HomeController, type: :request do
  context "#unauthorized" do
    it "renders the unauthorized template" do
      get "/unauthorized"

      expect(response).to have_http_status :unauthorized
      expect(response).to render_template("shared/unauthorized", layout: 'darkswarm')
    end
  end
end
