class App.Views.AuthorityManagerView extends Backbone.View
	className: "authority_manager"
	events: ->
		{
			'click .btn_add_node' : 'add_node'
		}
	initialize: ->
		_.bindAll @, 'render', 'render_tree', 'add_node'
		@template = _.template($('#authority_manager').html())
		@treeview = new App.Views.TreeNodeView({model: @model})
		@model.bind('treechange',@render_tree)

		@

	add_node: (e) -> 
		e.preventDefault()
		new_node = App.Models.Authority.from_json({name:$(@el).find('.add_node').val(),children:[]});
		@model.attach new_node
		@render()

	render_tree: ->
		@treeview = new App.Views.TreeNodeView({model: @model})
		$(@el).find(".tree").html(@treeview.render().el)
		
	render: ->
		$(@el).html @template()
		$(@el).find(".tree").html(@treeview.render().el)
		$(@el).draggable();
		self = @
		$($(@el).find(".tree")).sortable({
			items: "li", 
			toleranceElement: '> div'
			update: (e,ui) -> 
				node_id = $(ui.item).find("div").data('node-id')
				node = self.model.search node_id
				self.model.remove node
				target_node_id = $(ui.item).parent().parent().find('div').first().data('node-id')
				target = self.model.search target_node_id
				target.attach node
		})
		@

