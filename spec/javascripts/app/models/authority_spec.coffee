describe 'App.Models.Authority', ->
	
	beforeEach( ->
		@server = sinon.fakeServer.create()		
	)
	afterEach( ->
		@server.restore()
		#console.log @server
	)

	it 'should have a default name', ->
		a = new App.Models.Authority
		expect(a.get('name')).toEqual('untitled')

	it 'should be able to have parents', -> 
		parent = new App.Models.Authority
		parent.set('name',"mom")
		child = new App.Models.Authority
		child.set('name','kid')
		child.set_parent parent
		expect(child.parent().get('name')).toEqual('mom')

	it 'should have children', -> 
		parent = new App.Models.Authority
		parent.set('name',"mom")
		
		child1 = new App.Models.Authority
		child1.set('name','brother')
		child1.set_parent parent

		child2 = new App.Models.Authority
		child2.set('name','sister')
		child2.set_parent parent

		expect(parent.children().length).toEqual(2)

	it 'should be able to determine a root node', ->
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()

		expect(auth.first().is_root_node()).toBeTruthy()
		expect(auth.first().children().last().children().first().is_root_node()).toBeFalsy()

	it 'should be able to navigate to root node', ->
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()

		expect(auth.first().children().last().children().first().root_node().id).toEqual(auth.first().id)

	it 'should be able to search for a node within the children of a tree', ->
		
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()

		canada = auth.first().children().last().children().first().children().first()
		expect(auth.first().search(canada.get('_id'))).toEqual(canada)

	it 'should be able to remove a node and its children from the tree', ->
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()
		auth = auth.first()
		canada = auth.children().last().children().first().children().first()
		expect(auth.children().last().children().first().children().length).toEqual(1)
		auth.remove canada		
		expect(auth.children().last().children().first().children().length).toEqual(0)
	
	it 'should be able to move stuff around the tree', ->
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()
		auth = auth.first()

		expect(auth.children().last().children().length).toEqual(5)
		
		canada = auth.children().last().children().first().children().first()
		auth.remove canada
		auth.children().last().attach canada

		expect(auth.children().last().children().length).toEqual(6)

