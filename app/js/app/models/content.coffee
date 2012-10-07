class App.Models.Content extends Backbone.Model
	initialize: ->

	defaults: ->
		{
			title: "untitled"
			text: ""
			version: 1
		}
	# room for optimization here:
	asParagraphs: ->
		@.paragraphize @get('text')

	getParagraph: (html) ->
		parseInt(_.last($(html).attr('class').split("_")))

	getSelectionRange: (start,end,selection) ->
		p_s = @getParagraph (start)
		p_e = @getParagraph (end)

		console.log(selection)
		[
			[p_s, selection.anchorOffset],
			[p_e, selection.focusOffset]
		]

	wordize: (str) ->
		str.split(' ')

	paragraphize: (str) ->
		str.split('\n')
