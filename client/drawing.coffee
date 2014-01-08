class Drawing

	constructor: (@svg,@pathId)->
		@clear()

	createSvg: ->
		@g = @svg.append('g')
			.attr('id',@pathId)
		  .append('path')

	clear: ->
		d3.select("svg ##{@pathId}").remove()
		@createSvg()

	draw: (data) ->
		return if not @g
		if data.length < 1
			@clear()
			return

		widthFn = d3.scale.sqrt()
			.domain([1,20])
			.range([15,1])
			.clamp(true)

		line = d3.svg.line()
			.x((d)-> d.x)
			.y((d)-> d.y)
			.interpolate('basis')

		selection = @g
			.datum(data)
		  .attr('d', line)
			.attr('stroke', (d,i)-> d3.hsl(d[i].hue,0.4,0.6))
			.attr('stroke-width', widthFn(data.length))
			.attr('fill', 'none')
			.style('stroke-linecap', 'round')

define 'Drawing', [], ->
	Drawing: (svg)-> new Drawing(svg)
