require ['Mice','Drawings'], (miceLib,drawLib)->
	Mice = new Meteor.Collection('mice')
	Paths = new Meteor.Collection('paths')
	mouseId = Session.get 'mouseId'
	hue = null
	canvas = null
	mice = null
	drawings = null
	path = null

	drawMiceFn = ->
		$('h2').hide()
		data = Mice.find({}).fetch()
		mice.draw(data) if canvas

	updateMouseFn = (event) ->
		offset = $('#canvas').offset()
		data = 
			updated: new Date().getTime()
			x: event.pageX - offset.left
			y: event.pageY - offset.top
		if not mouseId?
			hue = data.hue = _.random(0,360)
			mouseId = Mice.insert data
			Session.set 'mouseId', mouseId
		else
			Mice.update( mouseId,
				'$set': data
			)

	updatePathsFn = (event)->
		offset = $('#canvas').offset()
		path.push({
			time: new Date().getTime()
			hue: Mice.findOne(mouseId).hue
			x: event.pageX - offset.left
			y: event.pageY - offset.top
		})
		drawings.draw(path)

	Deps.autorun ->
		Meteor.subscribe('miceSubscription')

	Meteor.startup ->
		# TODO scale the canvas so that regardless of points, they all fit on the
		# screen.
		canvas = d3.select('#canvas').append('svg')
			.attr('width', '100%')
			.attr('height', '100%')
		mice = miceLib.Mice(canvas)
		drawings = drawLib.Drawings(canvas)
		Deps.autorun -> drawMiceFn()
		Meteor.setInterval(drawMiceFn, 5000)

	mmNumber = 0
	Template.canvas.events
		mousedown: (event)->
			# add points to represent this next hypothetical line.
			path = []
		mouseup: (event)->
			# TODO commit the result.
			path = null
		mousemove: (event)->
			mmNumber++
			if mmNumber % 2 == 0
				updateMouseFn(event)
			if mmNumber % 5 == 0 and path?
				updatePathsFn(event)
