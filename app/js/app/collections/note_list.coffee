class App.Collections.NoteList extends Backbone.Collection
  @model: App.Models.Note

  addUnique: (note) ->
    if !(@.any( (n) -> n.contains(note)))
      @.add(note)
      return true

    return false
