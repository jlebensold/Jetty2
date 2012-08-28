describe 'App.Views.AuthorityManagerView', ->
	it 'should render a box with a treeview, filter box and form control', ->
		am = new App.Views.AuthorityManagerView({model: App.Models.Authority.from_json(Fixtures.locale_tree)})
		$("#testbed").html(am.render().el)

	it 'should update the authority when a drag-drop is completed', ->
		am = new App.Views.AuthorityManagerView({model: App.Models.Authority.from_json(Fixtures.locale_tree)})
		$("#testbed").html(am.render().el)
		
		

		
