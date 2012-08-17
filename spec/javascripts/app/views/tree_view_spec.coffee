describe 'App.Views.TreeView', ->
	it 'should test sanity', ->
		tv = new App.Views.TreeView
		expect($(tv.render().el).html()).toEqual("hello world")

	it 'should render a tree', ->
		tree = App.Models.Authority.from_json Fixtures.locale_tree 
		tv = new App.Views.TreeView({el: "#testbed", model: tree})
		expect($(tv.render()).find("ul").length).toEqual(10)