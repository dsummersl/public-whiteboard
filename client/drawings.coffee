class Drawings

	constructor: (@svg)->
		@createSvg()

	createSvg: ->
		# TODO each id should match...the mouseId?
		@g = @svg.append('g')
			.attr('id','path')
		  .append('path')

	clear: ->
		d3.select('svg #path').remove()
		@createSvg()

	draw: (data) ->
		return if not @g
		if data.length < 1
			@clear()
			return

		line = d3.svg.line()
			.x((d)-> d.x)
			.y((d)-> d.y)
			.interpolate('basis')

		selection = @g
			.datum(data)
		  .attr('d', line)
			.attr('stroke', (d,i)-> d3.hsl(d[i].hue,0.5,0.5))
			.attr('stroke-width', 3)
			.attr('fill', 'none')
			.style('stroke-linecap', 'round')

define 'Drawings', [], ->
	Drawings: (svg)-> new Drawings(svg)
