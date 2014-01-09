class Drawings

	constructor: (@svg)->
		@clear()

	createSvg: ->
		@g = @svg.append('g').attr('id','drawings')

	clear: ->
		d3.select("svg ##{@pathId}").remove()
		@createSvg()

	draw: (data) ->
		if data.length < 1
			@clear()
			return

		line = d3.svg.line()
			.x((d)-> d.x)
			.y((d)-> d.y)
			.interpolate('basis')

		stdAttribs = (s) ->
			# to get the at the path's hue attribute I must use it before doing the
			# datum() binding (otherwise, it appears that d.hue is always the...first
			# path's hue attribute?).
			s.attr('stroke', (d)-> d3.hsl(d.hue,0.6,0.6))
			s.datum((d)-> d.path)
				.attr('d', line)
				.attr('stroke-width', 3)
				.attr('fill', 'none')
				.style('stroke-linecap', 'round')

		selection = @g.selectAll('path').data(data, (d)-> d._id )

		selection.enter().append('path').call(stdAttribs)
		selection.exit().remove()

define 'Drawings', [], ->
	Drawings: (svg)-> new Drawings(svg)
