class App.Collections.AuthorityList extends Backbone.Collection
  #localStorage: new Backbone.LocalStorage("authorities")
  url: "/authorities"
  model: App.Models.Authority
  parse: (resp,xhr) ->
    _.each(resp,(a) ->
      a.children = new App.Collections.AuthorityList
    ,@)
    resp

  comparator: (item) ->
    item.get('order')

  special_fetch: ->
    @.fetch({success: (r) ->
      flat_tree = r.toJSON()
      _.each flat_tree, (n) ->
        n.added = false

      _.each flat_tree, ((n) ->
        if n.ancestry?
          n.added = true
          found = _.select(flat_tree, (parent) ->
            parent._id is n.ancestry
          , this)[0]
          n.parent = new App.Models.Authority(found)
          found.children.push n
      ), this
      root = _.select(flat_tree, (t) ->
        t.added is false
      )[0]
      console.log root
    })