class App.Views.NoteView extends Backbone.View
	className: "note"
	events: ->

	initialize: ->
		@template = _.template($('#note').html())
		_.bindAll @, 'render'

	render: -> 
		$(@el).html @template(@model.toJSON())
		offset = $(".content_container .p_"+@model.get('start_paragraph')).offset()
		top = offset.top - $(".content_container").offset().top
		$(@el).css({'top': top+'px'})
		@
		