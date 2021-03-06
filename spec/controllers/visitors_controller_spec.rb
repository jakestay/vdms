require 'spec_helper'

describe VisitorsController do
  before(:each) do
    @visitor = Factory.create(:visitor)
    @visitor.person.update_attribute(:ldap_id, 'visitor')
    @event = @visitor.event
    Event.stub(:find).and_return(@event)
    @admin = Factory.create(:person, :ldap_id => 'admin', :role => 'administrator')
    RubyCAS::Filter.fake('admin')
  end

  describe 'GET index' do
    it 'assigns to @event the given Event' do
      get :index, :event_id => @event.id
      assigns[:event].should == @event
    end

    it "assigns to @roles a list of the Event's Visitors sorted by Name" do
      visitors = Array.new(3) {Visitor.new}
      @event.stub(:visitors).and_return(visitors)
      get :index, :event_id => @event.id
      assigns[:roles].should == visitors
    end

    it 'renders the index template' do
      get :index, :event_id => @event.id
      response.should render_template('index')
    end
  end

  describe 'GET show' do
    it 'assigns to @event the given Event' do
      get :show, :event_id => @event.id, :id => @visitor.id
      assigns[:event].should == @event
    end

    it 'assigns to @roles the given Visitor' do
      @event.stub_chain(:visitors, :find).and_return(@visitor)
      get :show, :event_id => @event.id, :id => @visitor.id
      assigns[:role].should == @visitor
    end

    it 'renders the show template' do
      get :show, :event_id => @event.id, :id => @visitor.id
      response.should render_template('show')
    end
  end

  describe 'GET new' do
    it 'assigns to @people a list of People sorted by Name' do
      people = Array.new(3) {Person.new}
      Person.stub(:all).and_return(people)
      get :new, :event_id => @event.id
      assigns[:people].should == people
    end

    it 'assigns to @event the given Event' do
      get :new, :event_id => @event.id
      assigns[:event].should == @event
    end

    it 'assigns to @role a new Visitor' do
      get :new, :event_id => @event.id
      role = assigns[:role]
      role.should be_a_new_record
      role.should be_a_kind_of(Visitor)
      @event.visitors.should include(role)
    end

    it 'renders the new template' do
      get :new, :event_id => @event.id
      response.should render_template('new')
    end
  end

  describe 'GET edit' do
    it 'assigns to @event the given Event' do
      get :edit, :event_id => @event.id, :id => @visitor.id
      assigns[:event].should == @event
    end

    it 'assigns to @role the given Visitor' do
      Visitor.stub(:find).and_return(@visitor)
      get :edit, :event_id => @event.id, :id => @visitor.id
      assigns[:role].should == @visitor
    end

    it 'renders the edit template' do
      get :edit, :event_id => @event.id, :id => @visitor.id
      response.should render_template('edit')
    end
  end

  describe 'GET delete' do
    it 'assigns to @event the given Event' do
      get :delete, :event_id => @event.id, :id => @visitor.id
      assigns[:event].should == @event
    end

    it 'assigns to @role the given Visitor' do
      Visitor.stub(:find).and_return(@visitor)
      get :delete, :event_id => @event.id, :id => @visitor.id
      assigns[:role].should == @visitor
    end

    it 'renders the edit template' do
      get :delete, :event_id => @event.id, :id => @visitor.id
      response.should render_template('delete')
    end
  end

  describe 'POST create' do
    before(:each) do
      @event.stub_chain(:visitors, :new).and_return(@visitor)
      @event.visitors.stub(:build).and_return(@visitor)
    end

    it 'assigns to @role a new Visitor with the given parameters' do
      @event.visitors.should_receive(:build).with('foo' => 'bar').and_return(@visitor)
      post :create, :visitor => {'foo' => 'bar'}, :event_id => @event.id
      assigns[:role].should equal(@visitor)
    end

    it 'the new Visitor belongs to the given Event' do
      post :create, :visitor => {'foo' => 'bar'}, :event_id => @event.id
      role = assigns[:role]
      role.event.should == @event
    end

    it 'saves the Visitor' do
      @visitor.should_receive(:save)
      post :create, :visitor => {'foo' => 'bar'}, :event_id => @event.id
    end

    context 'when the Visitor is successfully saved' do
      before(:each) do
        @visitor.stub(:save).and_return(true)
      end

      it 'sets a flash[:notice] message' do
        post :create, :visitor => {'foo' => 'bar'}, :event_id => @event.id
        flash[:notice].should == I18n.t('visitors.create.success')
      end

      it 'redirects to the View Visitors page' do
        post :create, :visitor => {'foo' => 'bar'}, :event_id => @event.id
        response.should redirect_to(:action => 'index', :event_id => @event.id)
      end
    end

    context 'when the Visitor fails to be saved' do
      before(:each) do
        @visitor.stub(:save).and_return(false)
        @visitor.stub(:errors).and_return(:error => 'foo')
      end

      it 'assigns to @event the given Event' do
        post :create, :visitor => {'foo' => 'bar'}, :event_id => @event.id
        assigns[:event].should == @event
      end

      it 'renders the new template' do
        post :create, :visitor => {'foo' => 'bar'}, :event_id => @event.id
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      @event.stub_chain(:visitors, :find).and_return(@visitor)
    end

    it 'assigns to @role the given Role' do
      put :update, :visitor => {}, :event_id => @event.id, :id => @visitor.id
      assigns[:role].should equal(@visitor)
    end

    context 'when the Visitor is successfully updated' do
      before(:each) do
        @visitor.stub(:update_attributes).and_return(true)
      end

      context 'when signed in as the Visitor' do
        before(:each) do
          Person.stub(:find_by_ldap_id).and_return(@visitor.person)
          RubyCAS::Filter.fake('visitor')
        end

        it 'redirects to the view event page' do
          put :update, :visitor => {'foo' => 'bar'}, :event_id => @event.id, :id => @visitor.id
          response.should redirect_to(:controller => 'events', :action => 'show', :id => @event.id)
        end


        it 'sets a flash[:notice] message' do
          put :update, :visitor => {'foo' => 'bar'}, :event_id => @event.id, :id => @visitor.id
          flash[:notice].should == I18n.t('visitors.update.alt_success')
        end
      end

      context 'when signed in as someone other than the Visitor' do
        it 'sets a flash[:notice] message' do
          put :update, :visitor => {'foo' => 'bar'}, :event_id => @event.id, :id => @visitor.id
          flash[:notice].should == I18n.t('visitors.update.success')
        end

        it 'redirects to the View Visitors page' do
          put :update, :visitor => {'foo' => 'bar'}, :event_id => @event.id, :id => @visitor.id
          response.should redirect_to(:action => 'index', :event_id => @event.id)
        end
      end
    end

    context 'when the Visitor fails to be updated' do
      before(:each) do
        @visitor.stub(:update_attributes).and_return(false)
        @visitor.stub(:errors).and_return(:error => '')
      end

      it 'assigns to @event the given Event' do
        put :update, :visitor => {'foo' => 'bar'}, :event_id => @event.id, :id => @visitor.id
        assigns[:event].should == @event
      end

      it 'renders the edit template' do
        put :update, :visitor => {'foo' => 'bar'}, :event_id => @event.id, :id => @visitor.id
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @event.stub_chain(:visitors, :find).and_return(@visitor)
    end

    it 'destroys the Visitor' do
      @visitor.should_receive(:destroy)
      delete :destroy, :event_id => @event.id, :id => @visitor.id
    end

    it 'sets a flash[:notice] message' do
      delete :destroy, :event_id => @event.id, :id => @visitor.id
      flash[:notice].should == I18n.t('visitors.destroy.success')
    end

    it 'redirects to the View Visitors page' do
      delete :destroy, :event_id => @event.id, :id => @visitor.id
      response.should redirect_to(:action => 'index', :event_id => @event.id)
    end
  end

  describe 'DELETE destroy_from_current_user' do
    context 'when signed in as a User who has joined the Event' do
      before(:each) do
        Person.stub(:find).and_return(@visitor.person)
        RubyCAS::Filter.fake('visitor')
        @event.stub_chain(:roles, :find_by_person_id).and_return(@visitor)
      end

      it 'unregisters the User from the Event' do
        @visitor.should_receive(:destroy)
        delete :destroy_from_current_user, :event_id => @event.id
      end
    end

    it 'redirects to the view event page' do
      delete :destroy_from_current_user, :event_id => @event.id
      response.should redirect_to event_url(@event)
    end
  end
end
