Jetty
==========================
A simple reading environment that supports annotations and a rudimentary taxonomy manager.

GETTING STARTED
-------------------
<pre>
bundle
thin start
</pre>

JS TESTING WITH JASMINE
------------------------

rake jasmine - point the browser to http://localhost:8888/

sinonjs has been included for mocking / stubbing / spying as well as jasmine-jquery.

Sinatra Assetpack handles coffeescript compilation on the fly, and in production, takes care of minification / uglification of js and coffeescript into 2 discrete files - vendor.js and application.js

Current Model:
------
<pre>
Authority
 	name
 	parent
 	children

Content
	text
	version

Notes
	id
	content_id
	content_version
	start_paragraph
	start_paragraph_char
	end_paragraph
	end_paragraph_char
	authorities: []
	text
	timestampable
</pre>	
TODO:
------
<pre>
AuthorityRelation
	type
	source
	target
	text
</pre>