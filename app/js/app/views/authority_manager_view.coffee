class App.Views.AuthorityManagerView extends Backbone.View
	className: "authority_manager span4"
	events: ->

	initialize: ->
		_.bindAll @, 'render', 'render_tree'
		@template = _.template($('#authority_manager').html())
		@treeview = new App.Views.TreeNodeView({model: @model})
		@model.bind('treechange',@render_tree)
		
		@

	render_tree: ->
		@treeview = new App.Views.TreeNodeView({model: @model})
		$(@el).find(".tree").html(@treeview.render().el)
		
	render: ->
		$(@el).html @template()
		$(@el).find(".tree").html(@treeview.render().el)
		self = @
		$($(@el).find(".tree")).sortable({
			items: "li", 
			toleranceElement: '> div'
			update: (e,ui) -> 
				node_id = $(ui.item).find("div").data('node-id')
				node = self.model.search node_id
				console.log node
				self.model.remove node
				target_node_id = $(ui.item).parent().parent().find('div').first().data('node-id')
				target = self.model.search target_node_id
				target.attach node
		})
		@

