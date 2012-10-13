class App.Views.TreeNodeView extends Backbone.View
	tagName: "li"
	events: ->
		'click .destroy' : 'destroy'
	initialize: ->
		@template = _.template($('#tree_node').html())
		_.bindAll @, 'render', 'destroy'
		@model.children().on('remove', @render)
		@model.children().on('add', @render)
		@bulksave = new App.Models.AuthorityBulkSave()

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