class App.Views.TreeNodeView extends Backbone.View
	initialize: ->
		_.bindAll @

	render: -> 
		
		$(@.el).html "hello world"
		return @
