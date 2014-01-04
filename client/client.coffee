require 'Canvas', (canvasLib) ->
	Points = new Meteor.Collection('pointsCollection')
	pointId = Session.get 'pointId'
	canvas = null

	Deps.autorun ->
		Meteor.subscribe('pointsSubscription')

	Meteor.startup ->
		canvas = canvasLib.Canvas()

		Deps.autorun ->
			data = Points.find({}).fetch()
			$('h2').hide()
			canvas.draw(data) if canvas

	updatePoint = (event) ->
		offset = $('#canvas').offset()
		data = 
			x: event.pageX - offset.left
			y: event.pageY - offset.top
			updated: new Date().getTime()
		if not pointId
			pointId = Points.insert data
			Session.set 'pointId', pointId
		else
			Points.update( pointId, data )

	Template.canvas.events
		'mousemove': (event) -> updatePoint(event)
