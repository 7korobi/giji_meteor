# On server startup, create some players if the database is empty.
db = share.db
console.log "share load"

if Meteor.isServer
  readonly = ->
    insert: (id, obj)-> false
    remove: (id, obj)-> false
    update: (id, obj, fields, modifier)-> false

  db.Auth.allow    readonly
  db.Request.allow readonly

  db.Face.allow  readonly
  db.Story.allow readonly
  db.Potof.allow readonly
  db.Event.allow readonly

  Meteor.methods
    folders: ->
      folders = db.Story.find({}, 
        fields:
          folder: 1
      ).fetch()
      _.uniq _.map folders, (o)-> o.folder

  Meteor.publish "stories", (folder)-> 
    db.Story.find {folder: folder},
      fields:
        _type:   1
        folder:  1
        vid:     1
        name:    1
        rating:  1
        options: 1
        upd:     1
        vpl:     1
        type:    1
        card:    1

  Meteor.publish "story",  (story_id)-> db.Story.find(_id: story_id)
  Meteor.publish "potofs", (story_id)-> db.Potof.find(story_id: story_id)
  Meteor.publish "events", (story_id)-> db.Event.find(story_id: story_id)

  Meteor.publish "faces", -> db.Face.find()

  console.log "start now."

