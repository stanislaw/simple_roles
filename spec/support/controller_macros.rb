module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = :user
      sign_in Factory(:user) #@admin
    end
  end

  def login_student
    before(:each) do
       @student = User.create!(:username => "AStudent", :email => "agb@yandex.ru", :middlename => "Sergeevna", :surname => "Bakhtiyarova", :name => "Galina", :password => "666666", :role => :student)
      @request.env["devise.mapping"] = @student
      sign_in @student
    end
  end

  def login_curator
    before(:each) do
       @curator = User.create!(:username => "AStudent", :email => "agb@yandex.ru", :middlename => "Sergeevna", :surname => "Bakhtiyarova", :name => "Galina", :password => "666666", :role => :curator)
      @request.env["devise.mapping"] = @curator
      sign_in @curator
    end
  end

end

