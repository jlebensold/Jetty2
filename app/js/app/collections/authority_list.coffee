class App.Collections.AuthorityList extends Backbone.Collection
  localStorage: new Backbone.LocalStorage("authorities")
  url: "/authorities"
  model: App.Models.Authority
