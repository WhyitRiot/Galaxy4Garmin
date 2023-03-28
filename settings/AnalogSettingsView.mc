//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Application.Storage;

var count=0;

class AnalogSettingsViewTest extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize(null);


//    function onMenu() {
    
	// Add menu items for demonstrating toggles, checkbox and icon menu items
    //menu.addItem(new WatchUi.MenuItem("Toggles", "sublabel", "toggle", null));
    //menu.addItem(new WatchUi.MenuItem("Checkboxes", null, "check", null));
    //menu.addItem(new WatchUi.MenuItem("Icons", null, "icon", null));
    //menu.addItem(new WatchUi.MenuItem("Custom", null, "custom", null));
    //WatchUi.pushView(menu, new AnalogSettingsDelegate(), WatchUi.SLIDE_UP );

    // Generate a new Menu with a drawable Title
    //var menu = new WatchUi.Menu2({:title=>new DrawableMenuTitle()});
    Menu2.setTitle("Time Zone");
    Menu2.addItem(new WatchUi.MenuItem("Time Zones", null, "tz", null));
    //WatchUi.pushView(Menu2, new Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP );	

	}

	function onSelect(item) {
        // For IconMenuItems, we will change to the next icon state.
        // This demonstates a custom toggle operation using icons.
        // Static icons can also be used in this layout.
        if(item instanceof MenuItem){
            
        }

        WatchUi.requestUpdate();
    }    

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return false;
    }  

    function onDone() {
        WatchUi.popView(WatchUi.SLIDE_BLINK);
    }

    function onWrap(key as WatchUi.Key) {
        return true;
    }    

}


class Menu2TestMenu2Delegate extends WatchUi.Menu2InputDelegate { // Sub-menu Design

	function initialize() {
        Menu2InputDelegate.initialize();
    }

	function onSelect(item) {

        if( item.getId().equals("tz") ) {
		    // Generate a new Menu with a Text Title
		    
		    var iconMenu = new WatchUi.Menu2({:title=>"Time Zones"});
		    
		    //ToggleMenuItem(label, subLabel, identifier, enabled, options)
		    iconMenu.addItem(new WatchUi.MenuItem("New York", "UTC -5", Storage.getValue(3), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    iconMenu.addItem(new WatchUi.MenuItem("Seattle", "UTC -8", Storage.getValue(4), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            iconMenu.addItem(new WatchUi.MenuItem("Tokyo", "UTC +9", Storage.getValue(5), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		   /* iconMenu.addItem(new WatchUi.ToggleMenuItem("Alarm Icon", {:enabled=>"ON", :disabled=>"OFF"}, 8, Storage.getValue(8), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));    
            if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) {
		        iconMenu.addItem(new WatchUi.ToggleMenuItem("Hour Labels", {:enabled=>"ON", :disabled=>"OFF"}, 5, Storage.getValue(5), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
            iconMenu.addItem(new WatchUi.ToggleMenuItem("Tickmark Color", {:enabled=>"Accent", :disabled=>"Default"}, 18, Storage.getValue(18), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            if (Storage.getValue(21)[2]){ // has weather
                iconMenu.addItem(new WatchUi.ToggleMenuItem("Location Name", {:enabled=>"ON", :disabled=>"OFF"}, 7, Storage.getValue(7), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
            // allow full colors in AOD for AMOLED devices
            if(System.getDeviceSettings().requiresBurnInProtection){
                iconMenu.addItem(new WatchUi.ToggleMenuItem("AOD Colors", {:enabled=>"Accent", :disabled=>"Grayscale"}, 22, Storage.getValue(22), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
            var drawableT = new CustomThickness();
		    iconMenu.addItem(new WatchUi.IconMenuItem("Hands Thickness", drawableT.getString(), 13, drawableT, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    WatchUi.pushView(iconMenu, new AnalogSettingsViewTest(), WatchUi.SLIDE_BLINK );
        } else if( item.getId().equals("datapoints") ) {
		    var dataMenu = new WatchUi.Menu2({:title=>"Data"});
		    count=0;
		    var drawable2 = new CustomLeftTopDataPoint();
		    var drawable3 = new CustomLeftTopDataPoint();
		    count=0;
		    var drawable4 = new CustomLeftBottomDataPoint();
		    var drawable5 = new CustomLeftBottomDataPoint();
            var drawable6 = new CustomLeftBottomDataPoint();
		    dataMenu.addItem(new WatchUi.IconMenuItem("Left Top", drawable2.getString(), 9, drawable2, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    dataMenu.addItem(new WatchUi.IconMenuItem("Left Middle", drawable3.getString(), 10, drawable3, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    dataMenu.addItem(new WatchUi.IconMenuItem("Left Bottom", drawable4.getString(), 11, drawable4, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            dataMenu.addItem(new WatchUi.IconMenuItem("Right Top", drawable6.getString(), 17, drawable6, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		    dataMenu.addItem(new WatchUi.IconMenuItem("Right Bottom", drawable5.getString(), 12, drawable5, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
		   	if (System.SCREEN_SHAPE_ROUND == System.getDeviceSettings().screenShape) { //check if rounded display
                dataMenu.addItem(new WatchUi.ToggleMenuItem("Font Size", {:enabled=>"Bigger", :disabled=>"Standard"}, 14, Storage.getValue(14), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));      
            }
		    WatchUi.pushView(dataMenu, new AnalogSettingsViewTest(), WatchUi.SLIDE_BLINK );
        } else if( item.getId().equals("units") ) { 
            var checkWeather=Storage.getValue(21)[1]; // has :Weather
            var unitsMenu = new WatchUi.Menu2({:title=>"Units"});
            if (Storage.getValue(21)[0]){
                unitsMenu.addItem(new WatchUi.ToggleMenuItem("Battery Estimate", {:enabled=>"ON", :disabled=>"OFF"}, 19, Storage.getValue(19), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            }
            if (checkWeather and Storage.getValue(21)[2] and Toybox.Weather.getCurrentConditions()!=null){
                if (Toybox.Weather.getCurrentConditions().feelsLikeTemperature!=null and Toybox.Weather.getCurrentConditions().feelsLikeTemperature instanceof Number){
                    unitsMenu.addItem(new WatchUi.ToggleMenuItem("Temp. Type", {:enabled=>"Real Temperature", :disabled=>"Feels Like"}, 6, Storage.getValue(6), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
                }
                unitsMenu.addItem(new WatchUi.ToggleMenuItem("Temp. Unit", {:enabled=>"Always Celsius", :disabled=>"User Settings"}, 16, Storage.getValue(16), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));		    
                unitsMenu.addItem(new WatchUi.ToggleMenuItem("Wind Speed Unit", {:enabled=>"km/h or mph", :disabled=>"m/s"}, 15, Storage.getValue(15), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
                if (Storage.getValue(21)[5]){
                    unitsMenu.addItem(new WatchUi.ToggleMenuItem("Atm. Pres. Type", {:enabled=>"Mean Sea Level", :disabled=>"Local Pressure"}, 20, Storage.getValue(20), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
                }
            }
            var info = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
            unitsMenu.addItem(new WatchUi.ToggleMenuItem("Date Format", {:enabled=>Lang.format("$2$ $1$", [info.month, info.day]), :disabled=>Lang.format("$1$ $2$", [info.month, info.day])}, 24, Storage.getValue(24), {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));    

            WatchUi.pushView(unitsMenu, new AnalogSettingsViewTest(), WatchUi.SLIDE_BLINK );	
	    } else {
            WatchUi.requestUpdate(); */
        } 

	}

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return;
    }  

}