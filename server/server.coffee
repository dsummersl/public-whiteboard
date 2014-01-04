points = new Meteor.Collection('pointsCollection')

Meteor.publish 'pointsSubscription', ->
  return points.find()

Meteor.methods
  clear: -> points.remove({});
