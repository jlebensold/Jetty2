class App.Models.Note extends Backbone.Model
  idAttribute: "_id"

  url: ->
  	if @.get('_id')
  		"/note/#{this.get('_id')}"
  	else
  		"/notes"

  initialize: ->

  defaults: ->
  	{
  		content_id: ""
  		content_version: 1
  		start_paragraph:0
  		end_paragraph:0
  		start_paragraph_char: 0
  		end_paragraph_char: 0
  		raw_range: []
  		authorities: []
  		text: ""
  	}




  text: (view) ->
    $(view.el).find("#a_#{@get('start_paragraph')}").text()


  contains: (other) ->
  	self = @

  	if (self.get('start_paragraph') < other.get('start_paragraph'))
  		[other,self] = [self, other]

  	if (self.get('start_paragraph') == other.get('start_paragraph'))
  		!(other.get("end_paragraph_char") < self.get("start_paragraph_char") || other.get("start_paragraph_char") > self.get("end_paragraph_char"))
  	else
  		!(other.get("end_paragraph") < self.get("start_paragraph") || other.get("start_paragraph") > self.get("end_paragraph"))

  normalize: ->

  	if (@.get('start_paragraph') > @.get('end_paragraph'))
  		@.set({
  			start_paragraph:@.get('end_paragraph')
  			end_paragraph:@.get('start_paragraph')
  			start_paragraph_char:@get('end_paragraph_char')
  			end_paragraph_char:@get('start_paragraph_char')
  			})

  	if ((@.get('start_paragraph') == @.get('end_paragraph')) && (@.get('start_paragraph_char') > @.get('end_paragraph_char')))
  		@.set({
  			start_paragraph:@.get('end_paragraph')
  			end_paragraph:@.get('start_paragraph')
  			start_paragraph_char:@get('end_paragraph_char')
  			end_paragraph_char:@get('start_paragraph_char')
  			})
  	@

  size: ->
  	@.normalize();

  	p = (@.get('end_paragraph') - @.get('start_paragraph'))
  	if (p > 0)
  		c = @.get('end_paragraph_char') + @.get('start_paragraph_char')
  	else
  		c = @.get('end_paragraph_char') - (@.get('start_paragraph_char'))

  	"#{p}:#{c}"
