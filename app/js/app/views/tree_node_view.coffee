class App.Views.TreeNodeView extends Backbone.View
	tagName: "li"
	events: ->
		'click .destroy' 			: 'destroy'
		'click .make_child'		: 'make_child'

	initialize: ->
		@template = _.template($('#tree_node').html())
		_.bindAll @, 'render', 'destroy', 'make_child'
		@model.children().on('remove', @render)
		@model.children().on('add', @render)
		@bulksave = new App.Models.AuthorityBulkSave()

	make_child: (e) -> 
		e.preventDefault()
		new_parent = @model.root_node().search $(e.target).parent().parent().parent().parent().prev().find('div').data('node-id')
		children = @model.children()
		@model.detach()
		
		@model.save({ancestry:new_parent.get('_id'), order: -1, children: null,parent: null}, {
			wait: true,
			success: (r) ->
				r.set('children', children)
				r.set_parent(new_parent)
		})
		false

	destroy: (e) -> 
		e.preventDefault()
		node = @model

		saveset = node.setup_children_for_persistence((n) -> 
			n.set('ancestry',node.parent().get('_id'))
			n.detach()
			node.get('parent').attach n
		)
		node.destroy()
		if (saveset.length > 0)
			@bulksave.save({ model: saveset })
		false

	render: -> 

		$(@el).html @template(@model.toJSON())

		el = @el
		d = @options.depth + 1
		children_html = $('<ul class="children"></ul>')
		@model.children().sort();
		@model.children().each ((child) -> 
			tnv = new App.Views.TreeNodeView({model: child, depth: d})			
			$(children_html).append(tnv.render().el)
		), this
		if $(children_html).find("li").length > 0
			$(@el).append(children_html)
		return @