if Meteor.isClient
  hello = ""
  Template.hello.greeting = ->
    "Welcome to giji_meteor.  #{hello}"

  Template.hello.events
    "click input": ->
      hello = "You pressed the button"
      Meteor.setTimeout ->
        hello = ""
      , 3000

if Meteor.isServer
  Meteor.startup ->


# code to run on server at startup
