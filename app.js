(function() {
  var Calendar, TimeSlot, init2dArray;

  init2dArray = function(array, length) {
    var _results;
    _results = [];
    while (array.length < length) {
      _results.push(array.push([]));
    }
    return _results;
  };

  TimeSlot = (function() {

    TimeSlot.name = 'TimeSlot';

    function TimeSlot(from, to, title, room) {
      this.from = from;
      this.to = to;
      this.title = title;
      this.room = room;
    }

    TimeSlot.prototype.exportToIcal = function() {
      return "\nBEGIN:VEVENT" + "\nDTSTART:" + (this._ISODateString(this.from)) + "\nDTEND:" + (this._ISODateString(this.to)) + "\nSUMMARY:" + this.title + "\nLOCATION:" + this.room + "\nRRULE:FREQ=WEEKLY" + "\nEND:VEVENT";
    };

    TimeSlot.prototype._ISODateString = function(date) {
      return date.toString("yyyyMMddTHHmmssZ");
    };

    return TimeSlot;

  })();

  Calendar = (function() {

    Calendar.name = 'Calendar';

    function Calendar() {
      this.days = [];
      init2dArray(this.days, 7);
    }

    Calendar.prototype.parseCalendaDOM = function() {
      var dates, days;
      dates = [];
      $(".ruTable .ruTableRow2 :first th").each(function(i, e) {
        var date;
        date = $(this).html();
        return dates.push($(this).html());
      });
      dates = dates.slice(1);
      days = [];
      init2dArray(days, 7);
      $(".ruTable tr").each(function(index, ele) {
        var time;
        time = [];
        return $(this).children('td').each(function(cindex, cele) {
          if (cindex === 0) {
            time = $(this).html().split("&nbsp;");
          }
          return $(this).children("span").each(function(sindex, sele) {
            var date, from, room, span, title, to;
            span = $(this);
            room = span.text();
            room = room.substring(room.length - 5, room.length - 1);
            title = span.attr("title").split("\n");
            title = title[0] + " - " + title[2];
            date = dates[cindex - 1];
            from = Date.parseExact(date + " " + time[0], "dd.MM.yyyy HH:mm");
            to = Date.parseExact(date + " " + time[1], "dd.MM.yyyy HH:mm");
            console.log(date + " " + time[0] + " = " + from);
            return days[cindex - 1].push(new TimeSlot(from, to, title, room));
          });
        });
      });
      this.days = days;
      this._mergeTimeslots();
    };

    Calendar.prototype.exportToIcal = function() {
      var day, str, timeslot, _i, _j, _len, _len1, _ref;
      str = "BEGIN:VCALENDAR" + "\nPRODID:-//MyschoolImporter v0.1//Sveinn Fannars Myschool iCal Thingy //EN" + "\nVERSION:2.0" + "\nCALSCALE:GREGORIAN" + "\nMETHOD:PUBLISH";
      _ref = this.days;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        day = _ref[_i];
        for (_j = 0, _len1 = day.length; _j < _len1; _j++) {
          timeslot = day[_j];
          if (timeslot !== null) {
            str += timeslot.exportToIcal();
          }
        }
      }
      return str += "\nEND:VCALENDAR";
    };

    Calendar.prototype._mergeTimeslots = function() {
      var c1, c2, day, i, j, _i, _j, _ref, _results;
      _results = [];
      for (i = _i = 0; _i <= 8; i = ++_i) {
        day = this.days[i];
        if (!(day != null)) {
          continue;
        }
        for (j = _j = 1, _ref = day.length; 1 <= _ref ? _j <= _ref : _j >= _ref; j = 1 <= _ref ? ++_j : --_j) {
          c1 = day[j - 1];
          c2 = day[j];
          if ((c1 != null) && (c2 != null) && c1.title === c2.title && c1.room === c2.room) {
            c1.to = c2.to;
            day[j] = null;
            day[j - 1] = c1;
          }
        }
        _results.push(this.days[i] = day);
      }
      return _results;
    };

    return Calendar;

  })();

  $("button#parse_calendar").live("click", function() {
    var bb, cal, data;
    cal = new Calendar;
    cal.parseCalendaDOM();
    data = cal.exportToIcal();
    bb = new BlobBuilder;
    bb.append(data);
    return saveAs(bb.getBlob("text/calendar;charset=" + document.characterSet, "calendar.ics"));
  });

  $("div.ruContentPage").prepend("<div align=\"center\" style=\"margin-left: 660px;\"><button type=\"button\" id=\"parse_calendar\">Export calendar</button></div>");

}).call(this);
