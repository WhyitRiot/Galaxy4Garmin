import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class Garmin2TimeZonesView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;

         // Time2Label
        var utcOffset = new Time.Duration(-System.getClockTime().timeZoneOffset);
        var altTZUTC = getApp().getProperty("UTCOffset") as Number;
        if (getApp().getProperty("DayLightSavings")){
            altTZUTC += 1;
        }
        var altTzOffset = utcOffset.add(new Time.Duration(Gregorian.SECONDS_PER_HOUR * altTZUTC));
        var utc = Gregorian.info(Time.now().add(utcOffset), Time.FORMAT_SHORT);
        var altTz = Gregorian.info(Time.now().add(altTzOffset), Time.FORMAT_SHORT);
        var altTzDay = Gregorian.info(Time.now().add(altTzOffset), Time.FORMAT_LONG);
        var altTzHour = altTz.hour;
        var twelveHour = false;
        var meridiem = "am";

        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12 or altTzHour > 12) {
                if (hours > 12){
                    hours = hours - 12;
                    meridiem = "pm";
                }
                if (altTzHour > 12){
                    altTzHour = altTzHour - 12;
                    meridiem = "am";
                }
                twelveHour = true;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
            }
            hours = hours.format("%02d");
            altTzHour = altTzHour.format("%02d");
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        var altTimeString = Lang.format(timeFormat, [altTzHour, clockTime.min.format("%02d")]);

        // Update the view

        var gregorianInfo = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var monthLong = gregorianInfo.month;
        var dayLong = gregorianInfo.day_of_week;
        var hourG = gregorianInfo.hour;
        var dayShort = Gregorian.info(Time.now(), Time.FORMAT_SHORT).day;

        // Set the labels and centerline
        var centerline = View.findDrawableById("CenterLabel") as Text;
        centerline.setText("_________________________________________");
        var localTime = View.findDrawableById("ZoneLabel") as Text;
        localTime.setText("Local");
        var day = View.findDrawableById("DateLabel") as Text;

        day.setColor(getApp().getProperty("ForegroundColor") as Number);
        day.setText(Lang.format("$1$, $2$ $3$", [dayLong, monthLong, dayShort]));

        var zone2 = View.findDrawableById("Zone2Label") as Text;
        zone2.setText(getApp().getProperty("TimeZone"));

        var time2 = View.findDrawableById("Time2Label") as Text;
        var date2 = View.findDrawableById("Date2Label") as Text;

        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(timeString);

        view = View.findDrawableById("Time2Label") as Text;
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(altTimeString);
        view = View.findDrawableById("Date2Label") as Text;
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(Lang.format("$1$, $2$ $3$", [altTzDay.day_of_week, altTzDay.month, altTz.day]));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}