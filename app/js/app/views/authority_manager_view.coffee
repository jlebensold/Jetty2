class App.Views.AuthorityManagerView extends Backbone.View
	className: "authority_manager span4"
	events: ->

	initialize: ->
		@template = _.template($('#authority_manager').html())
		@treeview = new App.Views.TreeNodeView({model: App.Models.Authority.from_json Fixtures.locale_tree})
		_.bindAll @, 'render'

	render: ->
		$(@el).html @template()
		$(@el).find(".tree").html(@treeview.render().el)


		@

