describe 'App.Models.Authority', ->
	it 'should have a default name', ->
		a = new App.Models.Authority
		expect(a.get('name')).toEqual('untitled')

	it 'should be able to have parents', -> 
		parent = new App.Models.Authority
		parent.set('name',"mom")
		child = new App.Models.Authority
		child.set('name','kid')
		child.setParent parent
		expect(child.parent().get('name')).toEqual('mom')

	it 'should have children', -> 
		parent = new App.Models.Authority
		parent.set('name',"mom")
		
		child1 = new App.Models.Authority
		child1.set('name','brother')
		child1.setParent parent

		child2 = new App.Models.Authority
		child2.set('name','sister')
		child2.setParent parent

		expect(parent.children().length).toEqual(2)

	it 'should generate tree from JSON', -> 
		json = Fixtures.locale_tree 
		auth = App.Models.Authority.from_json(json)
		expect(auth.children().last().children().first().children().first().get('name')).toEqual('Canada')

		
