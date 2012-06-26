require 'spec_helper'

SimpleRoles.configure do |config|
  config.valid_roles = [:user, :admin, :editor]
end

describe SimpleRoles::Many do
  let(:user) { create :user }

  before(:each) do
    setup_roles
    SimpleRoles.package User, :many
  end

  context "Class Methods" do 
    subject { User }

    specify { should respond_to(:valid_roles) }
    its(:valid_roles) { should include(:user, :admin)}
  end

  context "Instance methods" do
    subject { User.new }
   
    [:roles, :roles_list].each do |meth|
      specify { should respond_to(meth) }
      its(:"#{meth}") { should be_empty }
    end
  end

  context "Read API" do
    subject do
      user
    end

    it "#has_role?, #has_roles?" do
      subject.roles = [:admin]
      
      subject.has_role?(:admin).should be_true
      subject.has_role?(:admin, :user).should be_false
      subject.has_roles?(:editor).should be_false
      
      subject.roles = [ :admin, :user ]

      subject.has_role?(:admin, :user).should be_true
      subject.has_role?([:admin, :user]).should be_true
    end

    it "#admin?, #user?, #editor? ..." do
      subject.roles = [ :admin ]
      subject.admin?.should be_true
      subject.is_admin?.should be_true
      subject.user?.should be_false
      subject.editor?.should be_false
      subject.roles = [ :editor ]
      subject.editor?.should be_true
    end
  end
  
  context "Write API" do
    subject do
      user
    end

    it "#roles= should set roles" do
      subject.roles = :admin
      subject.roles.should == Array.new([:admin])
      subject.roles = :user
      subject.roles.should == Array.new([:user])
    end

    it "#roles= should set roles if array of strings passed (sh accept strings too!)" do
      subject.roles = 'admin'
      subject.roles.should == Array.new([:admin])
      subject.roles = ['user', 'editor']
      subject.roles.should == Array.new([:user, :editor])
    end
    
    it "#remove_roles should remove roles" do
      subject.roles = [ :admin, :user, :editor ]

      subject.roles.should == Array.new([:admin, :user, :editor])
 
      subject.remove_roles :admin
      subject.roles.should == Array.new([:user, :editor])
  
      subject.remove_roles :admin, :user, :editor
      subject.roles.should == Array.new([])
    end
  end

  context "Integration for roles methods" do
    it "should work when #flatten is called over #roles" do
      user.roles = [ :admin ]
      
      user.roles_list.should == Array.new([:admin])
      user.roles_list.flatten.should == Array.new([:admin])
    end
    
    it "should add :roles to accessible_attributes if they are Whitelisted" do
      user.roles = [ :admin ]

      user.roles_list.should include(:admin)
      user.save!
      User.find_by_name!("stanislaw").should be_kind_of(User)
      User.delete_all

      User.attr_accessible :name
        
      user = User.new(:name => "stanislaw")
      user.roles = [ :admin ]
      user.roles_list.should include(:admin)
      user.save!
      User.find_by_name!("stanislaw").should be_kind_of(User)
    end
    
    it "should not duplicate roles when adding" do
      user.roles = [ :admin ]
      user.roles.should == [ :admin ]

      user.add_role :admin

      user.roles.should == [ :admin ]
    end
  end

  describe ".package" do
    describe "Persistence" do
      it "should set roles" do
        user.roles = :admin
        user.roles.should == [:admin]
      end
    end

    describe "Roles methods" do
      describe "#set_role" do
        it "should set role" do
          user.set_role(:admin)
          user.roles.should == [:admin]
        end

        it "should persist role" do
          user.set_role(:admin)
          user.reload
          user.roles.should == [:admin]
        end
      end

      describe "Dynamic scopes" do
        subject { User }
        SimpleRoles.config.valid_roles.each do |r|
          it { should respond_to :"#{r}s" }
          it { should respond_to(:"#{r}s_ids") }

          its(:"#{r}s") { should be_kind_of(Array) }
        end
      end

      describe "Dynamic methods" do
        SimpleRoles.config.valid_roles.each do |r|
          specify { user.should respond_to :"#{r}?" }
        end

        describe "#user?, #admin?, ..." do
          specify do
            user.set_role(:admin)
            user.admin?.should == true

            user.set_role(:user)
            user.user?.should == true
          end
        end
        
        describe "#is_user?, #is_admin?, ..." do
          specify do
            user.set_role(:admin)
            user.is_admin?.should == true

            user.set_role(:user)
            user.is_user?.should == true
          end
        end
      end
    end
  end
end
