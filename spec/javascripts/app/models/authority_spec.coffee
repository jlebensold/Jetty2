describe 'App.Models.Authority', ->
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


	it 'should be able to remove a node and its children from the tree', ->
		json = Fixtures.locale_tree 
		auth = App.Models.Authority.from_json(json)
		canada = auth.children().last().children().first().children().first()
		auth.remove canada		
###
	it 'should be able to move stuff around the tree', ->
		json = Fixtures.locale_tree 
		auth = App.Models.Authority.from_json(json)
		canada = auth.children().last().children().first().children().first()
		canada.set_parent auth
		console.log auth.children()
		console.log _.map(auth.children().models,(c) -> c.toJSON() )
		console.log auth.children()
		

###