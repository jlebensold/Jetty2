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

	contains: (other) ->

		self = @

		if (self.get('start_paragraph') < other.get('start_paragraph'))
			[other,self] = [self, other]

		if (self.get('start_paragraph') == other.get('start_paragraph'))
			!(other.get("end_paragraph_char") < self.get("start_paragraph_char") || other.get("start_paragraph_char") > self.get("end_paragraph_char"))
		else
			!(other.get("end_paragraph") < self.get("start_paragraph") || other.get("start_paragraph") > self.get("end_paragraph"))

	normalize: ->

		if (@.get('start_paragraph') > @.get('end_paragraph'))

			@.set({
				start_paragraph:@.get('end_paragraph')
				end_paragraph:@.get('start_paragraph')
				start_paragraph_char:@get('end_paragraph_char')
				end_paragraph_char:@get('start_paragraph_char')
				})

		@

	size: ->
		@.normalize();

		p = (@.get('end_paragraph') - @.get('start_paragraph'))
		if (p > 0)
			c = @.get('end_paragraph_char') + @.get('start_paragraph_char')
		else
			c = @.get('end_paragraph_char') - (@.get('start_paragraph_char'))

		"#{p}:#{c}"

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
		}).normalize()
