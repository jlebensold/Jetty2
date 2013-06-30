class App.Views.TextView extends Backbone.View
  events: ->
    "mouseup p"               : "getSelection",
    "click .next"             : "nextPage",
    "click .previous"         : "previousPage"
    "change .current_page"   : "setPage"

  initialize: ->
    @template = _.template($('#content').html())
    @authorities = @options.authorities

    @$el.swipe({
      swipeRight: (e) =>
        @pagelist.current_page++
        @.render()
      swipeLeft: (e) =>
        @pagelist.current_page--
        @.render()
      })
    current_page = 1
    current_page ?= @options.current_page
    @pagelist = App.Collections.PageList.paginate @model
    @pagelist.current_page = current_page

    _.bindAll @, 'render', 'renderNote','renderNotes', 'getSelection', 'addHighlight','addSingleParagraphHighlight','addMultiParagraphHighlight', 'nextPage','previousPage', 'setPage'

    @notes = new App.Collections.NoteList()
    @notes.content_id = @model.get('_id')
    @pagelist.set_notes @notes

    @notes.bind('reset',@.render)
    @notes.bind('add',@.addHighlight)
    @notes.bind('remove',@.renderNotes)
    @notes.bind('change:collapsed',@.renderNotes)
    

  setPage: (e) ->
    @pagelist.current_page = $(@el).find('.current_page').val()
    @.render()

  nextPage: (e) ->
    e.preventDefault()
    @pagelist.current_page++
    @.render()

  previousPage: (e) ->
    e.preventDefault()
    @pagelist.current_page--
    @.render()

  getSelection: (e) ->
    e.preventDefault()
    @notes.fromContent(@model,window.getSelection())

  renderNotes: ->
    $(@el).find('.highlighting').remove()
    $(@el).find('.note').remove()
    

    @pagelist.notesAtCurrentPage().each ((n) => 
      @.renderNote n
    )


  addHighlight: (note) ->
    return if (note.size() == "0:0")
    @.renderNote note
    

  renderNote: (note) ->
    if (note.get('start_paragraph') == note.get('end_paragraph'))
      @addSingleParagraphHighlight note
    else
      @addMultiParagraphHighlight note

    note_view = new App.Views.NoteView({model: note,collection: note.collection, authorities: @authorities})
    note_view.bind('mouseon',(n) -> 
      $("em[data-note-id=#{n.get('_id')}]").css('background','lime')
    ,@)
    note_view.bind('mouseoff',(n) -> 
      $("em[data-note-id=#{n.get('_id')}]").css('background','yellow')
    ,@)
    $(@el).find(".notes_container").append(note_view.render().el)
    note_view.init_tags()


  addMultiParagraphHighlight: (note) ->
    for i in [note.get('start_paragraph')..note.get('end_paragraph')]
      h = $("<div class=\"highlighting h_#{i}\">#{$(@el).find(".p_#{i}").text()}</div>")
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
    h = $("<div class=\"highlighting h_#{p}\">#{$(@el).find(".p_#{p}").text()}</div>")
    $(@el).find("div[data-set-id=#{p}]").prepend(h)
    highlighted_part = h.text().substr(note.get('start_paragraph_char'), note.get('end_paragraph_char') - note.get('start_paragraph_char'))
    first_normal_part = h.text().substr(0, note.get('start_paragraph_char'))
    second_normal_part = h.text().substr(note.get('end_paragraph_char'))
    h.html("#{first_normal_part}<em data-note-id=\"#{note.get('_id')}\" >#{highlighted_part}</em>#{second_normal_part}")

  render: ->
    $(@el).find(".notes_container").empty()
    $(@el).html @template({
      total_pages: @pagelist.totalPages(), 
      current_page: @pagelist.current_page
    })
    o = ""
    
    i = @pagelist.pageSize * (@pagelist.current_page - 1 )
    _.each @pagelist.currentPage().get('paragraphs'), ((p) ->
      o += "<div class=\"set\" data-set-id=\"#{i}\">
          <p id=\"a_#{i}\" class=\"p_#{i}\">#{p}</p>
          </div>"
      i = i + 1
    ), this
    $(@el).find(".content_container").html(o)
    @.renderNotes()
    @
