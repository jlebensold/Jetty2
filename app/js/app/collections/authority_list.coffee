class App.Collections.AuthorityList extends Backbone.Collection
  url: "/authorities"
  model: App.Models.Authority

  comparator: (item) ->
    item.get('order')


  parse: (flat_tree,xhr) -> 
    _.each flat_tree, (n) ->
      n.added = false
      n.children = new App.Collections.AuthorityList

    _.each flat_tree, ((n) ->
      if n.ancestry?
        n.added = true
        found = _.select(flat_tree, (parent) ->
          parent._id is n.ancestry
        , this)[0]
        if (found)
          n.parent = new App.Models.Authority(found)
          found.children.push n
    ), this
    root = _.select(flat_tree, (t) ->
      t.added is false
    )[0]
    new App.Models.Authority(root)