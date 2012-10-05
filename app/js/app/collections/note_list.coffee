class App.Collections.NoteList extends Backbone.Collection
#  localStorage: new Backbone.LocalStorage("notes")
  url: "/notes"
  @model: App.Models.Note

  addUnique: (note) ->
    if !(@.any( (n) -> n.contains(note)))
      @.add(note)
      return true

    return false
