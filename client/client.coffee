require 'Canvas', (canvasLib) ->
	points = new Meteor.Collection('pointsCollection')
	canvas = null

	Deps.autorun ->
		Meteor.subscribe('pointsSubscription')

	Meteor.startup ->
		canvas = canvasLib.Canvas()

		Deps.autorun ->
			data = points.find({}).fetch()
			$('h2').hide()
			canvas.draw(data) if canvas

	Template.drawingSurface.title = ->
		return 'Draw with Me! (A Collaborative, Real-Time Drawing Environment) Works best in Chrome.'

	Template.drawingSurface.events
		'click input': (event) ->
			Meteor.call 'clear', -> canvas.clear()

	markPoint = (event) ->
		offset = $('#canvas').offset()
		points.insert
			x: event.pageX - offset.left
			y: event.pageY - offset.top

	Template.canvas.events
		'click': (event) -> markPoint(event)
		'mousedown': (event) -> Session.set('draw', true)
		'mouseup': (event) -> Session.set('draw', false)
		'mousemove': (event) ->
			if Session.get('draw')
				markPoint(event)
