Points = new Meteor.Collection('pointsCollection')

Meteor.publish 'pointsSubscription', ->
  return Points.find()

Meteor.methods
  clear: -> Points.remove({});
