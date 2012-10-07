describe 'App.Models.Content', ->
	selection = end = start = ""
	c = {}
	beforeEach ->
		selection =
			{
				anchorOffset: 10
				focusOffset: 14
			}
		start = '<p class="p_7">Persia, Will be of interest:</p>'
		end = '<p class="p_10">and being financially strengthened by Mrs. Barney\'s</p>'
		c = new App.Models.Content({text: Fixtures.text_text})

	it 'should be able to determine text selection based on paragraphs', ->
		expect(c.getParagraph(start)).toEqual(7)
		expect(c.getParagraph(end)).toEqual(10)

	it "should be able to determine word range across paragraphs", ->
		range = c.getSelectionRange(start,end,selection)
		expect(range).toEqual([[7,10],[10,14]])

	it "should be able to determine word range within a paragraph", ->
		end = start
		range = c.getSelectionRange(start,end, selection)
		expect(range).toEqual([[7,10],[7,14]])
