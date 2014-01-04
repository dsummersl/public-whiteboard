class Canvas

	constructor: ->
		@createSvg()

	createSvg: ->
		@svg = d3.select('#canvas').append('svg')
			.attr('width', '100%')
			.attr('height', '100%')

	clear: ->
		d3.select('svg').remove()
		@createSvg()

	draw: (data) ->
		if data.length < 1
			@clear()
			return
		if @svg
			defaultR = 15
			timeout = 5000
			time = new Date().getTime()

			selection = @svg.selectAll('circle').data(data, (d)-> d._id )

			# Use scales to determine timeouts and color fades:
			fadeFn = d3.scale.linear()
				.domain([time,time-timeout])
				.range([timeout,0])
				.clamp(true)
			opacityFn = d3.scale.linear()
				.domain([time,time-timeout])
				.range([1,0.3])
				.clamp(true)
			satFn = d3.scale.linear()
				.domain([time,time-timeout])
				.range([0.5,0.1])
				.clamp(true)

			# Standard attributes used by both insert and update activities:
			stdAttribs = (s) ->
				s.attr('cx', (d)-> d.x)
					.attr('cy', (d)-> d.y)
					.attr('data-updated', (d)-> d.updated)
					.attr('r', (d)-> opacityFn(d.updated)*defaultR)
					.style('opacity', (d)-> opacityFn(d.updated))
					.style('fill', (d)-> d3.hsl(d.hue,satFn(d.updated),0.5))

			# When I create a new picture, I bind a random color to the element for
			# future use (since the original data set doesn't actually contain a color
			# attribute and it won't be around later on).
			selection.enter().append('circle').call(stdAttribs)

			# not really expecting things to leave, but if they do, go away:
			selection.exit().remove()

			# Minor optimization: don't update unchanged values.
			selection = selection
				.filter( (d)-> d.updated != parseInt(d3.select(@).attr('data-updated')))

			selection
				.attr('data-updated', (d)-> d.updated)
				.attr('cx', (d)-> d.x)
				.attr('cy', (d)-> d.y)

			selection.transition()
			  .duration(100)
				.call(stdAttribs)
				.each('end', ->
					selection.transition()
						.duration((d)-> fadeFn(d.updated))
						.style('opacity', (d)-> opacityFn(d.updated-fadeFn(d.updated)))
						.attr('r', (d)-> opacityFn(d.updated-fadeFn(d.updated))*defaultR)
				)

define 'Canvas', [], ->
	Canvas: -> new Canvas()
