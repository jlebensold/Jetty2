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

		console.log(self.get('start_paragraph'),other.get('start_paragraph'))

		if (self.get('start_paragraph') < other.get('start_paragraph'))
			[other,self] = [self, other]

		console.log(self.get('start_paragraph'),other.get('start_paragraph'))

		p1 = {x:self.get("start_paragraph"),y:self.get("start_paragraph_char")}
		p2 = {x:self.get("end_paragraph"),y:self.get("end_paragraph_char")}
		p3 = {x:other.get("start_paragraph"),y:other.get("start_paragraph_char")}
		p4 = {x:other.get("end_paragraph"),y:other.get("end_paragraph_char")}


		console.log(p1,p2,p3,p4)

		console.log('((p1.x > p3.x && p2.x > p3.x))=',(p1.x > p3.x && p2.x > p3.x && p1.x < p4.x) )

		if (p1.x == p3.x)
			(p1.y > p3.y && p2.y > p4.y) || (p1.y > p3.y && p2.y > p3.y) || (p1.y < p3.y && p2.y > p4.x)
		else
			(p1.x > p3.x && p2.x > p4.x && p1.x < p4.x) || (p1.x > p3.x && p2.x > p3.x && p1.x < p4.x) || (p1.x < p3.x && p2.x > p4.x && p1.x < p4.x)

	normalize: ->

		if (@.get('start_paragraph') > @.get('end_paragraph'))

			@.set({
				start_paragraph:@.get('end_paragraph')
				end_paragraph:@.get('start_paragraph')
				start_paragraph_char:@get('end_paragraph_char')
				end_paragraph_char:@get('start_paragraph_char')
				})

		@

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
