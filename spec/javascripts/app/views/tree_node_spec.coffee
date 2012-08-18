describe 'App.Views.TreeNodeView', ->
	beforeEach -> 
		reload_fx()

	it 'should render a tree', ->
		tree = App.Models.Authority.from_json Fixtures.locale_tree 
		view = new App.Views.TreeNodeView({model: tree, depth: 1})
		$("#testbed").html("<ul></ul>")
		$("#testbed ul").html(view.render().el)
		expect($("#testbed ul").length).toEqual(8)