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
			@svg.selectAll('circle').data(data, (d)-> d._id )
			.enter().append('circle')
			.attr('r', 10)
			.attr('cx', (d)-> d.x)
			.attr('cy', (d)-> d.y)

define('Canvas', [], ->
	Canvas: -> new Canvas()
)
