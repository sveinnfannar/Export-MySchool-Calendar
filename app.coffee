# Declare the 2d array for classes
classes = []
while classes.length < 7
    classes.push([])

# Class defenition for the TimeSlot
class TimeSlot
    constructor: (@from, @to, @title, @room) ->

# Parse the DOM
time = []
$(document).ready () ->
    # Get each row in the table
    $(".ruTable tr").each (index, ele) ->
        # And each colunm
        $(this).children('td').each (cindex, cele) ->
            # Save the time for the classes in this row
            if cindex is 0
                time = $(this).html().split('&nbsp;')
            # Get the class info
            $(this).children("span").each (sindex, sele) ->
                span = $(this)
                # Get the room number
                room = span.text()
                room = room.substring(room.length - 5, room.length - 1)
                # Create the class title
                title = span.attr("title").split("\n")
                title = title[0] + " - " + title[2]
                # Save the class
                classes[cindex - 1].push new TimeSlot time[0], time[1], title, room
    console.log classes

    # Merge timeslots
    for i in [0..8]
        day = classes[i]
        continue if not day?
        for j in [1..day.length]
            c1 = day[j - 1]
            c2 = day[j]
            if c1? and c2? and c1.title is c2.title and c1.room is c2.room
                c1.to = c2.to
                day[j] = null
                day[j-1] = c1
        classes[i] = day

    console.log classes


