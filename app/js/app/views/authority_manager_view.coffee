class App.Views.AuthorityManagerView extends Backbone.View
	className: "authority_manager"
	events: ->
		{
			'click .btn_add_node' : 'add_node'
			'click .make_child'		: 'make_child'
		}
	initialize: ->
		_.bindAll @, 'render', 'render_tree', 'add_node', 'make_child'
		@template = _.template($('#authority_manager').html())
		@treeview = new App.Views.TreeNodeView({model: @model})
		@model.bind('treechange',@render_tree)
		@

	make_child: (e) -> 
		e.preventDefault()
		self = @model.search $(e.target).parent().data('node-id')
		new_parent = @model.search $(e.target).parent().parent().prev().find('div').data('node-id')
		self.set('order',-1)
		self.parent().remove self
		new_parent.attach(self)
		

	add_node: (e) -> 
		e.preventDefault()
		self = @
		@model.children().create({
		name:$(@el).find('.add_node').val(),
		order:@model.children().length,
		ancestry: @model.get('_id')
		},{
		wait: true
		success: (r) ->
			r.set('children',new App.Collections.AuthorityList)
			r.set('parent',self.model)
			self.model.trigger('treechange')
		})

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
				self.model.remove node
				target_node_id = $(ui.item).parent().parent().find('div').first().data('node-id')
				target = self.model.search target_node_id
				target.attach node
				
				# first map the order based on the DOM:
				i = 0
				order_hash = {}
				_.each($(ui.item).parent().parent().find('div'),(el) ->
					order_hash[$(el).data('node-id')] = i++
				,@)

				# now pull out the syblings we want to save into a separate list:
				saveset = []
				target.children().each((n) -> 
					n.set('order',order_hash[n.get('_id')])
					saveset.push n.toJSON()
				,@)
				
				# sanitize any relationships:
				_.each(saveset,(n) ->
					n.parent = null
					n.children = null
				,@)

				# prepare to save:
				bs = new App.Models.AuthorityBulkSave
				bs.model = saveset
				bs.save([],{
					success: ->
						target.root_node().trigger('treechange')
				})
		})
		@

