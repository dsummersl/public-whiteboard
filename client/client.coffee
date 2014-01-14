require ['Canvas','Mice','Drawings'], (canvasLib,miceLib,drawLib)->
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
			x: canvas.xToPercent(event.pageX - offset.left)
			y: canvas.yToPercent(event.pageY - offset.top)
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
			x: canvas.xToPercent(event.pageX - offset.left)
			y: canvas.yToPercent(event.pageY - offset.top)
		})
		if not pathId?
			pathId = Paths.insert data
		else
			Paths.update( pathId,
				'$set': data
			)

	# when the screen size changes, update the canvases since the mice/drawing
	# locations are no longer correct.
	$(window).resize(-> updateCanvasFn())

	Deps.autorun ->
		Meteor.subscribe('miceSubscription')
		Meteor.subscribe('pathsSubscription') 

	Meteor.startup ->
		canvas = canvasLib.Canvas()
		mice = miceLib.Mice(canvas)
		drawings = drawLib.Drawings(canvas)
		Deps.autorun -> updateCanvasFn()

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
