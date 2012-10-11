class App.Views.AuthorityManagerView extends Backbone.View
	className: "authority_manager"
	events: ->
		{
			'click .btn_add_node' : 'add_node'
			'click .make_child'		: 'make_child'
			'click .destroy'			: 'destroy'
		}
	initialize: ->
		_.bindAll @, 'render', 'render_tree', 'add_node', 'make_child', 'destroy'
		@template = _.template($('#authority_manager').html())
		@treeview = new App.Views.TreeNodeView({model: @model})
		@model.bind('treechange',@render_tree)
		@bulksave = new App.Models.AuthorityBulkSave()
		#@bulksave.bind('change',(r) -> 
		#	console.log r
		#)
		@

	destroy: (e) -> 
		e.preventDefault()
		view = @
		self = @model.search $(e.target).parent().data('node-id')
		saveset = self.setup_children_for_persistence((n) -> 
			n.set('ancestry',self.parent().get('_id'))
		)
		
		self.destroy()
		@bulksave.save({model: saveset})

		
	make_child: (e) -> 
		e.preventDefault()
		self = @model.search $(e.target).parent().data('node-id')
		new_parent = @model.search $(e.target).parent().parent().prev().find('div').data('node-id')
		view = @
		
		self.save({ancestry:new_parent.get('_id'), order: -1, children: null,parent: null}, {
			wait: true,
			success: (r) ->
				c = new App.Collections.AuthorityList 
				if self.get('children') != undefined
					c = self.get('children')
				r.set('children',c)
				r.set('parent',new_parent)
		})
		

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
				target_node_id = $(ui.item).parent().parent().find('div').first().data('node-id')
				target = self.model.search target_node_id

				node_json = node.toJSON()
				node_json.parent = node_json.children = null
				node_json.ancestry = target.get('_id')
			
				# first map the order based on the DOM:
				i = 0
				order_hash = {}
				_.each($(ui.item).parent().parent().find('div'),(el) ->
					order_hash[$(el).data('node-id')] = i++
				,@)
				saveset = target.setup_children_for_persistence((n) -> 
					n.set('order',order_hash[n.get('_id')])
					)
				saveset.push node_json
		
				self.bulksave.save({model:saveset})
		})
		$(@el).find('.tree').css('height',($(window).height() - 300) + 'px')
		@

