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
		console.log(note_view.render().el)
		$(@el).find(".notes_container").append(note_view.render().el)


	addMultiParagraphHighlight: (note) ->
		for i in [note.get('start_paragraph')..note.get('end_paragraph')]
			h = $(@el).find(".h_#{i}")
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
		h = $(@el).find(".h_#{note.get('start_paragraph')}")
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
					<div class=\"h_#{i}\">#{p}</div>
					<p class=\"p_#{i}\">#{p}</p>
				  </div>"

			i = i + 1
		), this
		$(@el).find(".content_container").html(o)
		return @
