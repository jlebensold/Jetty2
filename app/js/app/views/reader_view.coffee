class App.Views.ReaderView extends Backbone.View
  className: "reader"
  events: ->
    {
    }
  initialize: ->
    _.bindAll @, 'render','load_content_and_authority'
    @template = _.template($('#reader').html())
    @authorities = @options.authorities
    @
  render: ->

    $(@el).html @template()
    $(@el).find(".content").html(@txtview.render().el)
    $(@el).find(".manager").html(@am.render().el)
    $(@el).find('.tree').css('height',($(window).height() - 200) + 'px')

    @

  load_content_and_authority: (txt,tree) -> 
    @txtview = new App.Views.TextView({model: new App.Models.Content({text: txt}), authorities: tree })
    @am = new App.Views.AuthorityManagerView({model: tree})

