import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Position;
import Toybox.WatchUi;

class HeroSetRunView extends WatchUi.View {

    private var _session;
    private var _recording = false;
    private var _confirming = false;
    private var _distance = 0.0;

    function initialize() {
        View.initialize();
    }

    function onShow() as Void {
        if (_session == null) {
            startRun();
        } else if (_recording) {
            enableLocation();
        }
    }

    function onHide() as Void {
        if (_confirming) {
            // A save/discard dialog sits on top; the dialog delegate decides.
        } else {
            abortSession(); // app backgrounded or the view is gone without a commit
        }
        if (Position has :enableLocationEvents) {
            Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        }
    }

    function finishRun() as Void {
        updateDistance();
        if (_session != null && _recording) {
            try { _session.stop(); _session.save(); } catch (e) {}
        }
        if (_distance > 0.0) {
            getApp().getStore().addRunDistanceKm(_distance);
        }
        _recording = false;
        _confirming = false;
    }

    function discardRun() as Void {
        if (_session != null && _recording) {
            try {
                _session.stop();
                if (_session has :discard) { _session.discard(); }
            } catch (e) {}
        }
        _recording = false;
        _confirming = false;
    }

    function abortSession() as Void {
        try { if (_session != null) { _session.stop(); } } catch (e) {}
        _recording = false;
    }

    function askSaveOrDiscard() as Void {
        _confirming = true;
        WatchUi.pushView(new WatchUi.Confirmation("Save run?"), new HeroSetRunConfirmDelegate(self), WatchUi.SLIDE_UP);
    }

    function isRecording() as Lang.Boolean {
        return _recording;
    }

    private function startRun() as Void {
        if (!(Toybox has :ActivityRecording)) {
            return;
        }

        try {
            _session = ActivityRecording.createSession({
                :name => "Hero Run",
                :sport => Activity.SPORT_RUNNING,
                :subSport => Activity.SUB_SPORT_GENERIC
            });
            _session.start();
            _recording = true;
            enableLocation();
        } catch (e) {
            _recording = false;
        }
    }

    private function enableLocation() as Void {
        if (Position has :enableLocationEvents) {
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        }
    }

    function onPosition(info as Position.Info) as Void {
        updateDistance();
        WatchUi.requestUpdate();
    }

    private function updateDistance() as Void {
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null && activityInfo.elapsedDistance != null) {
            _distance = activityInfo.elapsedDistance / 1000.0;
        }
    }

    function onUpdate(dc as Dc) as Void {
        updateDistance();
        var layout = new HeroSetLayout(dc);
        var status = _recording ? "GPS RUNNING" : "GPS UNAVAILABLE";

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_SMALL, "PRO RUN", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(1), Graphics.FONT_LARGE, formatDistance(_distance) + " KM", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(2), Graphics.FONT_SMALL, "GOAL 10.00 KM", Graphics.TEXT_JUSTIFY_CENTER);

        var barY = layout.bandTop(3);
        var left = layout.leftInset(barY);
        var right = layout.rightInset(barY);
        if (right > left) {
            var fraction = _distance >= 10.0 ? 1.0 : _distance / 10.0;
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
            dc.fillRectangle(left, barY, ((right - left) * fraction).toNumber(), layout.shortInset() / 6);
        }

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.footerRowTop(), Graphics.FONT_XTINY, status, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(layout.centerX(), layout.footerRowBottom(), Graphics.FONT_XTINY, "SELECT/MENU: SAVE", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function formatDistance(distance as Lang.Float) as Lang.String {
        var shownDistance = distance < 0.0 ? 0.0 : distance;
        var tenths = (shownDistance * 10.0).toNumber();
        return (tenths / 10) + "." + (tenths % 10);
    }
}
