class Drawings

	constructor: (@canvas)-> @clear()

	createSvg: ->
		@g = @canvas.svg.append('g').attr('id','drawings')

	clear: ->
		d3.select("svg #drawings").remove()
		@createSvg()

	draw: (data) ->
		if data.length < 1
			@clear()
			return

		timeout = 1000 * 60 * 60
		time = new Date().getTime()
		fadeFn = d3.scale.linear()
			.domain([time,time-timeout])
			.range([timeout,0])
			.clamp(true)
		opacityFn = d3.scale.linear()
			.domain([time,time-timeout])
			.range([1,0.1])
			.clamp(true)

		canvas = @canvas
		line = d3.svg.line()
			.x((d)=> canvas.x(d.x))
			.y((d)=> canvas.y(d.y))
			.interpolate('basis')

		stdAttribs = (s)->
			s.attr('stroke', (d)-> d3.hsl(d.hue,0.6,0.6))
				.attr('d', (d)-> line(d.path))
				.attr('stroke-width', 3)
				.attr('fill', 'none')
				.attr('data-updated', (d)-> d.path[d.path.length-1].time)
				.style('stroke-linecap', 'round')
				.style('stroke-opacity', (d)-> opacityFn(d.path[d.path.length-1].time))
				.transition()
				.duration((d,i)-> fadeFn(d.path[d.path.length-1].time))
				.style('stroke-opacity', 0.1)

		selection = @g.selectAll('path').data(data, (d)-> d._id )

		selection.enter().append('path').call(stdAttribs)
		selection.exit().remove()

		# optimization: use the last point of the path to determine whether or not
		# this path is already updated or not. If updated, ignore.
		selection
			.filter( (d)-> d.path[d.path.length-1].time != parseInt(d3.select(@).attr('data-updated')))
			.call(stdAttribs)

define 'Drawings', [], ->
	Drawings: (canvas)-> new Drawings(canvas)
