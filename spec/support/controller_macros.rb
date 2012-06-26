module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = :user
      sign_in create(:user)
    end
  end
end

