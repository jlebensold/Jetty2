describe 'App.Views.TreeNodeView', ->
	beforeEach -> 
		$("#testbed").remove()
		$("body").append '<div id="testbed">testbed</div>'

	it 'should render a tree', ->
		tree = App.Models.Authority.from_json Fixtures.locale_tree 
		console.log tree
		view = new App.Views.TreeNodeView({el: "#testbed",model: tree})
		view.render()
		#expect($(tv.render()).find("ul").length).toEqual(10)