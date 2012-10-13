class App.Views.NoteView extends Backbone.View
	className: "note"
	events: ->
		{
			'blur input': 'save_note'
			'mouseover':'mouseon'
			'mouseout':'mouseoff'
			'click a.delete': 'delete_note'
			'click a.collapsable': 'collapsable'
		}
	initialize: ->
		@authorities = @options.authorities
		@collection = @options.collection
		@.set_template()		
		_.bindAll @, 'render', 'save_note', 'delete_note','collapsable', 'mouseon', 'mouseoff', 'init_tags','set_template'

	mouseon: (e) ->
		@.trigger('mouseon',@model)

	mouseoff: (e) ->
		@.trigger('mouseoff',@model)

	init_tags: ->
		$(@el).find('input[name=authorities]').tagsInput({    
		autocomplete_url:'/authorities/as_tags'
		autocomplete:
			selectFirst:true
			width:'100px'
			autoFill:true

		onAddTag: (e,options) => 
			@model.get('authorities').push options.item.id
			@model.save()

		onRemoveTag: (e,item) =>
			@model.set('authorities',_.reject(@model.get('authorities'),(a) -> a == item.id))
			@model.save()

		})
		_.each(@model.get('authorities'), (id) =>
			a = @authorities.search(id)
			$(@el).find('input[name=authorities]').addTag(a.get('name'),{
			focus:false
			callback:false
			item:
				id:id
				label:a.get('name')
				value:a.get('name')
			})
		,@)

	set_template: ->
		if (@model.get('collapsed'))
			@template = _.template($('#note').html())
			$(@el).css('background','')
		else
			@template = _.template($('#note-collapsed').html())
			$(@el).css('background','none')


	collapsable: (e) ->
		e.preventDefault()
		@model.save({'collapsed':!@model.get('collapsed')})
		@.set_template()		
		

	save_note: ->
		@model.set {
			text: $(@el).find('.text').val()
		}
		@model.save()

	delete_note: (e)->
		e.preventDefault()
		@model.collection.remove(@model)
		@model.destroy()
		



	render: ->
		json = {
			authorities: _.map(@authorities.in(@model.get('authorities')), (a) -> a.toJSON()).join(',')
			note: @model.toJSON()
		}
		$(@el).html @template(json)
		$(@el).attr('id','note_'+@model.get('_id'))
		if ($(".content_container").length > 0)
			offset = $(".content_container .h_"+@model.get('start_paragraph')+" em").offset()
			top = offset.top - $(".content_container").offset().top + 20
			$(@el).css({'top': top+'px'})
		#@.trigger('rendered')
		@

	@split:(val) ->
		if (val == undefined)
			return [""]
		return val.split( /,\s*/ )
		
	@extractLast: (term) ->
		return App.Views.NoteView.split(term).pop()
