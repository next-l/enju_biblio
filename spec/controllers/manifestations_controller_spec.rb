require 'rails_helper'

describe ManifestationsController do
  fixtures :all

  def valid_attributes
    FactoryBot.attributes_for(:manifestation)
  end

  describe 'GET index', solr: true do
    before do
      Manifestation.reindex
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns all manifestations as @manifestations' do
        get :index
        expect(assigns(:manifestations)).to_not be_nil
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns all manifestations as @manifestations' do
        get :index
        expect(assigns(:manifestations)).to_not be_nil
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'assigns all manifestations as @manifestations' do
        get :index
        expect(assigns(:manifestations)).to_not be_nil
      end
    end

    describe 'When not logged in' do
      it 'assigns all manifestations as @manifestations' do
        get :index
        expect(assigns(:manifestations)).to_not be_nil
      end

      it 'assigns all manifestations as @manifestations in xml format without operation' do
        get :index, params: { format: 'xml' }
        expect(response).to be_success
        expect(assigns(:manifestations)).to_not be_nil
      end

      it 'assigns all manifestations as @manifestations in txt format without operation' do
        get :index, params: { format: 'txt' }
        expect(response).to be_success
        expect(assigns(:manifestations)).to_not be_nil
        expect(response).to render_template('manifestations/index')
      end

      it 'assigns all manifestations as @manifestations in sru format without operation' do
        get :index, params: { format: 'sru' }
        assert_response :success
        expect(assigns(:manifestations)).to be_nil
        expect(response).to render_template('manifestations/explain')
      end

      it 'assigns all manifestations as @manifestations in sru format with operation' do
        get :index, params: { format: 'sru', operation: 'searchRetrieve', query: 'ruby' }
        expect(assigns(:manifestations)).to_not be_nil
        expect(response).to render_template('manifestations/index')
      end

      it 'assigns all manifestations as @manifestations in sru format with operation and title' do
        get :index, params: { format: 'sru', query: 'title=ruby', operation: 'searchRetrieve' }
        expect(assigns(:manifestations)).to_not be_nil
        expect(response).to render_template('manifestations/index')
      end

      it 'assigns all manifestations as @manifestations in openurl' do
        get :index, params: { api: 'openurl', title: 'ruby' }
        expect(assigns(:manifestations)).to_not be_nil
      end

      it 'assigns all manifestations as @manifestations when pub_date_from and pub_date_until are specified' do
        get :index, params: { pub_date_from: '2000', pub_date_until: '2007' }
        assigns(:query).should eq "date_of_publication_d:[#{Time.zone.parse('2000-01-01').beginning_of_day.utc.iso8601} TO #{Time.zone.parse('2007-12-31').end_of_year.utc.iso8601}]"
        expect(assigns(:manifestations)).to_not be_nil
      end

      it 'assigns all manifestations as @manifestations when old pub_date_from and pub_date_until are specified' do
        get :index, params: { pub_date_from: '200', pub_date_until: '207' }
        assigns(:query).should eq "date_of_publication_d:[#{Time.zone.parse('200-01-01').utc.iso8601} TO #{Time.zone.parse('207-12-31').end_of_year.utc.iso8601}]"
        expect(assigns(:manifestations)).to_not be_nil
      end

      it 'assigns all manifestations as @manifestations when acquired_from and pub_date_until are specified' do
        get :index, params: { acquired_from: '2000', acquired_until: '2007' }
        assigns(:query).should eq "acquired_at_d:[#{Time.zone.parse('2000-01-01').beginning_of_day.utc.iso8601} TO #{Time.zone.parse('2007-12-31').end_of_year.utc.iso8601}]"
        expect(assigns(:manifestations)).to_not be_nil
      end

      it 'assigns all manifestations as @manifestations when old acquired_from and pub_date_until are specified' do
        get :index, params: { acquired_from: '200', acquired_until: '207' }
        assigns(:query).should eq "acquired_at_d:[#{Time.zone.parse('200-01-01').utc.iso8601} TO #{Time.zone.parse('207-12-31').end_of_day.utc.iso8601}]"
        expect(assigns(:manifestations)).to_not be_nil
      end

      it 'assigns all manifestations as @manifestations when number_of_pages_at_least and number_of_pages_at_most are specified' do
        get :index, params: { number_of_pages_at_least: '100', number_of_pages_at_most: '200' }
        expect(assigns(:manifestations)).to_not be_nil
      end

      it 'assigns all manifestations as @manifestations in mods format' do
        get :index, params: { format: 'mods' }
        expect(assigns(:manifestations)).to_not be_nil
        expect(response).to render_template('manifestations/index')
      end

      it 'assigns all manifestations as @manifestations in rdf format' do
        get :index, params: { format: 'rdf' }
        expect(assigns(:manifestations)).to_not be_nil
        expect(response).to render_template('manifestations/index')
      end

      it 'should get index with manifestation_id' do
        get :index, params: { manifestation_id: manifestations(:manifestation_00001) }
        expect(response).to be_success
        expect(assigns(:manifestation)).to eq manifestations(:manifestation_00001)
        assigns(:manifestations).collect(&:id).should eq assigns(:manifestation).derived_manifestations.collect(&:id)
      end

      it 'should get index with query' do
        get :index, params: { query: '2005' }
        expect(response).to be_success
        expect(assigns(:manifestations)).to_not be_blank
      end

      it 'should get index with page number' do
        get :index, params: { query: '2005', number_of_pages_at_least: 1, number_of_pages_at_most: 100 }
        expect(response).to be_success
        assigns(:query).should eq '2005 number_of_pages_i:[1 TO 100]'
      end

      it 'should get index with pub_date_from' do
        get :index, params: { query: '2005', pub_date_from: '2000' }
        expect(response).to be_success
        expect(assigns(:manifestations)).to be_truthy
        assigns(:query).should eq '2005 date_of_publication_d:[2000-01-01T00:00:00Z TO *]'
      end

      it 'should get index with pub_date_until' do
        get :index, params: { query: '2005', pub_date_until: '2000' }
        expect(response).to be_success
        expect(assigns(:manifestations)).to be_truthy
        assigns(:query).should eq '2005 date_of_publication_d:[* TO 2000-12-31T23:59:59Z]'
      end

      it 'should get tag_cloud' do
        get :index, params: { query: '2005', view: 'tag_cloud' }
        expect(response).to be_success
        expect(response).to render_template('manifestations/_tag_cloud')
      end

      it 'should show manifestation with isbn', solr: true do
        get :index, params: { isbn: '4798002062' }
        expect(response).to be_success
        expect(assigns(:manifestations).count).to eq 1
      end

      it 'should not show missing manifestation with isbn', solr: true do
        get :index, params: { isbn: '47980020620' }
        expect(response).to be_success
        expect(assigns(:manifestations)).to be_empty
      end

      it 'should show manifestation with library 3', solr: true do
        get :index, params: { library_adv: ['hachioji'] }
        expect(response).to be_success
        expect(assigns(:manifestations).size).to eq 1
      end

      it 'should show manifestation with library 2 or 3', solr: true do
        get :index, params: { library_adv: %w[hachioji kamata] }
        expect(response).to be_success
        expect(assigns(:manifestations).size).to eq 2
      end

      it 'should show manifestation with call_number', solr: true do
        get :index, params: { call_number: '547|ヤ' }
        expect(response).to be_success
        expect(assigns(:manifestations)).not_to be_empty
      end

      it 'should show manifestation with NDC', solr: true do
        classification = FactoryBot.create(:classification, category: '007.3', classification_type_id: 1)
        Manifestation.first.classifications << classification
        get :index, params: { classification: '007', classification_type: 1 }
        expect(response).to be_success
        expect(assigns(:manifestations)).not_to be_empty
      end

      it 'should not search with classification if classification is blank' do
        get :index, params: { classification: '', classification_type: 1 }
        expect(response).to be_success
        expect(assigns(:query)).not_to match /classification/
      end

      it 'should accept per_page params' do
        get :index, params: { per_page: 3 }
        expect(assigns(:manifestations).count).to eq 3
        expect(assigns(:manifestations).total_count).to eq Manifestation.where(required_role_id: 1).count
      end

      it 'should accept page parameter' do
        get :index
        original_manifestations = assigns(:manifestations)
        expect(original_manifestations.count).to eq 10
        get :index, params: { page: 2 }
        manifestations_page2 = assigns(:manifestations)
        expect(manifestations_page2.count).to eq 10
        expect(original_manifestations.first).not_to eq manifestations_page2.first
      end

      it 'should accept sort_by parameter' do
        get :index, params: { sort_by: 'created_at:desc' }
        manifestations = assigns(:manifestations)
        expect(manifestations.first.created_at).to be >= manifestations.last.created_at
        get :index, params: { sort_by: 'created_at:asc' }
        manifestations = assigns(:manifestations)
        expect(manifestations.first.created_at).to be <= manifestations.last.created_at
      end

      it "should get manifestations with series for its children's information" do
        periodical = FactoryBot.create(:manifestation_serial)
        manifestation = FactoryBot.create(:manifestation, description: 'foo')
        periodical.derived_manifestations << manifestation
        periodical.save!
        get :index, params: { query: 'foo' }
        manifestations = assigns(:manifestations)
        expect(manifestations).not_to be_blank
        expect(manifestations.map(&:id)).to include periodical.id
      end
    end
  end

  describe 'GET show' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested manifestation as @manifestation' do
        get :show, params: { id: manifestations(:manifestation_00001).id }
        expect(assigns(:manifestation)).to eq(Manifestation.find('1ff5b88a-1964-4db0-acb3-ae1d9e3a307e'))
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested manifestation as @manifestation' do
        get :show, params: { id: manifestations(:manifestation_00001).id }
        expect(assigns(:manifestation)).to eq(Manifestation.find('1ff5b88a-1964-4db0-acb3-ae1d9e3a307e'))
      end

      it 'should show manifestation with agent who does not produce it' do
        get :show, params: { id: manifestations(:manifestation_00003).id, agent_id: 3 }
        expect(assigns(:manifestation)).to eq assigns(:agent).manifestations.find(manifestations(:manifestation_00003).id)
        expect(response).to be_success
      end

      it 'should not show manifestation with required_role of admin' do
        manifestation = FactoryBot.create(:manifestation, required_role_id: 4)
        get :show, params: { id: manifestation.id }
        expect(response).not_to be_success
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'assigns the requested manifestation as @manifestation' do
        get :show, params: { id: manifestations(:manifestation_00001).id }
        expect(assigns(:manifestation)).to eq(Manifestation.find(manifestations(:manifestation_00001).id))
      end

      it 'should send manifestation detail email' do
        get :show, params: { id: manifestations(:manifestation_00001).id, mode: 'send_email' }
        expect(response).to redirect_to manifestation_url(assigns(:manifestation))
      end

      # it "should show myself" do
      #  get :show, :id => users(:user1).agent
      #  expect(response).to be_success
      # end
    end

    describe 'When not logged in' do
      it 'assigns the requested manifestation as @manifestation' do
        get :show, params: { id: manifestations(:manifestation_00001).id }
        expect(assigns(:manifestation)).to eq manifestations(:manifestation_00001)
      end

      it 'guest should show manifestation mods template' do
        get :show, params: { id: manifestations(:manifestation_00022).id, format: 'mods' }
        expect(assigns(:manifestation)).to eq manifestations(:manifestation_00022)
        expect(response).to render_template('manifestations/show')
      end

      it 'should show manifestation rdf template' do
        get :show, params: { id: manifestations(:manifestation_00022).id, format: 'rdf' }
        expect(assigns(:manifestation)).to eq manifestations(:manifestation_00022)
        expect(response).to render_template('manifestations/show')
      end

      it 'should show manifestation with holding' do
        get :show, params: { id: manifestations(:manifestation_00001).id, mode: 'holding' }
        expect(response).to be_success
      end

      it 'should show manifestation with tag_edit' do
        get :show, params: { id: manifestations(:manifestation_00001).id, mode: 'tag_edit' }
        expect(response).to render_template('manifestations/_tag_edit')
        expect(response).to be_success
      end

      it 'should show manifestation with tag_list' do
        get :show, params: { id: manifestations(:manifestation_00001).id, mode: 'tag_list' }
        expect(response).to render_template('manifestations/_tag_list')
        expect(response).to be_success
      end

      it 'should show manifestation with show_creators' do
        get :show, params: { id: manifestations(:manifestation_00001).id, mode: 'show_creators' }
        expect(response).to render_template('manifestations/_show_creators')
        expect(response).to be_success
      end

      it 'should show manifestation with show_all_creators' do
        get :show, params: { id: manifestations(:manifestation_00001).id, mode: 'show_all_creators' }
        expect(response).to render_template('manifestations/_show_creators')
        expect(response).to be_success
      end

      it "should not send manifestation's detail email" do
        get :show, params: { id: manifestations(:manifestation_00001).id, mode: 'send_email' }
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'GET new' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested manifestation as @manifestation' do
        get :new
        expect(assigns(:manifestation)).to_not be_valid
      end

      it 'should get new template without expression_id' do
        get :new
        expect(response).to be_success
      end

      it 'should get new template with expression_id' do
        get :new, params: { expression_id: manifestations(:manifestation_00001).id }
        expect(response).to be_success
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested manifestation as @manifestation' do
        get :new
        expect(assigns(:manifestation)).to_not be_valid
      end

      it 'should get new template without expression_id' do
        get :new
        expect(response).to be_success
      end

      it 'should get new template with expression_id' do
        get :new, params: { expression_id: manifestations(:manifestation_00001).id }
        expect(response).to be_success
      end

      it 'should get new template with parent_id' do
        serial = FactoryBot.create(:manifestation_serial,
                                    statement_of_responsibility: 'statement_of_responsibility1',
                                    title_alternative: 'title_alternative1',
                                    publication_place: 'publication_place1',
                                    height: 123,
                                    width: 123,
                                    depth: 123,
                                    price: 'price1',
                                    access_address: 'http://example.jp',
                                    language_id: FactoryBot.create(:language).id,
                                    frequency_id: FactoryBot.create(:frequency).id,
                                    required_role_id: FactoryBot.create(:role).id)
        serial.creators << FactoryBot.create(:agent)
        serial.contributors << FactoryBot.create(:agent)
        serial.publishers << FactoryBot.create(:agent)
        serial.subjects << FactoryBot.create(:subject)
        serial.classifications << FactoryBot.create(:classification)
        serial.save!
        get :new, params: { parent_id: serial.id }
        expect(response).to be_success
        manifestation = assigns(:manifestation)
        parent = assigns(:parent)
        expect(parent).to be_truthy
        expect(manifestation.original_title).to eq parent.original_title
        expect(manifestation.creators).to eq parent.creators
        expect(manifestation.contributors).to eq parent.contributors
        expect(manifestation.publishers).to eq parent.publishers
        expect(manifestation.classifications).to eq parent.classifications
        expect(manifestation.subjects).to eq parent.subjects
        expect(manifestation.statement_of_responsibility).to eq parent.statement_of_responsibility
        expect(manifestation.title_alternative).to eq parent.title_alternative
        expect(manifestation.publication_place).to eq parent.publication_place
        expect(manifestation.height).to eq parent.height
        expect(manifestation.width).to eq parent.width
        expect(manifestation.depth).to eq parent.depth
        expect(manifestation.price).to eq parent.price
        expect(manifestation.access_address).to eq parent.access_address
        expect(manifestation.language).to eq parent.language
        expect(manifestation.frequency).to eq parent.frequency
        expect(manifestation.required_role).to eq parent.required_role
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'should not assign the requested manifestation as @manifestation' do
        get :new
        expect(assigns(:manifestation)).to be_nil
        expect(response).to be_forbidden
      end
    end

    describe 'When not logged in' do
      it 'should not assign the requested manifestation as @manifestation' do
        get :new
        expect(assigns(:manifestation)).to be_nil
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET edit' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested manifestation as @manifestation' do
        manifestation = FactoryBot.create(:manifestation)
        get :edit, params: { id: manifestation.id }
        expect(assigns(:manifestation)).to eq(manifestation)
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested manifestation as @manifestation' do
        manifestation = FactoryBot.create(:manifestation)
        get :edit, params: { id: manifestation.id }
        expect(assigns(:manifestation)).to eq(manifestation)
      end

      render_views
      it 'assigns the isbn_records to @manifestation' do
        manifestation = FactoryBot.create(:manifestation)
        manifestation.isbn_records << isbn_records(:isbn_record_00001)
        get :edit, params: { id: manifestation.id }
        expect(assigns(:manifestation)).to eq manifestation
        expect(assigns(:manifestation).isbn_records).to eq manifestation.isbn_records
        expect(response).to render_template(partial: 'manifestations/_isbn_record_fields')
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'assigns the requested manifestation as @manifestation' do
        manifestation = FactoryBot.create(:manifestation)
        get :edit, params: { id: manifestation.id }
        expect(response).to be_forbidden
      end

      it 'should edit manifestation with tag_edit' do
        get :edit, params: { id: manifestations(:manifestation_00001).id, mode: 'tag_edit' }
        expect(response).to be_success
      end
    end

    describe 'When not logged in' do
      it 'should not assign the requested manifestation as @manifestation' do
        manifestation = FactoryBot.create(:manifestation)
        get :edit, params: { id: manifestation.id }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST create' do
    before(:each) do
      @attrs = valid_attributes
      @invalid_attrs = { original_title: '' }
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      describe 'with valid params' do
        it 'assigns a newly created manifestation as @manifestation' do
          post :create, params: { manifestation: @attrs }
          expect(assigns(:manifestation)).to be_valid
        end

        it 'assigns a series_statement' do
          post :create, params: { manifestation: @attrs.merge(series_statements_attributes: { '0' => { original_title: SeriesStatement.find(1).original_title } }) }
          assigns(:manifestation).reload
          assigns(:manifestation).series_statements.pluck(:original_title).include?(series_statements(:one).original_title).should be_truthy
        end

        it 'redirects to the created manifestation' do
          post :create, params: { manifestation: @attrs }
          expect(response).to redirect_to(manifestation_url(assigns(:manifestation)))
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved manifestation as @manifestation' do
          post :create, params: { manifestation: @invalid_attrs }
          expect(assigns(:manifestation)).to_not be_valid
        end

        it "re-renders the 'new' template" do
          post :create, params: { manifestation: @invalid_attrs }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      describe 'with valid params' do
        it 'assigns a newly created manifestation as @manifestation' do
          post :create, params: { manifestation: @attrs }
          expect(assigns(:manifestation)).to be_valid
        end

        it 'redirects to the created manifestation' do
          post :create, params: { manifestation: @attrs }
          expect(response).to redirect_to(manifestation_url(assigns(:manifestation)))
        end

        it 'accepts an attachment file' do
          post :create, params: { manifestation: @attrs.merge(attachment: fixture_file_upload('/../../examples/resource_import_file_sample1.tsv', 'text/csv')) }
          expect(assigns(:manifestation)).to be_valid
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved manifestation as @manifestation' do
          post :create, params: { manifestation: @invalid_attrs }
          expect(assigns(:manifestation)).to_not be_valid
        end

        it "re-renders the 'new' template" do
          post :create, params: { manifestation: @invalid_attrs }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      describe 'with valid params' do
        it 'assigns a newly created manifestation as @manifestation' do
          post :create, params: { manifestation: @attrs }
          expect(assigns(:manifestation)).to be_nil
        end

        it 'should be forbidden' do
          post :create, params: { manifestation: @attrs }
          expect(response).to be_forbidden
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved manifestation as @manifestation' do
          post :create, params: { manifestation: @invalid_attrs }
          expect(assigns(:manifestation)).to be_nil
        end

        it 'should be forbidden' do
          post :create, params: { manifestation: @invalid_attrs }
          expect(response).to be_forbidden
        end
      end
    end

    describe 'When not logged in' do
      describe 'with valid params' do
        it 'assigns a newly created manifestation as @manifestation' do
          post :create, params: { manifestation: @attrs }
          expect(assigns(:manifestation)).to be_nil
        end

        it 'should be forbidden' do
          post :create, params: { manifestation: @attrs }
          expect(response).to redirect_to(new_user_session_url)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved manifestation as @manifestation' do
          post :create, params: { manifestation: @invalid_attrs }
          expect(assigns(:manifestation)).to be_nil
        end

        it 'should be forbidden' do
          post :create, params: { manifestation: @invalid_attrs }
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      @manifestation = FactoryBot.create(:manifestation)
      @manifestation.series_statements = [SeriesStatement.find(1)]
      @attrs = valid_attributes
      @invalid_attrs = { original_title: '' }
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      describe 'with valid params' do
        it 'updates the requested manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs }
        end

        it 'assigns a series_statement' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs.merge(series_statements_attributes: { '0' => { :original_title => series_statements(:two).original_title, '_destroy' => 'false' } }) }
          assigns(:manifestation).reload
          assigns(:manifestation).series_statements.pluck(:original_title).include?(series_statements(:two).original_title).should be_truthy
        end

        it 'assigns the requested manifestation as @manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs }
          expect(assigns(:manifestation)).to eq(@manifestation)
        end
      end

      describe 'with invalid params' do
        it 'assigns the requested manifestation as @manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @invalid_attrs }
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      describe 'with valid params' do
        it 'updates the requested manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs }
        end

        it 'assigns the requested manifestation as @manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs }
          expect(assigns(:manifestation)).to eq(@manifestation)
          expect(response).to redirect_to(@manifestation)
        end

        it 'assigns isbn_records to @manifestation' do
          isbn_record_attrs = {
            isbn_record_attributes: [isbn_records(:isbn_record_00001)]
          }
          put :update, params: { id: @manifestation.id, manifestation: @attrs.merge(isbn_record_attrs) }
          expect(assigns(:manifestation)).to eq @manifestation
        end
      end

      describe 'with invalid params' do
        it 'assigns the manifestation as @manifestation' do
          put :update, params: { id: @manifestation, manifestation: @invalid_attrs }
          expect(assigns(:manifestation)).to_not be_valid
        end

        it "re-renders the 'edit' template" do
          put :update, params: { id: @manifestation, manifestation: @invalid_attrs }
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      describe 'with valid params' do
        it 'updates the requested manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs }
        end

        it 'assigns the requested manifestation as @manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs }
          expect(assigns(:manifestation)).to eq(@manifestation)
          expect(response).to be_forbidden
        end
      end

      describe 'with invalid params' do
        it 'assigns the requested manifestation as @manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @invalid_attrs }
          expect(response).to be_forbidden
        end
      end
    end

    describe 'When not logged in' do
      describe 'with valid params' do
        it 'updates the requested manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs }
        end

        it 'should be forbidden' do
          put :update, params: { id: @manifestation.id, manifestation: @attrs }
          expect(response).to redirect_to(new_user_session_url)
        end
      end

      describe 'with invalid params' do
        it 'assigns the requested manifestation as @manifestation' do
          put :update, params: { id: @manifestation.id, manifestation: @invalid_attrs }
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @manifestation = FactoryBot.create(:manifestation)
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'destroys the requested manifestation' do
        delete :destroy, params: { id: @manifestation.id }
      end

      it 'redirects to the manifestations list' do
        delete :destroy, params: { id: @manifestation.id }
        expect(response).to redirect_to(manifestations_url)
      end

      it 'should not destroy the reserved manifestation' do
        delete :destroy, params: { id: manifestations(:manifestation_00002).id }
        expect(response).to be_forbidden
      end

      it 'should not destroy manifestation contains items' do
        delete :destroy, params: { id: manifestations(:manifestation_00001).id }
        expect(response).to be_forbidden
      end

      it 'should not destroy manifestation of series master with children' do
        @manifestation = FactoryBot.create(:manifestation_serial)
        child = FactoryBot.create(:manifestation)
        @manifestation.derived_manifestations << child
        delete :destroy, params: { id: @manifestation.id }
        expect(response).to be_forbidden
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'destroys the requested manifestation' do
        delete :destroy, params: { id: @manifestation.id }
      end

      it 'should be forbidden' do
        delete :destroy, params: { id: @manifestation.id }
        expect(response).to redirect_to(manifestations_url)
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'destroys the requested manifestation' do
        delete :destroy, params: { id: @manifestation.id }
      end

      it 'should be forbidden' do
        delete :destroy, params: { id: @manifestation.id }
        expect(response).to be_forbidden
      end
    end

    describe 'When not logged in' do
      it 'destroys the requested manifestation' do
        delete :destroy, params: { id: @manifestation.id }
      end

      it 'should be forbidden' do
        delete :destroy, params: { id: @manifestation.id }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
