class Mice

	constructor: (@canvas)-> @clear()

	createSvg: -> @g = @canvas.svg.append('g').attr('id','mice')

	clear: ->
		d3.select('svg #mice').remove()
		@createSvg()

	draw: (data) ->
		if data.length < 1
			@clear()
			return

		timeout = 1500
		time = new Date().getTime()

		selection = @g.selectAll('circle').data(data, (d)-> d._id )

		# Use scales to determine timeouts and color fades:
		fadeFn = d3.scale.linear()
			.domain([time,time-timeout])
			.range([timeout,0])
			.clamp(true)
		opacityFn = d3.scale.linear()
			.domain([time,time-timeout])
			.range([1,0.1])
			.clamp(true)
		radiusFn = d3.scale.linear()
			.domain([time,time-timeout])
			.range([2,10])
			.clamp(true)
		satFn = d3.scale.linear()
			.domain([time,time-timeout])
			.range([0.5,0.1])
			.clamp(true)

		# Standard attributes used by both insert and update activities:
		canvas = @canvas
		stdAttribs = (s) =>
			s.attr('cx', (d)=> canvas.x(d.x))
				.attr('cy', (d)=> canvas.y(d.y))
				.attr('data-updated', (d)-> d.updated)
				.attr('r', (d)-> radiusFn(d.updated))
				.style('fill-opacity', (d)-> opacityFn(d.updated))
				.style('fill', (d)-> d3.hsl(d.hue,satFn(d.updated),0.5))

		selection.enter().append('circle').call(stdAttribs)
		selection.exit().remove()

		# optimization: don't update unchanged values.
		selection = selection
			.filter( (d)-> d.updated != parseInt(d3.select(@).attr('data-updated')))

		selection
			.attr('data-updated', (d)-> d.updated)
			.attr('cx', (d)=> canvas.x(d.x))
			.attr('cy', (d)=> canvas.y(d.y))

		selection.transition()
			.duration(100)
			.call(stdAttribs)
			.each('end', ->
				selection.transition()
					# the fadeFn ensures that if we are putting an old mouse on the screen
					# it 'starts' this transition at the proper point (if its really old
					# the transition is 0, and if its really new, then it needs the full
					# time)
					.duration((d)-> fadeFn(d.updated))
					# transition the opacity based on its *future* time
					.style('fill-opacity', (d)-> opacityFn(time-timeout))
					.attr('r', (d)-> radiusFn(time-timeout))
			)

define 'Mice', [], ->
	Mice: (canvas)-> new Mice(canvas)
