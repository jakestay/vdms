$ = jQuery.sub()
TimeSlot = App.TimeSlot
Visitor = App.Visitor
VisitorFieldType = App.VisitorFieldType
Host = App.Host

class EditProfile extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active () ->
      @change()

  change: () ->
    @item = Visitor.find(app.role_id)
    @render()

  render: ->
    @html @view('visitors/edit')(
      helper:
        render_data_type: (data_type, params) =>
          @view("data_type_input/" + data_type)(params)
      visitor: @item
    )
    $('#edit').fromObject(data: @item.attributes())
    afterRender()

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/'

class EditAvailabilities extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active () ->
      @change()

  change: () ->
    @item = Visitor.find(app.role_id)
    @render()

  render: ->
    @html @view('visitors/edit_availabilities')(visitor: @item)
    $('#edit_availabilities').fromObject(data: @item.attributes())
    afterRender()

  back: ->
    @navigate '/'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/'

class Index extends Spine.Controller
  events:
    'click [data-type=edit_profile]': 'edit_profile'
    'click [data-type=edit_availabilities]': 'edit_availabilities'

  constructor: ->
    super
    showSpinner()
    Visitor.bind 'refresh change', @render
    TimeSlot.fetch()
    VisitorFieldType.fetch()
    Host.fetch()
    Visitor.fetch({id: app.role_id})

  render: =>
    @html @view('visitors/dashboard')()
    afterRender()
    hideSpinner()

  edit_profile: () ->
    @navigate '/edit_profile'

  edit_availabilities: () ->
    @navigate '/edit_availabilities'

class App.VisitorDashboard extends Spine.Stack
  controllers:
    index: Index
    edit_profile: EditProfile
    edit_availabilities: EditAvailabilities

  routes:
    '/edit_profile': 'edit_profile'
    '/edit_availabilities': 'edit_availabilities'
    '/': 'index'
    
  default: 'index'
  className: 'stack visitor_dashboard'
