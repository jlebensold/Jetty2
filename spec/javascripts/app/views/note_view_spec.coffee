describe 'App.Views.NoteView', ->
  it 'should render a note', ->
    tree = App.Models.Authority.from_json Fixtures.locale_tree 
    view = new App.Views.NoteView({model: new App.Models.Note(), authorities: tree})
    $("#testbed").html(view.render().el)
    expect($("#testbed .note").length).toEqual(1)

  it 'should support tagging', ->
    tree = App.Models.Authority.from_json Fixtures.locale_tree 
    view = new App.Views.NoteView({model: new App.Models.Note(), authorities: tree})
    $("#testbed").html(view.render().el)
    throw 'get this working'