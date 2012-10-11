class App.Models.Authority extends Backbone.Model
	idAttribute: "_id"

	url: ->
		if  @.get('_id')
			'/authority/' + @.get('_id')
		else
			'/authorities'

	setup_children_for_persistence: (callback) ->
		@.children().map( (n) ->
			callback(n) if callback != undefined
			n = n.toJSON()
			n.parent = n.children = null
			n
		)

	parse: (params,xhr) -> 
		params.children = new App.Collections.AuthorityList()
		params

	defaults: ->
		{
			parent: null
			name: "untitled"
			children: new App.Collections.AuthorityList
			order: 0
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
		n.search(node.get('_id')).detach()

	search: (node_id) ->
		pointer = @
		found = null
		found = pointer if pointer.get('_id') == node_id
		pointer.children().each( (child) ->
			child_found = child.search(node_id)
			if (child_found != null)
				found = child_found
		)
		found

	attach: (node) ->
		node.set_parent @		
		#@.root_node().trigger('treechange')

	detach: ->
		@.parent().children().remove @
		@.set('parent',null)
		@

	flattened: ->
		list = new App.Collections.AuthorityList()
		@add_to_list list, @children()

	all_authorities: ->
		@flattened().models.map((a) -> 
			{label:a.get('name'),value:a.get('_id')}
		)
	add_to_list: (list,children) ->
		list.add children.toJSON()
		node = @
		children.each( (child) ->
			node.add_to_list list, child.children()
		)
		list

	@from_json: (json) ->
		root_list = new App.Collections.AuthorityList()
		result = root_list.create({name: json.name})
		#root = new App.Models.Authority(result.toJSON())
		@attach_json_children_to_parent(result, json.children)

	@attach_json_children_to_parent: (parent, children) ->
		for i,child of children
			child_list = new App.Collections.AuthorityList()
			@result = child_list.create({name:child.name, order: i})
			@child = new App.Models.Authority(@result.toJSON())
			@child.set_parent(parent)
			@attach_json_children_to_parent @child, child.children
		parent


class App.Models.AuthorityBulkSave extends Backbone.Model
	url: '/authority/bulksave'
	toJSON: ->
    this.attributes.model
