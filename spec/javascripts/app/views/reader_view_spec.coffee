describe 'App.Views.ReaderView', ->
  xit 'should render a content area with the auth manager', ->
    r = new App.Views.ReaderView()
    r.load_content_and_authority Fixtures.text_text, Fixtures.locale_tree
    $("#testbed").html(r.render().el)

