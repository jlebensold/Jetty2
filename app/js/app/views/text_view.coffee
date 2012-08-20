class App.Views.TextView extends Backbone.View
	events: ->
		"mouseup p": "getSelection"

	initialize: ->
		@template = _.template($('#content').html())
		_.bindAll @, 'render', 'getSelection', 'addHighlight','addSingleParagraphHighlight','addMultiParagraphHighlight'
		@notes = new App.Collections.NoteList()

	getSelection: (e) ->
		e.preventDefault()
		note = App.Models.Note.fromContent(@model,window.getSelection())
		@addHighlight(note)

	addHighlight: (note) ->
		return unless @notes.addUnique(note)

		if (note.get('start_paragraph') == note.get('end_paragraph'))
			@addSingleParagraphHighlight note
		else
			@addMultiParagraphHighlight note

		note_view = new App.Views.NoteView({model: note})
		$(@el).find(".notes_container").append(note_view.render().el)


	addMultiParagraphHighlight: (note) ->
		for i in [note.get('start_paragraph')..note.get('end_paragraph')]
			h = $("<div class=\"h_#{i}\">#{$(@el).find(".p_#{i}").text()}</div>")
			$(@el).find("div[data-set-id=#{i}]").prepend(h)

			if (i == note.get('start_paragraph'))
				highlighted_part = h.text().substr(note.get('start_paragraph_char'))
				normal_part = h.text().substr(0,note.get('start_paragraph_char'))
				h.html("#{normal_part}<em>#{highlighted_part}</em>")
			else if (i == note.get('end_paragraph'))
				highlighted_part = h.text().substr(0,note.get('end_paragraph_char'))
				normal_part = h.text().substr(0,note.get('end_paragraph_char'))
				h.html("<em>#{highlighted_part}</em>#{normal_part}")
			else
				h.html("<em>#{h.text()}</em>")

	addSingleParagraphHighlight: (note) ->
		p = note.get('start_paragraph')
		h = $("<div class=\"h_#{p}\">#{$(@el).find(".p_#{p}").text()}</div>")
		$(@el).find("div[data-set-id=#{p}]").prepend(h)
		highlighted_part = h.text().substr(note.get('start_paragraph_char'),note.get('end_paragraph_char'))
		first_normal_part = h.text().substr(0,note.get('start_paragraph_char'))
		second_normal_part = h.text().substr(note.get('end_paragraph_char'))
		h.html("#{first_normal_part}<em>#{highlighted_part}</em>#{second_normal_part}")

	render: ->
		$(@el).html @template(@model.toJSON())
		o = ""
		i = 0
		_.each @model.asParagraphs(), ((p) ->
			o += "<div class=\"set\" data-set-id=\"#{i}\">
					<p class=\"p_#{i}\">#{p}</p>
				  </div>"

			i = i + 1
		), this
		$(@el).find(".content_container").html(o)
		return @
