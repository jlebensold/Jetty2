class App.Views.TreeNodeView extends Backbone.View
	tagName: "li"
	initialize: ->
		@template = _.template($('#tree_node').html())
		_.bindAll @, 'render'

	render: -> 
		$(@el).html @template(@model.toJSON())

		el = @el
		d = @options.depth + 1
		children_html = $('<ul class="children"></ul>')
		@model.children().each ((child) -> 
			tnv = new App.Views.TreeNodeView({model: child, depth: d})			
			$(children_html).append(tnv.render().el)
		), this
		if $(children_html).find("li").length > 0
			$(@el).append(children_html)
		return @