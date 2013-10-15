console.log "share load"


if Meteor.isClient
  go = share.go = 
    back: null

  Meteor.call "folders", (e,folders)->
    Session.set "folders", folders

  Deps.autorun ->
    subtitle = Session.get("event_id") || Session.get("story_id") || Session.get("folder") || 'トップ'
    $('title').text "人狼議事 #{subtitle}"

  Deps.autorun ->
    go.back = null
    return unless folder = Session.get "folder"
    Meteor.subscribe "stories", folder
    go.back = "folder"

  Deps.autorun ->
    go.back = "folder"
    return unless story_id = Session.get "story_id"
    Meteor.subscribe "potofs", story_id
    Meteor.subscribe "story",  story_id
    Meteor.subscribe "events", story_id
    go.back = "story_id"

  Deps.autorun ->
    go.back = "story_id"
    return unless event_id = Session.get "event_id"
    go.back = "event_id"

  Deps.autorun ->
    Meteor.subscribe "faces"


