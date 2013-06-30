class App.Collections.PageList extends Backbone.Collection
  model: App.Models.Page
  pageSize: 10

  magic: (content) ->
    @content = content
    @.current_page = @.content.get('current_page')
    if @.current_page == undefined
      @.current_page = 1
    @.listenTo(@.content,'all',@.contentChanged)
    @.paginate()

  contentChanged: (e) ->
    @.current_page = @.content.get('current_page')

  set_notes: (notes) ->
    @notes = notes

  totalPages: ->
    @.models.length

  currentPage: ->
    @.at(@.current_page)

  nextPage: ->
    return if @.current_page == @.models.length - 1
    @.content.save({current_page: @.currentPage().get('page') + 1 })

  previousPage: ->
    return if @.current_page < 1
    @.content.save({current_page: @.currentPage().get('page') - 1 })

  notesAtCurrentPage: ->
    new App.Collections.NoteList(@notes.filter( (n) => 
      (n.get('start_paragraph') >= (@currentPage().get('page') - 1) * @pageSize ) && (n.get('end_paragraph') <= (@currentPage().get('page') + 1) * @pageSize )
      ))

  paginate: () ->
    paragraphs = @content.asParagraphs()
    for paragraph, i in paragraphs
      if (i % @pageSize == 0)
        @.add(new App.Models.Page({paragraphs: [], page: @.models.length + 1, id: i}))
      @.last().addParagraph(paragraph)
 
  at: (page) ->
    if page != @.content.get('current_page')
      @.content.save({current_page: page}) 
    @.models[page - 1]
