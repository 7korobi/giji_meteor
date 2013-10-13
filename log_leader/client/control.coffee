db = share.db
console.log("share load")


if Meteor.isClient
  Deps.autorun ->
    event_id = Session.get "event_id"
    if event_id?
      Meteor.subscribe "faces"
      Meteor.subscribe "event", event_id

    story_id = Session.get "story_id"
    if story_id?
      Meteor.subscribe "potofs", story_id
      Meteor.subscribe "story",  story_id
      Meteor.subscribe "events", story_id
    else
      Meteor.subscribe "stories"


  Template.main.story_id = -> Session.get "story_id"
  Template.main.event_id = -> Session.get "event_id"


  Template.folder.stories = ->
    db.Story.find(folder: "WOLF")
  Template.folder.events
    "click a.choice": -> Session.set "story_id", @_id


  Template.story.story = ->
    return [] unless story_id = Session.get "story_id"
    db.Story.findOne(story_id)
  Template.story.event_list = ->
    return [] unless story_id = Session.get "story_id"
    _.sortBy _.map(db.Event.find(story_id: story_id).fetch(), (o)->
      o.name ||= o.turn + "日目"
      o
    ), (o)-> o.turn
  Template.story.events
    "click a.choice": -> Session.set "event_id", @_id


  Template.event.messages = ->
    event_id = Session.get "event_id"
    return [] unless event_id?

    event = db.Event.findOne(event_id) || []
    return [] unless event?

    event.messages


  Template.message.json = ->
    JSON.stringify(@)

