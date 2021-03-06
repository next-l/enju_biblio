require 'rails_helper'

describe AgentsController do
  fixtures :all

  def valid_attributes
    FactoryBot.attributes_for(:agent)
  end

  describe 'GET index', solr: true do
    before(:each) do
      FactoryBot.create(:manifestation, :with_publisher)
      FactoryBot.create(:agent, :with_librarian_required, full_name: 'Librarian1')
      Agent.reindex
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns all agents as @agents' do
        get :index
        expect(assigns(:agents)).not_to be_empty
      end

      it 'should get index with agent_id' do
        agent = FactoryBot.create(:agent)
        get :index, params: { agent_id: agent.id }
        expect(response).to be_successful
        expect(assigns(:agent)).to eq agent
        expect(assigns(:agents)).to eq assigns(:agent).derived_agents.where('required_role_id >= 1').page(1)
      end

      it 'should get index with query' do
        get :index, params: { query: 'Librarian1' }
        expect(assigns(:agents)).not_to be_empty
        expect(response).to be_successful
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns all agents as @agents' do
        get :index
        expect(assigns(:agents)).not_to be_empty
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'assigns all agents as @agents' do
        get :index
        expect(assigns(:agents)).not_to be_empty
      end
    end

    describe 'When not logged in' do
      it 'assigns all agents as @agents' do
        get :index
        expect(assigns(:agents)).not_to be_empty
      end

      it 'assigns all agents as @agents in rss format' do
        get :index, format: :rss
        expect(assigns(:agents)).not_to be_empty
      end

      it 'assigns all agents as @agents in atom format' do
        get :index, format: :atom
        expect(assigns(:agents)).not_to be_empty
      end

      it 'should get index with agent_id' do
        manifestation = FactoryBot.create(:manifestation, :with_publisher)
        publisher = manifestation.publishers.first
        get :index, params: { agent_id: publisher.id }
        expect(response).to be_successful
        expect(assigns(:agent)).to eq publisher
        expect(assigns(:agents)).to eq assigns(:agent).derived_agents.where(required_role_id: 1).page(1)
      end

      it 'should get index with manifestation_id' do
        manifestation = Produce.first.manifestation
        get :index, params: { manifestation_id: manifestation.id }
        assigns(:manifestation).should eq manifestation
        expect(assigns(:agents)).to eq assigns(:manifestation).publishers.where(required_role_id: 1).page(1)
      end

      it 'should get index with query' do
        get :index, params: { query: 'Librarian1' }
        expect(assigns(:agents)).to be_empty
        expect(response).to be_successful
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      @agent = FactoryBot.create(:agent)
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested agent as @agent' do
        get :show, params: { id: @agent.id }
        expect(assigns(:agent)).to eq(@agent)
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested agent as @agent' do
        get :show, params: { id: @agent.id }
        expect(assigns(:agent)).to eq(@agent)
      end

      # it "should show agent when required_role is user" do
      #  get :show, :id => users(:user2).agent.id
      #  expect(assigns(:agent)).to eq(users(:user2).agent)
      #  expect(response).to be_successful
      # end

      # it "should show patron when required_role is librarian" do
      #  get :show, :id => users(:user1).agent.id
      #  expect(assigns(:agent)).to eq(users(:user1).agent)
      #  expect(response).to be_successful
      # end

      it 'should not show agent who does not create a work' do
        lambda do
          get :show, params: { id: 3, work_id: 3 }
        end.should raise_error(ActiveRecord::RecordNotFound)
        # expect(response).to be_missing
      end

      it 'should not show agent who does not produce a manifestation' do
        lambda do
          get :show, params: { id: 4, manifestation_id: 4 }
        end.should raise_error(ActiveRecord::RecordNotFound)
        # expect(response).to be_missing
      end

      # it "should not show agent when required_role is 'Administrator'" do
      #  sign_in users(:librarian2)
      #  get :show, :id => users(:librarian1).agent.id
      #  expect(response).to be_forbidden
      # end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'assigns the requested agent as @agent' do
        get :show, params: { id: @agent.id }
        expect(assigns(:agent)).to eq(@agent)
      end

      # it "should show user" do
      #  get :show, :id => users(:user2).agent.id
      #  assigns(:agent).required_role.name.should eq 'User'
      #  expect(response).to be_successful
      # end

      # it "should not show agent when required_role is 'Librarian'" do
      #  sign_in users(:user2)
      #  get :show, :id => users(:user1).agent.id
      #  expect(response).to be_forbidden
      # end
    end

    describe 'When not logged in' do
      it 'assigns the requested agent as @agent' do
        get :show, params: { id: @agent.id }
        expect(assigns(:agent)).to eq(@agent)
      end

      it 'should show agent with work' do
        work = FactoryBot.create(:manifestation)
        @agent.works << work
        get :show, params: { id: @agent.id, work_id: work.id }
        expect(assigns(:agent)).to eq assigns(:work).creators.last
      end

      it 'should show agent with expression' do
        expression = FactoryBot.create(:manifestation)
        @agent.expressions << expression
        get :show, params: { id: @agent.id, expression_id: expression.id }
        expect(assigns(:agent)).to eq assigns(:expression).contributors.first
      end

      it 'should show agent with manifestation' do
        manifestation = FactoryBot.create(:manifestation)
        @agent.manifestations << manifestation
        get :show, params: { id: @agent.id, manifestation_id: manifestation.id }
        expect(assigns(:agent)).to eq assigns(:manifestation).publishers.first
      end

      it "should not show agent when required_role is 'User'" do
        agent = FactoryBot.create(:agent, required_role_id: Role.find_by(name: 'User'))
        get :show, params: { id: agent.id }
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'GET new' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested agent as @agent' do
        get :new
        expect(assigns(:agent)).not_to be_valid
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested agent as @agent' do
        get :new
        expect(assigns(:agent)).not_to be_valid
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'should not assign the requested agent as @agent' do
        get :new
        expect(assigns(:agent)).to be_nil
        expect(response).to be_forbidden
      end
    end

    describe 'When not logged in' do
      it 'should not assign the requested agent as @agent' do
        get :new
        expect(assigns(:agent)).to be_nil
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET edit' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested agent as @agent' do
        agent = FactoryBot.create(:agent)
        get :edit, params: { id: agent.id }
        expect(assigns(:agent)).to eq(agent)
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested agent as @agent' do
        agent = FactoryBot.create(:agent)
        get :edit, params: { id: agent.id }
        expect(assigns(:agent)).to eq(agent)
      end

      # it "should edit agent when its required_role is 'User'" do
      #  get :edit, :id => users(:user2).agent.id
      #  expect(response).to be_successful
      # end

      # it "should edit agent when its required_role is 'Librarian'" do
      #  get :edit, :id => users(:user1).agent.id
      #  expect(response).to be_successful
      # end

      # it "should edit admin" do
      #  get :edit, :id => users(:admin).agent.id
      #  expect(response).to be_forbidden
      # end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'assigns the requested agent as @agent' do
        agent = FactoryBot.create(:agent)
        get :edit, params: { id: agent.id }
        expect(response).to be_forbidden
      end

      # it "should edit myself" do
      #  get :edit, :id => users(:user1).agent.id
      #  expect(response).to be_successful
      # end

      # it "should not edit other user's agent profile" do
      #  get :edit, :id => users(:user2).agent.id
      #  expect(response).to be_forbidden
      # end
    end

    describe 'When not logged in' do
      it 'should not assign the requested agent as @agent' do
        agent = FactoryBot.create(:agent)
        get :edit, params: { id: agent.id }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST create' do
    before(:each) do
      @attrs = valid_attributes
      @invalid_attrs = FactoryBot.attributes_for(:agent, full_name: '')
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      describe 'with valid params' do
        it 'assigns a newly created agent as @agent' do
          post :create, params: { agent: @attrs }
          expect(assigns(:agent)).to be_valid
        end

        it 'redirects to the created agent' do
          post :create, params: { agent: @attrs }
          expect(response).to redirect_to(agent_url(assigns(:agent)))
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved agent as @agent' do
          post :create, params: { agent: @invalid_attrs }
          expect(assigns(:agent)).not_to be_valid
        end

        it "re-renders the 'new' template" do
          post :create, params: { agent: @invalid_attrs }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      describe 'with valid params' do
        it 'assigns a newly created agent as @agent' do
          post :create, params: { agent: @attrs }
          expect(assigns(:agent)).to be_valid
        end

        it 'redirects to the created agent' do
          post :create, params: { agent: @attrs }
          expect(response).to redirect_to(agent_url(assigns(:agent)))
        end

        it 'should create a relationship if work_id is set' do
          work = FactoryBot.create(:manifestation)
          post :create, params: { agent: @attrs, work_id: work.id }
          expect(response).to redirect_to(agent_url(assigns(:agent)))
          assigns(:agent).works.should eq [work]
        end

        it 'should create a relationship if expression_id is set' do
          expression = FactoryBot.create(:manifestation)
          post :create, params: { agent: @attrs, expression_id: expression.id }
          expect(response).to redirect_to(agent_url(assigns(:agent)))
          assigns(:agent).expressions.should eq [expression]
        end

        it 'should create a relationship if manifestation_id is set' do
          manifestation = FactoryBot.create(:manifestation)
          post :create, params: { agent: @attrs, manifestation_id: manifestation.id }
          expect(response).to redirect_to(agent_url(assigns(:agent)))
          assigns(:agent).manifestations.should eq [manifestation]
        end

        it 'should create a relationship if item_id is set' do
          item = FactoryBot.create(:item)
          post :create, params: { agent: @attrs, item_id: item.id }
          expect(response).to redirect_to(agent_url(assigns(:agent)))
          assigns(:agent).items.should eq [item]
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved agent as @agent' do
          post :create, params: { agent: @invalid_attrs }
          expect(assigns(:agent)).not_to be_valid
        end

        it "re-renders the 'new' template" do
          post :create, params: { agent: @invalid_attrs }
          expect(response).to render_template('new')
        end
      end

      # TODO: full_name以外での判断
      it 'should create agent without full_name' do
        post :create, params: { agent: { first_name: 'test' } }
        expect(response).to redirect_to agent_url(assigns(:agent))
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      describe 'with valid params' do
        it 'assigns a newly created agent as @agent' do
          post :create, params: { agent: @attrs }
          expect(assigns(:agent)).to be_nil
        end

        it 'should be forbidden' do
          post :create, params: { agent: @attrs }
          expect(response).to be_forbidden
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved agent as @agent' do
          post :create, params: { agent: @invalid_attrs }
          expect(assigns(:agent)).to be_nil
        end

        it 'should be forbidden' do
          post :create, params: { agent: @invalid_attrs }
          expect(response).to be_forbidden
        end
      end

      # it "should not create agent myself" do
      #  post :create, :agent => { :full_name => 'test', :user_username => users(:user1).username }
      #  expect(assigns(:agent)).not_to be_valid
      #  expect(response).to be_successful
      # end

      # it "should not create other agent" do
      #  post :create, :agent => { :full_name => 'test', :user_id => users(:user2).username }
      #  expect(response).to be_forbidden
      # end
    end

    describe 'When not logged in' do
      describe 'with valid params' do
        it 'assigns a newly created agent as @agent' do
          post :create, params: { agent: @attrs }
          expect(assigns(:agent)).to be_nil
        end

        it 'should be forbidden' do
          post :create, params: { agent: @attrs }
          expect(response).to redirect_to(new_user_session_url)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved agent as @agent' do
          post :create, params: { agent: @invalid_attrs }
          expect(assigns(:agent)).to be_nil
        end

        it 'should be forbidden' do
          post :create, params: { agent: @invalid_attrs }
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      @agent = FactoryBot.create(:agent)
      @attrs = valid_attributes
      @invalid_attrs = FactoryBot.attributes_for(:agent, full_name: '')
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      describe 'with valid params' do
        it 'updates the requested agent' do
          put :update, params: { id: @agent.id, agent: @attrs }
        end

        it 'assigns the requested agent as @agent' do
          put :update, params: { id: @agent.id, agent: @attrs }
          expect(assigns(:agent)).to eq(@agent)
        end
      end

      describe 'with invalid params' do
        it 'assigns the requested agent as @agent' do
          put :update, params: { id: @agent.id, agent: @invalid_attrs }
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      describe 'with valid params' do
        it 'updates the requested agent' do
          put :update, params: { id: @agent.id, agent: @attrs }
        end

        it 'assigns the requested agent as @agent' do
          put :update, params: { id: @agent.id, agent: @attrs }
          expect(assigns(:agent)).to eq(@agent)
          expect(response).to redirect_to(@agent)
        end
      end

      describe 'with invalid params' do
        it 'assigns the agent as @agent' do
          put :update, params: { id: @agent, agent: @invalid_attrs }
          expect(assigns(:agent)).not_to be_valid
        end

        it "re-renders the 'edit' template" do
          put :update, params: { id: @agent, agent: @invalid_attrs }
          expect(response).to render_template('edit')
        end
      end

      # it "should update other agent" do
      #  put :update, :id => users(:user2).agent.id, :agent => { :full_name => 'test' }
      #  expect(response).to redirect_to agent_url(assigns(:agent))
      # end
    end

    describe 'When logged in as User' do
      login_fixture_user

      describe 'with valid params' do
        it 'updates the requested agent' do
          put :update, params: { id: @agent.id, agent: @attrs }
        end

        it 'assigns the requested agent as @agent' do
          put :update, params: { id: @agent.id, agent: @attrs }
          expect(assigns(:agent)).to eq(@agent)
          expect(response).to be_forbidden
        end
      end

      describe 'with invalid params' do
        it 'assigns the requested agent as @agent' do
          put :update, params: { id: @agent.id, agent: @invalid_attrs }
          expect(response).to be_forbidden
        end
      end

      # it "should update myself" do
      #  put :update, :id => users(:user1).agent.id, :agent => { :full_name => 'test' }
      #  expect(assigns(:agent)).to be_valid
      #  expect(response).to redirect_to agent_url(assigns(:agent))
      # end

      # it "should not update myself without name" do
      #  put :update, :id => users(:user1).agent.id, :agent => { :first_name => '', :last_name => '', :full_name => '' }
      #  expect(assigns(:agent)).not_to be_valid
      #  expect(response).to be_successful
      # end

      # it "should not update other agent" do
      #  put :update, :id => users(:user2).agent.id, :agent => { :full_name => 'test' }
      #  expect(response).to be_forbidden
      # end
    end

    describe 'When not logged in' do
      describe 'with valid params' do
        it 'updates the requested agent' do
          put :update, params: { id: @agent.id, agent: @attrs }
        end

        it 'should be forbidden' do
          put :update, params: { id: @agent.id, agent: @attrs }
          expect(response).to redirect_to(new_user_session_url)
        end
      end

      describe 'with invalid params' do
        it 'assigns the requested agent as @agent' do
          put :update, params: { id: @agent.id, agent: @invalid_attrs }
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @agent = FactoryBot.create(:agent)
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'destroys the requested agent' do
        delete :destroy, params: { id: @agent.id }
      end

      it 'redirects to the agents list' do
        delete :destroy, params: { id: @agent.id }
        expect(response).to redirect_to(agents_url)
      end

      # it "should not destroy librarian who has items checked out" do
      #  delete :destroy, :id => users(:librarian1).agent.id
      #  expect(response).to be_forbidden
      # end

      # it "should destroy librarian who does not have items checked out" do
      #  delete :destroy, :id => users(:librarian2).agent.id
      #  expect(response).to redirect_to agents_url
      # end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'destroys the requested agent' do
        delete :destroy, params: { id: @agent.id }
      end

      it 'redirects to the agents list' do
        delete :destroy, params: { id: @agent.id }
        expect(response).to redirect_to(agents_url)
      end

      # it "should not destroy librarian" do
      #  delete :destroy, :id => users(:librarian2).agent.id
      #  expect(response).to be_forbidden
      # end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'destroys the requested agent' do
        delete :destroy, params: { id: @agent.id }
      end

      it 'should be forbidden' do
        delete :destroy, params: { id: @agent.id }
        expect(response).to be_forbidden
      end

      # it "should not destroy agent" do
      #  delete :destroy, :id => users(:user1).agent.id
      #  expect(response).to be_forbidden
      # end
    end

    describe 'When not logged in' do
      it 'destroys the requested agent' do
        delete :destroy, params: { id: @agent.id }
      end

      it 'should be forbidden' do
        delete :destroy, params: { id: @agent.id }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
