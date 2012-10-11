describe 'App.Views.NoteView', ->
  beforeEach( ->
    @server = sinon.fakeServer.create()   
    reload_fx()
  )
  afterEach( ->
    @server.restore()
  )

  it 'should render a note', ->
    @server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
    auth = new App.Collections.AuthorityList()
    auth.fetch()
    @server.respond()

    view = new App.Views.NoteView({model: new App.Models.Note(), authorities: auth.first()})
    $("#testbed").html(view.render().el)
    expect($("#testbed .note").length).toEqual(1)
