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
			selection = @svg.selectAll('circle').data(data, (d)-> d._id )

			selection.enter().append('circle')
			.attr('r', 10)
			.attr('cx', (d)-> d.x)
			.attr('cy', (d)-> d.y)
			.style('fill', (d)-> 
				d.hue = _.random(0,360)
				d3.hsl(d.hue,0.5,0.5)
			)

			selection.exit().remove()

			selection
				.attr('cx', (d)-> d.x)
				.attr('cy', (d)-> d.y)
			selection.transition()
			  .duration(30000)
			  .style('fill', (d)-> d3.hsl(d.hue,1,1))

define 'Canvas', [], ->
	Canvas: -> new Canvas()
