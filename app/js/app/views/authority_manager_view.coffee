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
		list = @model.flattened()
		$($(@el).find(".tree")).sortable({
			items: "li", 
			toleranceElement: '> div'
			update: (e,ui) -> 
				node_id = $(ui.item).find("div").data('node-id')
				#console.log @treeview.model
				m = new App.Models.Authority(list.where({id:node_id})[0].toJSON())
				#console.log list.where({id:node_id})[0].toJSON()
				m.set_parent(list.first)
				console.log list

		})

		@

