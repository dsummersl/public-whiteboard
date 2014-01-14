class Canvas

	constructor: ->
		@clear()
		@setupMappings()
		# TODO detect whether in landscape or non-landscape mode.
		# change the landscape/non-landscape when the viewport size changes.
		$(window).resize(=> @setupMappings())

	setupMappings: ->
		console.log("setupMappings");
		svg = $('#canvas svg')
		@x = d3.scale.linear()
			.domain([0,100])
			.range([0,svg.width()])
		@y = d3.scale.linear()
			.domain([0,100])
			.range([0,svg.height()])
		@xToP = d3.scale.linear()
			.domain([0,svg.width()])
			.range([0,100])
		@yToP = d3.scale.linear()
			.domain([0,svg.height()])
			.range([0,100])

	xToPercent: (x)-> @xToP(x)

	yToPercent: (y)-> @yToP(y)

	createSvg: -> 
		@svg = d3.select('#canvas').append('svg')
			.attr('width', '100%')
			.attr('height', '100%')

	clear: ->
		d3.select('#canvas svg').remove()
		@createSvg()

define 'Canvas', [], ->
	Canvas: ()-> new Canvas()
