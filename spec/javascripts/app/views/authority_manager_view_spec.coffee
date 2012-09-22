describe 'App.Views.AuthorityManagerView', ->
	it 'should render a box with a treeview, filter box and form control', ->
		am = new App.Views.AuthorityManagerView({model: App.Models.Authority.from_json(Fixtures.locale_tree)})
		$("#testbed").html(am.render().el)
		expect($("#testbed .authority_manager").length).toBe(1)

	it 'should update the authority when a drag-drop is completed', ->
		am = new App.Views.AuthorityManagerView({model: App.Models.Authority.from_json(Fixtures.locale_tree)})
		$("#testbed").html(am.render().el)
		node_id = $("#testbed em:contains('Montreal')").parent('div').data('node-id')
		target_node_id = $("#testbed em:contains('Ontario')").parent('div').data('node-id')
		node = am.model.search(node_id)
		am.model.remove node
		treetarget = am.model.search target_node_id
		treetarget.attach node
		expect($($($("#testbed em:contains('Montreal')").parents('li')[1]).find('em')[0]).text()).toBe('Ontario')
		
		

		
