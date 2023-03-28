import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class Galaxy4GarminView extends WatchUi.WatchFace {

    var altTzUTC;

    function initialize() {
        WatchFace.initialize();

        if (Storage.getValue(2) == null){Storage.setValue(2, [-5, "New York"]);}
        if (Storage.getValue(3) == null){Storage.setValue(3, [-5, "New York"]);}
        if (Storage.getValue(4) == null){Storage.setValue(4, [-8, "Seattle"]);}
        if (Storage.getValue(5) == null){Storage.setValue(5, [9, "Tokyo"]);}

        altTzUTC = Storage.getValue(2);
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
        var centerline = View.findDrawableById("CenterLabel") as Text;
        centerline.setText("_________________________________________");
        var localTime = View.findDrawableById("ZoneLabel") as Text;
        localTime.setText("Local");
        var zone2 = View.findDrawableById("Zone2Label") as Text;
        zone2.setText(altTzUTC[1]);

        var time2 = View.findDrawableById("Time2Label") as Text;
        var date2 = View.findDrawableById("Date2Label") as Text;

        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var gregorianInfo = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var monthLong = gregorianInfo.month;
        var dayLong = gregorianInfo.day_of_week;
        var hourG = gregorianInfo.hour;
        var dayShort = Gregorian.info(Time.now(), Time.FORMAT_SHORT).day;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }

        // Set UTC
        var utcOffset = new Time.Duration(-System.getClockTime().timeZoneOffset);
        var altTzOffset = utcOffset.add(new Time.Duration(Gregorian.SECONDS_PER_HOUR * altTzUTC[0]));
        var utc = Gregorian.info(Time.now().add(utcOffset), Time.FORMAT_SHORT);
        var altTz = Gregorian.info(Time.now().add(altTzOffset), Time.FORMAT_SHORT);
        var altTzDay = Gregorian.info(Time.now().add(altTzOffset), Time.FORMAT_LONG);

        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(timeString);
        var day = View.findDrawableById("DateLabel") as Text;
        day.setColor(getApp().getProperty("ForegroundColor") as Number);
        timeString = Lang.format("$1$, $2$ $3$", [dayLong, monthLong, dayShort]);
        day.setText(timeString);
        
        time2.setText(Lang.format("$1$:$2$", [altTz.hour.format("%02d"), clockTime.min.format("%02d")]));
        date2.setText(Lang.format("$1$, $2$ $3$", [altTzDay.day_of_week, altTzDay.month, altTz.day]));

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
