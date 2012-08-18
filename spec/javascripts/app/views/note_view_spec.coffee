describe 'App.Views.NoteView', ->
	it 'should render a note', ->
		#tree = App.Models.Authority.from_json Fixtures.locale_tree 
		#view = new App.Views.TreeNodeView({model: tree, depth: 1})
		note = new App.Models.Note()
		view = new App.Views.NoteView({model: note})
		$("#testbed").html(view.render().el)
		expect($("#testbed .note").length).toEqual(1)