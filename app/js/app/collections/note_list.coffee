class App.Collections.NoteList extends Backbone.Collection
  url: -> 
    "/notes/#{this.content_id}"
  
  model: App.Models.Note

  addUnique: (note) ->
    if !(@.any( (n) -> n.contains(note)))
      @.add(note)
      return true

    return false


  tryGetNote: (content,selection) -> 
    range = @.getRange(content, selection)
    filtered = @filter((n) -> 
      n.get('start_paragraph') == range[0][0] &&
      n.get('end_paragraph') == range[1][0] &&
      n.get('start_paragraph_char') < range[0][1] &&
      n.get('end_paragraph_char') > range[1][1])
    return filtered[0] if filtered.length > 0 
    return null


  roundParagraphFromContent: (content, selection, callback) ->
    s = selection
    range = @.getRange(content, selection)
    paragraph = $(s.baseNode.parentNode).text().length
    note = new App.Models.Note({
      content_id: content.get('_id'),
      start_paragraph: range[0][0]
      end_paragraph: range[0][0]
      start_paragraph_char: 0
      end_paragraph_char: paragraph
      raw_range: range
    })
    note.normalize()
    @create note


  fromContent: (content,selection,callback) ->
    range = @.getRange(content, selection)

    note = new App.Models.Note({
      content_id: content.get('_id'),
      start_paragraph: range[0][0]
      end_paragraph: range[1][0]
      start_paragraph_char: range[0][1]
      end_paragraph_char: range[1][1]
      raw_range: range
    })
    note.normalize()
    @create note
  
  getRange: (content, selection) ->
    s = selection
    content.getSelectionRange($(s.baseNode.parentNode), $(s.focusNode.parentNode), s)
