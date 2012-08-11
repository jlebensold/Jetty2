describe 'App.Views.TreeView', ->
	it 'should test sanity', ->
		tv = new App.Views.TreeView
		expect($(tv.render().el).html()).toEqual("hello world")