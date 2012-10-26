describe 'App.Views.TreeNodeView', ->
  
	 beforeEach( ->
    @server = sinon.fakeServer.create()   
    reload_fx()
  )
  afterEach( ->
    @server.restore()
  )

	it 'should render a tree', ->
    @server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
    @server.respondWith("GET","/contents",serverResponse(Fixtures.contents))

    auth = new App.Collections.AuthorityList()
    auth.fetch()
    @server.respond()
		view = new App.Views.TreeNodeView({collection: auth})
		$("#testbed").html("<ul></ul>")
		$("#testbed ul").html(view.render().el)
		expect($("#testbed ul").length).toEqual(8)