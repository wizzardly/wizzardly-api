# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  it { is_expected.to be_a ActionController::API }
  it { is_expected.to be_a Knock::Authenticable }
  it { is_expected.to be_a Pundit }

  it { is_expected.to use_after_action :verify_authorized }

  it_behaves_like "a redis connection"

  context "when unauthorized" do
    controller do
      def index
        raise Pundit::NotAuthorizedError
      end
    end

    before { get :index }

    it_behaves_like "an error response", :forbidden, "pundit.user_forbidden"
  end
end
