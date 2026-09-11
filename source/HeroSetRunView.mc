import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Position;
import Toybox.WatchUi;

class HeroSetRunView extends WatchUi.View {

    private var _session;
    private var _recording = false;
    private var _distance = 0.0;

    function initialize() {
        View.initialize();
    }

    function onShow() as Void {
        startRun();
    }

    function onHide() as Void {
        if (Position has :disableLocationEvents) {
            Position.disableLocationEvents();
        }
    }

    function finishRun() as Void {
        updateDistance();
        if (_session != null && _recording) {
            _session.stop();
            _session.save();
        }
        if (_distance > 0) {
            getApp().getStore().addRunDistance(_distance);
            getApp().getStore().add(:pushups, 0);
        }
        _recording = false;
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
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        } catch (e) {
            _recording = false;
        }
    }

    private function onPosition(info as Position.Info) as Void {
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
        var width = dc.getWidth();
        var status = _recording ? "GPS RUNNING" : "GPS UNAVAILABLE";

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(width / 2, 16, Graphics.FONT_SMALL, "PRO RUN", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, 50, Graphics.FONT_LARGE, _distance + " KM", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, 108, Graphics.FONT_SMALL, "GOAL 10.00 KM", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(_distance >= 10.0 ? Graphics.COLOR_GREEN : Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.fillRectangle(18, 138, (width - 36) * (_distance > 10.0 ? 1.0 : _distance / 10.0), 8);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, dc.getHeight() - 28, Graphics.FONT_XTINY, status, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, dc.getHeight() - 12, Graphics.FONT_XTINY, "SELECT: FINISH", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
