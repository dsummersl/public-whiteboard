require ['Mice','Drawing'], (miceLib,drawLib)->
	Mice = new Meteor.Collection('mice')
	Paths = new Meteor.Collection('paths')
	mouseId = Session.get 'mouseId'
	hue = null
	canvas = null
	mice = null
	currentDrawing = null
	path = null

	updateCanvasFn = ->
		$('h2').hide()
		allMice = Mice.find({}).fetch()
		allDrawings = Paths.find({}).fetch()
		if canvas
			mice.draw(allMice)

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

	updateCurrentPathFn = (event)->
		offset = $('#canvas').offset()
		path.push({
			time: new Date().getTime()
			hue: Mice.findOne(mouseId).hue
			x: event.pageX - offset.left
			y: event.pageY - offset.top
		})
		currentDrawing.draw(path)

	Deps.autorun ->
		Meteor.subscribe('miceSubscription')
		Meteor.subscribe('pathsSubscription') 
	Meteor.startup ->
		# TODO scale the canvas so that regardless of points, they all fit on the
		# screen.
		canvas = d3.select('#canvas').append('svg')
			.attr('width', '100%')
			.attr('height', '100%')
		mice = miceLib.Mice(canvas)
		currentDrawing = drawLib.Drawing(canvas,mouseId)
		Deps.autorun -> updateCanvasFn()
		Meteor.setInterval(updateCanvasFn, 5000)

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
				updateCurrentPathFn(event)
