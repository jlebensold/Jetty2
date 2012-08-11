class App.Models.Authority extends Backbone.Model
	initialize: ->

	defaults: ->
		{
			name: "untitled"
			children: new App.Collections.AuthorityList
		}
	setParent: (parent) ->
		parent.children().add(@)
		@.set('parent',parent)

	parent: ->
		@.get('parent')

	children: -> 
		@.get('children')

	@from_json: (json) ->
		@root = new App.Models.Authority({name: json.name})
		@attach_json_children_to_parent(@root, json.children)

	@attach_json_children_to_parent: (parent, children) ->
		for i,child of children
			@child = new App.Models.Authority({name: child.name})
			@child.setParent(parent)
			@attach_json_children_to_parent @child, child.children
		parent