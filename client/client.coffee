require ['Mice','Drawings'], (miceLib,drawLib)->
	Mice = new Meteor.Collection('mice')
	Paths = new Meteor.Collection('paths')
	mouseId = Session.get 'mouseId'
	pathId = null
	canvas = null
	mice = null
	drawings = null

	updateCanvasFn = ->
		return if not canvas?
		$('h2').hide()
		allMice = Mice.find({}).fetch()
		allDrawings = Paths.find({}).fetch()
		mice.draw(allMice)
		drawings.draw(allDrawings)

	updateMouseFn = (event) ->
		offset = $('#canvas').offset()
		data = 
			updated: new Date().getTime()
			x: event.pageX - offset.left
			y: event.pageY - offset.top
		if not mouseId?
			data.hue = _.random(0,360)
			mouseId = Mice.insert data
			Session.set 'mouseId', mouseId
		else
			Mice.update( mouseId,
				'$set': data
			)

	updatePathFn = (event)->
		offset = $('#canvas').offset()
		data =
			mouseId: mouseId
			hue: Mice.findOne(mouseId).hue
			path: []
		data.path = Paths.findOne(pathId).path if pathId?
		data.path.push({
			time: new Date().getTime()
			x: event.pageX - offset.left
			y: event.pageY - offset.top
		})
		if not pathId?
			pathId = Paths.insert data
		else
			Paths.update( pathId,
				'$set': data
			)

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
		drawings = drawLib.Drawings(canvas)
		Deps.autorun -> updateCanvasFn()
		Meteor.setInterval(updateCanvasFn, 5000)

	mmNumber = 0
	Template.canvas.events
		mousedown: (event)-> updatePathFn(event)
		mouseup: (event)-> pathId = null
		mousemove: (event)->
			mmNumber++
			if mmNumber % 2 == 0
				updateMouseFn(event)
			if mmNumber % 5 == 0 and pathId?
				updatePathFn(event)
