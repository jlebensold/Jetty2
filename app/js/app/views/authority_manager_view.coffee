class App.Views.AuthorityManagerView extends Backbone.View
	className: "authority_manager span4"
	events: ->
		#TODO: on change of a node, redraw it
	initialize: ->
		@template = _.template($('#authority_manager').html())
		@treeview = new App.Views.TreeNodeView({model: @model})
		_.bindAll @, 'render'

	render: ->
		$(@el).html @template()
		$(@el).find(".tree").html(@treeview.render().el)
		tree = @model
		$($(@el).find(".tree")).sortable({
			items: "li", 
			toleranceElement: '> div'
			update: (e,ui) -> 
				node_id = $(ui.item).find("div").data('node-id')
				node = tree.search node_id
				tree.remove node
				target_node_id = $(ui.item).parent().parent().find('div').first().data('node-id')
				target = tree.search target_node_id
				target.attach node
		})

		@

