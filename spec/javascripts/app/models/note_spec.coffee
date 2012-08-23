describe 'App.Models.Note', ->
  beforeEach ->
    c = new App.Models.Note({text: "interesting!"})

  describe 'should be able to determine if one note overlaps another', ->
    it 'note is is fully contained', ->
      note = new App.Models.Note({
        start_paragraph:5
        end_paragraph:7
        start_paragraph_char: 4
        end_paragraph_char: 22
        })

      note2 = new App.Models.Note({
        start_paragraph:6
        end_paragraph:6
        start_paragraph_char: 10
        end_paragraph_char: 21
        })

      expect(note.contains(note2)).toEqual(true);

    it 'note starts inside another', ->
      note = new App.Models.Note({
        start_paragraph:5
        end_paragraph:7
        start_paragraph_char: 4
        end_paragraph_char: 22
        })

      note2 = new App.Models.Note({
        start_paragraph:4
        end_paragraph:6
        start_paragraph_char: 10
        end_paragraph_char: 21
        })

      expect(note.contains(note2)).toEqual(true);

    it 'does not overlap', ->
      note = new App.Models.Note({
        start_paragraph:5
        end_paragraph:7
        start_paragraph_char: 4
        end_paragraph_char: 22
        })

      note2 = new App.Models.Note({
        start_paragraph:10
        end_paragraph:12
        start_paragraph_char: 10
        end_paragraph_char: 21
        })

      expect(note.contains(note2)).toEqual(false);

    it 'note overlaps inside a paragraph', ->
      note = new App.Models.Note({
        start_paragraph:6
        end_paragraph:6
        start_paragraph_char: 2
        end_paragraph_char: 12
        })

      note2 = new App.Models.Note({
        start_paragraph:6
        end_paragraph:6
        start_paragraph_char: 8
        end_paragraph_char: 17
        })

      expect(note.contains(note2)).toEqual(true);

    it 'note starts after another SAY WHAT?', ->
      note = new App.Models.Note({
        start_paragraph:6
        end_paragraph:4
        start_paragraph_char: 3
        end_paragraph_char: 4
        }).normalize()

      note2 = new App.Models.Note({
        start_paragraph:7
        end_paragraph:5
        start_paragraph_char: 10
        end_paragraph_char: 21
        }).normalize()

      expect(note.contains(note2)).toEqual(true);

    it 'note can be normalized', ->
      note = new App.Models.Note({
        start_paragraph:6
        end_paragraph:4
        start_paragraph_char: 4
        end_paragraph_char: 22
        })
      note.normalize()
      expect(note.get('start_paragraph')).toEqual(4)

