describe 'App.Models.Note', ->
	beforeEach -> 
		c = new App.Models.Note({text: "interesting!"})		

	it 'should be able to associate notes to content', ->
