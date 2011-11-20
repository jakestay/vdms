class FeaturesController < EventBaseController
  # GET /events/1/constraints
  # GET /events/1/goals
  def index
    @features = get_features
  end

  # GET /events/1/constraints/new
  # GET /events/1/goals/new
  def new
    @feature = get_feature
    @host_field_types = @event.host_field_types.map {|t| [t.name, t.id]}
    @visitor_field_types = @event.visitor_field_types.map {|t| [t.name, t.id]}
    @feature_list = Feature.feature_list_for(@feature.host_field_type, @feature.visitor_field_type) unless @feature.host_field_type.nil? or @feature.visitor_field_type.nil?
    if @feature.host_field_type.nil? or @feature.visitor_field_type.nil?
      render :template => "#{get_view_path}/select_field_types"
    elsif @feature.feature_type.blank?
      render :template => "#{get_view_path}/select_feature_type"
    end
  end

  # GET /events/1/constraints/1/edit
  # GET /events/1/goals/1/edit
  def edit
    @feature = get_feature
    @host_field_types = @event.host_field_types.map {|t| [t.name, t.id]}
    @visitor_field_types = @event.visitor_field_types.map {|t| [t.name, t.id]}
    @feature_list = Feature.feature_list_for(@feature.host_field_type, @feature.visitor_field_type)
  end

  # GET /events/1/constraints/1/delete
  # GET /events/1/goals/1/delete
  def delete
    @feature = get_feature
  end

  # POST /events/1/constraints
  # POST /events/1/goals
  def create
    @feature = get_feature
    if @feature.save
      flash[:notice] = t('create.success', :scope => get_i18n_scope)
      redirect_to :action => 'index'
    else
      @host_field_types = @event.host_field_types.map {|t| [t.name, t.id]}
      @visitor_field_types = @event.visitor_field_types.map {|t| [t.name, t.id]}
      @feature_list = Feature.feature_list_for(@feature.host_field_type, @feature.visitor_field_type)
      render :action => 'new'
    end
  end

  # PUT /events/1/constraints/1
  # PUT /events/1/goals/1
  def update
    @feature = get_feature
    if @feature.update_attributes(get_attributes)
      flash[:notice] = t('update.success', :scope => get_i18n_scope)
      redirect_to :action => 'index'
    else
      @host_field_types = @event.host_field_types.map {|t| [t.name, t.id]}
      @visitor_field_types = @event.visitor_field_types.map {|t| [t.name, t.id]}
      @feature_list = Feature.feature_list_for(@feature.host_field_type, @feature.visitor_field_type)
      render :action => 'edit'
    end
  end

  # DELETE /events/1/constraints/1
  # DELETE /events/1/goals/1
  def destroy
    get_feature.destroy
    flash[:notice] = t('destroy.success', :scope => get_i18n_scope)
    redirect_to :action => 'index'
  end
end
