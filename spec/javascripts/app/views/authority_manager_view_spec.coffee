describe 'App.Views.AuthorityManagerView', ->
	beforeEach( ->
		@server = sinon.fakeServer.create()		
	)
	afterEach( ->
		@server.restore()
		#console.log @server
	)

	it 'should render a box with a treeview, filter box and form control', ->

		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()

		am = new App.Views.AuthorityManagerView({collection:auth})
		$("#testbed").html(am.render().el)
		expect($("#testbed .authority_manager").length).toBe(1)

	it 'should update the authority when a drag-drop is completed', ->
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()

		am = new App.Views.AuthorityManagerView({collection:auth})

		$("#testbed").html(am.render().el)
		node_id = $("#testbed em:contains('Montreal')").parent('div').data('node-id')
		target_node_id = $("#testbed em:contains('Ontario')").parent('div').data('node-id')
		node = am.model.search(node_id)
		am.model.remove node
		treetarget = am.model.search target_node_id
		treetarget.attach node
		expect($($($("#testbed em:contains('Montreal')").parents('li')[1]).find('em')[0]).text()).toBe('Ontario')
		

	it 'should allow adding of tree nodes', -> 
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()

		@server.respondWith("POST","/authorities",serverResponse(Fixtures.new_node))

		am = new App.Views.AuthorityManagerView({collection:auth})

		$("#testbed").html(am.render().el)
		$("#testbed .add_node").val("Test")
		$("#testbed .btn_add_node").click()
		@server.respond()

		expect(am.model.children().length).toBe 5
		

		
