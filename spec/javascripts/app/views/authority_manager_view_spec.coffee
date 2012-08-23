describe 'App.Views.AuthorityManagerView', ->
	it 'should render a box with a treeview, filter box and form control', ->
		am = new App.Views.AuthorityManagerView()
		$("#testbed").html(am.render().el)
		

		
