describe 'App.Views.TextView', ->
	beforeEach( ->
		@server = sinon.fakeServer.create()   
		reload_fx()
	)

	afterEach( ->
		@server.restore()
	)

	it 'should render render text', ->
		txt = new App.Models.Content({text: Fixtures.text_text})
		view = new App.Views.TextView({model: txt})
		$("#testbed").html(view.render().el)

	it 'should render highlight on top of text', ->
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()
		txt = new App.Models.Content({model: Fixtures.content})
		txt.set('text',window.Fixtures.text_text)
		view = new App.Views.TextView({model: txt, authorities: auth.first()})
		$("#testbed").html(view.render().el)

		note = new App.Models.Note({
			start_paragraph:5
			end_paragraph:7
			start_paragraph_char: 4
			end_paragraph_char: 22
			})
		view.addHighlight note
		expect($(".h_6 em").html()).toEqual('Ahmad Sohrab to Mr. Sidney Sprague, Teheran,')

		note2 = new App.Models.Note({
			start_paragraph:4
			end_paragraph:4
			start_paragraph_char: 10
			end_paragraph_char: 31
			})
		view.addHighlight note2
		expect($(".h_4 em").html()).toEqual('the launching of this')

	it "should render notes near the highlighted text", ->
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()
		txt = new App.Models.Content({model: Fixtures.content})
		txt.set('text',window.Fixtures.text_text)
		view = new App.Views.TextView({model: txt, authorities: auth.first()})
		$("#testbed").html(view.render().el)

		note = new App.Models.Note({
			start_paragraph:5
			end_paragraph:7
			start_paragraph_char: 4
			end_paragraph_char: 22
			})

		view.addHighlight note

		expect($(view.el).find(".notes_container .note").length).toEqual(1)

	it "should keep track of added notes", ->
		@server.respondWith("GET","/authorities",serverResponse(Fixtures.locale_tree))
		auth = new App.Collections.AuthorityList()
		auth.fetch()
		@server.respond()
		txt = new App.Models.Content({model: Fixtures.content})
		txt.set('text',window.Fixtures.text_text)
		view = new App.Views.TextView({model: txt, authorities: auth.first()})
		$("#testbed").html(view.render().el)

		note = new App.Models.Note({
			start_paragraph:5
			end_paragraph:7
			start_paragraph_char: 4
			end_paragraph_char: 22
			})
		view.addHighlight note

		note2 = new App.Models.Note({
			start_paragraph:4
			end_paragraph:4
			start_paragraph_char: 10
			end_paragraph_char: 21
			})

		view.addHighlight note2

		expect($(view.el).find('.note').length).toEqual(2)

	it "should not add notes with no characters", ->
		txt = new App.Models.Content({text: Fixtures.text_text})
		view = new App.Views.TextView({model: txt})
		$("testbed").html(view.render().el)

		note = new App.Models.Note({
			start_paragraph: 1
			start_paragraph_char: 1
			end_paragraph: 1
			end_paragraph_char: 1
			})

		view.addHighlight note

		expect(view.notes.length).toEqual(0)


