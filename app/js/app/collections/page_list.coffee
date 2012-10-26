class App.Collections.PageList extends Backbone.Collection
  model: App.Models.Page
  @pageSize: 30

  initialize: ->
    @.pageSize = App.Collections.PageList.pageSize
    @.current_page = 1

  set_notes: (notes) ->
    @notes = notes

  totalPages: ->
    @.models.length

  currentPage: ->
    @.at(@.current_page)

  notesAtCurrentPage: ->
    new App.Collections.NoteList(@notes.filter( (n) => 
      (n.get('start_paragraph') >= (@current_page - 1) * @pageSize ) && (n.get('end_paragraph') <= (@current_page + 1) * @pageSize )
      ))

  @paginate: (content) ->
    pl = new App.Collections.PageList()
    paragraphs = content.asParagraphs()
    for paragraph, i in paragraphs
      if (i % @pageSize == 0)
        pl.add({paragraphs: []})
      pl.last().addParagraph(paragraph)
    pl

  at: (page) ->
    @.models[page - 1]


