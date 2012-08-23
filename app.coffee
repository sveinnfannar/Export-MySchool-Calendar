# Helper functions
init2dArray = (array, length) ->
    while array.length < length
        array.push([])

# Class defenition for the TimeSlot
class TimeSlot
    constructor: (@from, @to, @title, @room) ->

    exportToIcal: ->
        "\nBEGIN:VEVENT" +
        "\nDTSTART:" + (@_ISODateString @from)+
        "\nDTEND:" + (@_ISODateString @to) +
        "\nSUMMARY:" + @title +
        "\nLOCATION:" + @room +
        "\nEND:VEVENT"

    _ISODateString: (date) ->
        date.toString("yyyyMMddTHHmmssZ")


class Calendar
    constructor: ->
        @days = []
        init2dArray(@days, 7)

    parseCalendaDOM: ->
        # Get the dates
        dates = []
        $(".ruTable .ruTableRow2 :first th").each (i, e) ->
            date = $(this).html()
            dates.push $(this).html()
        dates = dates[1..]
        # Get each row in the table\
        days = []
        init2dArray(days, 7)
        $(".ruTable tr").each (index, ele) ->
            time = []
            # And each colunm
            $(this).children('td').each (cindex, cele) ->
                # Save the time for the classes in this row
                if cindex is 0
                    time = $(this).html().split("&nbsp;")
                # Get the class info
                $(this).children("span").each (sindex, sele) ->
                    span = $(this)
                    # Get the room number
                    room = span.text()
                    room = room.substring(room.length - 5, room.length - 1)
                    # Create the class title
                    title = span.attr("title").split("\n")
                    title = title[0] + " - " + title[2]
                    # Parse the date and time
                    date = dates[cindex - 1]
                    from = Date.parse date + " " + time[0]
                    to = Date.parse date + " " + time[1]
                    # Save the class
                    days[cindex - 1].push new TimeSlot from, to, title, room
        @days = days
        @_mergeTimeslots()
        return

    exportToIcal: ->
        str = "BEGIN:VCALENDAR" +
        "\nPRODID:-//MyschoolImporter v0.1//Sveinn Fannars Myschool iCal Thingy //EN" +
        "\nVERSION:2.0" +
        "\nCALSCALE:GREGORIAN" +
        "\nMETHOD:PUBLISH"
        for day in @days
            for timeslot in day
                str += timeslot.exportToIcal() unless timeslot is null
        str += "\nEND:VCALENDAR"

    _mergeTimeslots: ->
        # Merge timeslots
        for i in [0..8]
            day = @days[i]
            continue if not day?
            for j in [1..day.length]
                c1 = day[j - 1]
                c2 = day[j]
                if c1? and c2? and c1.title is c2.title and c1.room is c2.room
                    c1.to = c2.to
                    day[j] = null
                    day[j-1] = c1
            @days[i] = day


# Parse the DOM
$("button#make").live "click", ->
    #cal = new Calendar
    #cal.parseCalendaDOM()
    #data = cal.exportToIcal()
    console.log data
    #href = '<a href="data:text/calendar;charset=utf-8;base64,' + Base64.encode(data) + '">ics file</a><br/>'
    #$("body").append(href)

$("div.ruContentPage").prepend "<div align=\"center\" style=\"margin-left: 660px;\"><button type=\"button\" id=\"parse_calendar\">Export calendar</button></div>"

# Display popup
$("button#parse_calendar").live "click", ->
    source = chrome.extension.getURL "app.html"
    width = 920
    align = "center"
    top = 100
    padding = 10
    backgroundColor = "#FFFFFF"
    borderColor = "#000000"
    borderWeight = 4
    borderRadius = 5
    disableColor = "#666666"
    disableOpacity = 40
    loadingImage = chrome.extension.getURL "loading.gif"
    modalPopup align, top, width, padding, disableColor, disableOpacity, backgroundColor, borderColor, borderWeight, borderRadius, fadeOutTime, source, loadingImage


#This method hides the popup when the escape key is pressed
$(document).keyup (e) ->
    fadeOutTime = 300
    closePopup fadeOutTime if e.keyCode is 27

