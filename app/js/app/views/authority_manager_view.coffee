class App.Views.AuthorityManagerView extends Backbone.View
	className: "authority_manager"
	events: ->
			'click .btn_add_node' : 'add_node'
	initialize: ->
		_.bindAll @, 'render', 'add_node'
		@template = _.template($('#authority_manager').html())
		@treeview = new App.Views.TreeNodeView({model: @collection.first() })
		@model = @collection.first()
		@bulksave = new App.Models.AuthorityBulkSave()
		@

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
			r.set('parent',self.model)
		})
		
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

