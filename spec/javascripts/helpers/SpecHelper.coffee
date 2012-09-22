window.fx = {}
window.reload_fx = ->
  window.fx = jasmine.getFixtures().fixturesCache_

beforeEach ->
	$("#testbed").remove()
	$("body").append '<div id="testbed">testbed</div>'

	loadFixtures("templates/tree_node.ejs");
	loadFixtures("templates/authority_manager.ejs");
	loadFixtures("templates/content.ejs");
	loadFixtures("templates/note.ejs");
	loadFixtures("templates/reader.ejs");

	reload_fx()
	$("body .tpl").remove()
	_.each fx, ((item,key) ->
		$("body").append('<script class="tpl" id="'+_.last(key.split("/")).split(".")[0]+'" type="text/template">'+item+'</script>')
	), this
