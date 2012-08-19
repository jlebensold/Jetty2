describe 'App.Collections.NoteList', ->
  beforeEach ->

  it 'should not add notes that are overlapping', ->
    list = new App.Collections.NoteList
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

    list.addUnique(note)
    list.addUnique(note2)

    expect(list.length).toEqual(1)
