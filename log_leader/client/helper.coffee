if Meteor.isClient
  db = share.db
  go = share.go
  console.log "share load"

  # main
  session = 
    folder:   -> Session.get "folder"
    story_id: -> Session.get "story_id"
    event_id: -> Session.get "event_id"

  Template.left.helpers session
  Template.log.helpers  session
  Template.top.helpers  session
  Template.top.events
    "touchend .back,   mouseup .back,   click .back":   ->
      Session.set go.back, null

  # folders
  Template.folders.helpers
    folder:  -> Session.get "folder"
    folders: -> Session.get "folders"

  Template.folders.events
    "touchend .choice, mouseup .choice, click .choice": ->
      Session.set "folder", "#{@}"


  # folder
  Template.folder.helpers
    stories: ->
      folder = Session.get "folder"
      db.Story.find(folder: folder)

  Template.folder.events
    "touchend .choice, mouseup .choice, click .choice": ->
      Session.set "story_id", @_id

  # story
  Template.story.helpers
    story: ->
      story_id = Session.get "story_id"
      db.Story.findOne(story_id) || []

  Template.story_left.helpers
    events: ->
      _.sortBy _.map( db.Event.find().fetch(), (o)->
        o.name ||= o.turn + "日目"
        o
      ), (o)-> o.turn

  Template.story_left.events
    "touchend .choice, mouseup .choice, click .choice": -> Session.set "event_id", @_id


  # event
  Template.event.helpers
    messages: ->
      Session.get "story_id"
      event_id = Session.get "event_id"

      event = db.Event.findOne(event_id)
      event.messages if event


  # message
  Template.message.helpers
    json: ->
      JSON.stringify(@)

