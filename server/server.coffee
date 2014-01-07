Mice = new Meteor.Collection('mice')
Paths = new Meteor.Collection('paths')

Meteor.publish 'miceSubscription', ->
  return Mice.find()

Meteor.methods
  clear: -> Mice.remove({});
