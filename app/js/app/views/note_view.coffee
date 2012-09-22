class App.Views.NoteView extends Backbone.View
	className: "note"
	events: ->
		{
			'blur input': 'save_note'
		}
	initialize: ->
		@authorities = @options.authorities
		@template = _.template($('#note').html())
		_.bindAll @, 'render', 'save_note'

	save_note: ->
		@model.set {
			'authorities':_.compact( App.Views.NoteView.split($(@el).find('.authorities').data('authorities'))),
			'text':$(@el).find('.text').val()
		}
		@model.save()

	render: ->
		$(@el).html @template(@model.toJSON())
		if ($(".content_container").length > 0)
			offset = $(".content_container .p_"+@model.get('start_paragraph')).offset()
			top = offset.top - $(".content_container").offset().top
			$(@el).css({'top': top+'px'})

		self = @
		$(@el).find(".authorities").bind("keydown", (event) ->
			event.preventDefault()  if event.keyCode is $.ui.keyCode.TAB and $(this).data("autocomplete").menu.active
		).autocomplete({
		  minLength: 0
		  source: (request, response) ->
		    # delegate back to autocomplete, but extract the last term
		    response $.ui.autocomplete.filter(self.authorities.all_authorities(), App.Views.NoteView.extractLast(request.term))
			focus: ->
				# prevent value inserted on focus
				false

			select: (event, ui) ->
				terms = App.Views.NoteView.split(@value)
				terms.pop()
				terms.push ui.item.label
				terms.push ""

				authorities = App.Views.NoteView.split($(self.el).find(".authorities").data('authorities'))
				authorities.pop()
				authorities.push ui.item.value
				authorities.push ""				
				@value = terms.join(", ")
				$(self.el).find(".authorities").data('authorities',authorities.join(", "))
				false
			})
		@

	@split:(val) ->
		if (val == undefined)
			return [""]
		return val.split( /,\s*/ )
		
	@extractLast: (term) ->
		return App.Views.NoteView.split(term).pop()
