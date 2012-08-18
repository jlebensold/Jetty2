describe 'App.Models.Content', ->
	selection = end = start = ""
	c = {}
	beforeEach -> 
		selection = '''Will be of interest:

55* -It -X- -

Having attended to all preliminary details

and being financially strength'''
		start = '<p class="p_7">Persia, Will be of interest:</p>'
		end = '<p class="p_10">and being financially strengthened by Mrs. Barney\'s</p>'
		c = new App.Models.Content({text: Fixtures.text_text})		

	it 'should be able to determine text selection based on paragraphs', ->
		expect(c.getParagraph(start)).toEqual(7)
		expect(c.getParagraph(end)).toEqual(10)

	it "should be able to determine word range across paragraphs", ->
		range = c.getSelectionRange(start,end,selection)
		expect(range).toEqual([[7,8,20],[10,0,30]])

	it "should be able to determine word range within a paragraph", ->
		start = end
		range = c.getSelectionRange(start,end,'being financially strengthened')
		expect(range).toEqual([[10,4,30],[10,4,30]])
		range = c.contentSelectionRange(start,end,'being financially strengthened')

	it "should be able to determine the selection range from the raw text", ->
		range = c.contentSelectionRange(start,end,selection)
		expect(c.get('text').substr(range[0],range[1] - range[0]).trim().substr(0,20)).toEqual(selection.substr(0,20))
		expect(c.get('text').substr(range[0],range[1] - range[0]).trim().substr(-30)).toEqual(selection.substr(-30))
