describe 'App.Models.Authority', ->
	
	beforeEach( ->
		
	)
	afterEach( ->
		#@server.restore()
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

	it 'should generate tree from JSON', -> 
		json = Fixtures.locale_tree 
		auth = App.Models.Authority.from_json(json)
		expect(auth.children().last().children().first().children().first().get('name')).toEqual('Canada')

	it 'should be able to determine a root node', ->
		auth = App.Models.Authority.from_json(Fixtures.locale_tree )
		expect(auth.is_root_node()).toBeTruthy()
		expect(auth.children().last().children().first().is_root_node()).toBeFalsy()

	it 'should be able to navigate to root node', ->
		auth = App.Models.Authority.from_json(Fixtures.locale_tree )
		expect(auth.children().last().children().first().root_node().id).toEqual(auth.id)

	it 'should be able to search for a node within the children of a tree', ->
		@server = sinon.fakeServer.create()
		@server.respondWith("/authorities",serverResponse({_id:"5076cbde65d0c6c248000003",name: "boop"}))
		#auth = App.Models.Authority.from_json(Fixtures.locale_tree)
		
		#canada = auth.children().last().children().first().children().first()
		window.list = new App.Collections.AuthorityList()
		a = list.create({name:"foooo"},{wait:true})
		setTimeout(-> 
			console.log a
		,1000)
		#canada = new App.Models.Authority({name: "aaaa"})
		#canada.save()
		#console.log canada
		#expect(auth.search(canada.get('_id')).toEqual(canada)

	it 'should be able to remove a node and its children from the tree', ->
		json = Fixtures.locale_tree 
		auth = App.Models.Authority.from_json(json)
		canada = auth.children().last().children().first().children().first()
		expect(auth.children().last().children().first().children().length).toEqual(1)
		auth.remove canada		
		expect(auth.children().last().children().first().children().length).toEqual(0)
	
	it 'should be able to move stuff around the tree', ->
		json = Fixtures.locale_tree 
		auth = App.Models.Authority.from_json(json)
		expect(auth.children().last().children().length).toEqual(7)
		
		canada = auth.children().last().children().first().children().first()
		auth.remove canada
		auth.children().last().attach canada

		expect(auth.children().last().children().length).toEqual(8)

`

window.serverResponse = function(data) {
  console.log(JSON.stringify( data));
  return [200, { "Content-Type": "application/json" },JSON.stringify(data)];
}

window.guid = function() {
        var S4 = function() {
           return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
        };
        return (S4()+S4()+S4()+S4()+S4());
      }
`