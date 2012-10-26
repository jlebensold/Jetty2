describe 'App.Collections.PageList', ->
  beforeEach ->

  it 'should break up pages into paragraphs per page by default', ->
    content = new App.Models.Content({model: Fixtures.content})
    content.set('text',window.Fixtures.text_text)
    pagelist = App.Collections.PageList.paginate content
    expect(pagelist.length).toBe(8)
    expect(pagelist.last().get('paragraphs').length).toBe(23)
