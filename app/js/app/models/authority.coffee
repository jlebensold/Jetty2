class App.Models.Authority extends Backbone.Model
	url: ->
		if  @.get('id')
			'/authority/' + @.get('id')
		else
			'/authorities'

	initialize: ->

	defaults: ->
		{
			parent: null
			name: "untitled"
			children: new App.Collections.AuthorityList
		}
	set_parent: (parent) ->
		parent.children().add(@)
		@.set('parent',parent)

	parent: ->
		@.get('parent')

	children: -> 
		@.get('children')

	is_root_node: ->
		@.parent() == null

	root_node: ->
		node = @
		while node.is_root_node() is false
			break  unless node.parent()?
			node = node.parent()
		node

	remove: (node) ->
		n = node.root_node()
		n.search(node.id).detach()

	search: (node_id) ->
		pointer = @
		found = null
		found = pointer if pointer.id == node_id
		pointer.children().each( (child) ->
			child_found = child.search(node_id)
			if (child_found != null)
				found = child_found
		)
		found

	attach: (node) ->
		node.set_parent @		
		@.root_node().trigger('treechange')

	detach: ->
		self = @
		p = @.parent()
		p.set('children',new App.Collections.AuthorityList(p.children().reject((a) -> a.id == self.id)))
		@.set('parent',null)
		@

	flattened: ->
		list = new App.Collections.AuthorityList()
		@add_to_list list, @children()

	add_to_list: (list,children) ->
		list.add children.toJSON()
		node = @
		children.each( (child) ->
			node.add_to_list list, child.children()
		)
		list

	@from_json: (json) ->
		@root_list = new App.Collections.AuthorityList()
		result = @root_list.create({name: json.name})
		root = new App.Models.Authority(result.toJSON())
		@attach_json_children_to_parent(root, json.children)

	@attach_json_children_to_parent: (parent, children) ->
		for i,child of children
			child_list = new App.Collections.AuthorityList()
			@result = child_list.create({name:child.name})
			@child = new App.Models.Authority(@result.toJSON())
			@child.set_parent(parent)
			@attach_json_children_to_parent @child, child.children
		parent