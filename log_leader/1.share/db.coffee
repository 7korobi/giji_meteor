# Set up a collection to contain player information. On the server,
# it is backed by a MongoDB collection named "players".
share.db = db = 
  Auth:    new Meteor.Collection("auths")
  Request: new Meteor.Collection("requests")

  Face:  new Meteor.Collection("faces")

  Potof: new Meteor.Collection("potofs")

  Story: new Meteor.Collection("stories")
  Event: new Meteor.Collection("events")

console.log "share up"

