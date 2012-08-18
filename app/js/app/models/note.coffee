class App.Models.Note extends Backbone.Model
	initialize: ->

	defaults: ->
		{
			content: {}
			content_version: 1
			start_paragraph:0
			end_paragraph:0 
			start_paragraph_char: 0
			end_paragraph_char: 0
			raw_range: []
			authorities: []
			text: "very interesting!"
		}
	@fromContent: (content,selection) ->

		s = selection
		range = content.getSelectionRange($(s.baseNode.parentNode), $(s.focusNode.parentNode), s.toString())
		new App.Models.Note({
			content: content,
			start_paragraph: range[0][0]
			end_paragraph: range[1][0]
			start_paragraph_char: range[0][1]
			end_paragraph_char: range[1][2]
			raw_range: range
			})
