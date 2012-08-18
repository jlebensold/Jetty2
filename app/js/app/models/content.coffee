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
		txt_paragraphs = @asParagraphs()
		slct_paragraphs = @.paragraphize selection

		#same paragraph selection
		if (p_s == p_e)
			[
				[ 
					p_s,
					txt_paragraphs[p_s].indexOf(_.first slct_paragraphs),
					_.first(slct_paragraphs).length
				],
				[ 
					p_s,
					txt_paragraphs[p_s].indexOf(_.first slct_paragraphs),
					_.first(slct_paragraphs).length
				]
			]
		else
			[
				[
					p_s,
					txt_paragraphs[p_s].indexOf(_.first slct_paragraphs),
					_.first(slct_paragraphs).length
				],
				[
					p_e,
					0,
					_.last(@.paragraphize selection).length
				]
			]

	contentSelectionRange: (start,end,selection) ->
		range = @getSelectionRange(start, end, selection)
		txt_paragraphs = @asParagraphs()
		
		start_count = end_count = 0

		for i in [0..(range[0][0])]
			start_count = start_count + txt_paragraphs[i].length

		for i in [0..(range[1][0])]
			end_count = end_count + txt_paragraphs[i].length


		#this works... sort of
		start_count = start_count - range[0][1] - range[0][0] + 1
		end_count = selection.length + range[1][0] - range[0][0]*2 + 2

		[start_count,start_count + end_count]

	wordize: (str) ->
		str.split(' ')

	paragraphize: (str) ->
		str.split('\n')