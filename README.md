Export-MySchool-Calendar
========================

Export-MySchool-Calendar is a small Chrome extesion to export the Reykjavík University MySchool calendar to a more convenient format so it can be imported into other applicatoins like: Google Calendar, Apple Calendar (formerly iCal), IBM Lotus Notes, Yahoo! Calendar and many more.

It works by adding an "Export Calendar" button above the calendar in MySchool, when clicked a script parses the DOM and creates a [ics file][1] that is downloaded.

Install
-------
Bring up the extensions management page by clicking the wrench icon and choosing Tools > Extensions.  
If Developer mode has a + by it, click the + to add developer information to the page. The + changes to a -, and more buttons and information appear.  
Click the Load unpacked extension button. A file dialog appears.  
In the file dialog, navigate to your extension's folder and click OK.  

Use
---
###Import to Google Calendar
Click the down-arrow next to Other calendars.  
Select Import calendar.  
Click Choose file and find the file that contains your events, then click Open.  
Select the Google Calendar where you'd like to import events, then click Import.  

###Import to Apple iCal
Simply open the ics file and iCal should offer to import the events.

Contribute
----------
The only thing you have to do to contribute is to have [CoffeeScript][2] installed to compile app.coffee and probably have access to Reykjavík University's MySchool system for testing.

###Todo
* ~~Support for repeating classes week after week untill end of semester~~
* Test with older versions of Chrome
* Test with more applications than just Google Calendar and iCal
* And a lot of other stuff..

Licence
-------
This software is protected under the Simplified BSD License.  
Author: Sveinn Fannar Kristjánsson, sveinnfannar@gmail.com

[1]: http://en.wikipedia.org/wiki/ICalendar
[2]: http://coffeescript.org/
