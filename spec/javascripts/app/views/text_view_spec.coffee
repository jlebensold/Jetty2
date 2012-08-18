describe 'App.Views.TextView', ->
	beforeEach -> 
		reload_fx()

	it 'should render render text', ->
		txt = new App.Models.Content({text: Fixtures.text_text})
		view = new App.Views.TextView({model: txt})
		$("#testbed").html(view.render().el)

	it 'should render highlight on top of text', ->
		txt = new App.Models.Content({text: Fixtures.text_text})
		view = new App.Views.TextView({model: txt})
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
			end_paragraph_char: 21
			})
		view.addHighlight note2
		expect($(".h_4 em").html()).toEqual('the launching of this')

	it "should render notes near the highlighted text", ->
		txt = new App.Models.Content({text: Fixtures.text_text})
		view = new App.Views.TextView({model: txt})
		$("#testbed").html(view.render().el)

		note = new App.Models.Note({
			start_paragraph:5
			end_paragraph:7
			start_paragraph_char: 4
			end_paragraph_char: 22
			})

		view.addHighlight note

		expect($(view.el).find(".notes_container .note").length).toEqual(1)