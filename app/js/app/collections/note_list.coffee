class App.Collections.NoteList extends Backbone.Collection
#  localStorage: new Backbone.LocalStorage("notes")
  url: "/notes"
  model: App.Models.Note

  addUnique: (note) ->
    if !(@.any( (n) -> n.contains(note)))
      @.add(note)
      return true

    return false

  fromContent: (content,selection,callback) ->
    s = selection
    self = @
    range = content.getSelectionRange($(s.baseNode.parentNode), $(s.focusNode.parentNode), s)

    note = new App.Models.Note({
      content_id: content.get('_id'),
      start_paragraph: range[0][0]
      end_paragraph: range[1][0]
      start_paragraph_char: range[0][1]
      end_paragraph_char: range[1][1]
      raw_range: range
    })
    note.normalize()

    @add(note)
    note


