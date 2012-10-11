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