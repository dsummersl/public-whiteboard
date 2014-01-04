require 'Canvas', (canvasLib) ->
	Points = new Meteor.Collection('pointsCollection')
	pointId = Session.get 'pointId'
	canvas = null

	updateCanvasFn = ->
		$('h2').hide()
		data = Points.find({}).fetch()
		canvas.draw(data) if canvas

	updatePointFn = (event) ->
		offset = $('#canvas').offset()
		data = 
			updated: new Date().getTime()
			x: event.pageX - offset.left
			y: event.pageY - offset.top
		if not pointId?
			data.hue = _.random(0,360)
			pointId = Points.insert data
			Session.set 'pointId', pointId
		else
			Points.update( pointId,
				'$set': data
			)

	Deps.autorun ->
		Meteor.subscribe('pointsSubscription')

	Meteor.startup ->
		canvas = canvasLib.Canvas()
		Deps.autorun -> updateCanvasFn()
		Meteor.setInterval(updateCanvasFn, 5000)

	Template.canvas.events
		'mousemove': (event) -> updatePointFn(event)
