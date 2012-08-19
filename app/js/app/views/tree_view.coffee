class App.Views.TreeView extends Backbone.View
	initialize: ->
		_.bindAll @

	render: ->
		$(@.el).html "hello world"
		return @
