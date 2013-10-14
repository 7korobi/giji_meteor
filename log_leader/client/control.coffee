db = share.db
console.log("share load")


if Meteor.isClient
  events = []

  Deps.autorun ->
    return unless story_id = Session.get "story_id"
    Meteor.subscribe "potofs", story_id
    Meteor.subscribe "story",  story_id
    Meteor.subscribe "events", story_id

  Deps.autorun ->
    console.log "  Deps.autorun event_id"
    return unless event_id = Session.get "event_id"

  Deps.autorun ->
    Meteor.subscribe "faces"
    Meteor.subscribe "stories"

  # main
  session = 
    story_id: -> Session.get "story_id"
    event_id: -> Session.get "event_id"
  Template.main.helpers session
  Template.log.helpers  session

  # folder
  Template.folder.helpers
    stories: ->
      db.Story.find(folder: "WOLF")

  Template.folder.events
    "click a.choice": -> Session.set "story_id", @_id

  # story
  Template.story.helpers
    story: ->
      story_id = Session.get "story_id"
      db.Story.findOne(story_id) || []

    events: ->
      _.sortBy _.map( db.Event.find().fetch(), (o)->
        o.name ||= o.turn + "日目"
        o
      ), (o)-> o.turn

  Template.story.events
    "click a.choice": -> Session.set "event_id", @_id
    "click a.back":   ->
      Session.set "story_id", null
      Session.set "event_id", null

  # event
  Template.event.helpers
    messages: ->
      Session.get "story_id"
      event_id = Session.get "event_id"

      event = db.Event.findOne(event_id)
      event.messages if event

  Template.event.events
    "click a.back": -> Session.set "event_id", null

  # message
  Template.message.helpers
    json: ->
      JSON.stringify(@)

