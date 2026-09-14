import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.WatchUi;

// Calibration records counted cycles with the provisional SAMPLE_* thresholds,
// then fits per-exercise arm/release thresholds from the mean cycle excursion.
class HeroSetCalibrationView extends WatchUi.View {
    private var _exercise;
    private var _sensorManager;
    private var _recording = false;
    private var _saved = false;
    private var _rejected = false;
    private var _cycles = 0;
    private var _peakSum = 0.0;
    private var _valleySum = 0.0;
    private var _counter;

    function initialize(exercise as Lang.Symbol) {
        View.initialize();
        _exercise = exercise;
        _counter = new HeroSetRepCounter(
            HeroSetConfig.CALIBRATION_SAMPLE_ARM,
            HeroSetConfig.CALIBRATION_SAMPLE_RELEASE,
            HeroSetConfig.SENSOR_SAMPLE_RATE,
            HeroSetConfig.SENSOR_COOLDOWN_MS
        );
        _sensorManager = new HeroSetSensorManager();
    }

    function onShow() as Void {
        WatchUi.requestUpdate();
    }

    function onHide() as Void {
        disableSensors();
    }

    function toggleCalibration() as Void {
        if (_recording) {
            finishCalibration();
        } else {
            startCalibration();
        }
    }

    private function startCalibration() as Void {
        _saved = false;
        _rejected = false;
        _cycles = 0;
        _peakSum = 0.0;
        _valleySum = 0.0;
        _counter.reset();
        _recording = true;
        enableSensors();
        WatchUi.requestUpdate();
    }

    private function finishCalibration() as Void {
        disableSensors();
        _recording = false;
        if (_cycles == 0) {
            _rejected = true;
        } else {
            var meanPeak = (_peakSum / _cycles).toNumber();
            var meanValley = (_valleySum / _cycles).toNumber();
            if (HeroSetCalibration.isUsable(_cycles, meanPeak, meanValley)) {
                var arm = HeroSetCalibration.armThresholdFrom(meanPeak.toNumber(), meanValley.toNumber());
                var release = HeroSetCalibration.releaseThresholdFrom(meanPeak.toNumber(), meanValley.toNumber());
                getApp().getStore().setCalibrationProfile(_exercise, arm, release, HeroSetConfig.SENSOR_SAMPLE_RATE, HeroSetConfig.SENSOR_COOLDOWN_MS);
                _saved = true;
            } else {
                _rejected = true;
            }
        }
        WatchUi.requestUpdate();
    }

    private function enableSensors() as Void {
        _sensorManager.start(method(:onSensorData), HeroSetConfig.SENSOR_SAMPLE_RATE);
    }

    private function disableSensors() as Void {
        _sensorManager.stop();
    }

    // Public, `method(:onSensorData)` binding (ADR-023) — see HeroSetWorkoutView.
    public function onSensorData(data as Sensor.SensorData) as Void {
        if (!_recording || data == null || data.accelerometerData == null) {
            return;
        }
        var x = data.accelerometerData.x;
        var y = data.accelerometerData.y;
        var z = data.accelerometerData.z;
        if (!(x instanceof Array) || !(y instanceof Array) || !(z instanceof Array)) {
            return;
        }
        for (var i = 0; i < x.size(); i++) {
            if (_counter.feedSample(x[i], y[i], z[i])) {
                _cycles += 1;
                _peakSum += _counter.getLastCyclePeak();
                _valleySum += _counter.getLastCycleValley();
                vibrateForRep();
                WatchUi.requestUpdate();
                if (_cycles >= HeroSetConfig.CALIBRATION_REQUIRED_CYCLES) {
                    finishCalibration();
                    break;
                }
            }
        }
    }

    // Tactile confirmation per cycle — same rationale as HeroSetWorkoutView.
    private function vibrateForRep() as Void {
        if (Attention has :vibrate) {
            Attention.vibrate([new Attention.VibeProfile(HeroSetConfig.REP_VIBE_DUTY_CYCLE, HeroSetConfig.REP_VIBE_DURATION_MS)]);
        }
    }

    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        var label = _exercise == :pushups ? "PUSH-UPS" : (_exercise == :situps ? "SIT-UPS" : "SQUATS");
        var status = _recording ? "DO YOUR REPS" : (_saved ? "SAVED" : (_rejected ? "WEAK SIGNAL — RETRY" : "READY"));
        var action = _recording ? "SEL/MENU: FINISH" : (_saved ? "SEL/MENU: AGAIN" : "SEL/MENU: START");
        var repsText = _recording ? _cycles + " / " + HeroSetConfig.CALIBRATION_REQUIRED_CYCLES : (_saved ? HeroSetConfig.CALIBRATION_REQUIRED_CYCLES + " REPS" : "0 / " + HeroSetConfig.CALIBRATION_REQUIRED_CYCLES);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_SMALL, "CALIBRATE", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(layout.centerX(), layout.bandTop(1), Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(_recording ? Graphics.COLOR_YELLOW : (_saved ? Graphics.COLOR_GREEN : Graphics.COLOR_WHITE), Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(2), Graphics.FONT_LARGE, repsText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(3), Graphics.FONT_SMALL, status, Graphics.TEXT_JUSTIFY_CENTER);

        // Shift the footer hint up off the bezel if it wouldn't otherwise
        // fit the round chord at its natural row (measured against the real
        // rendered width, not a guessed character budget).
        var actionWidth = dc.getTextWidthInPixels(action, Graphics.FONT_XTINY);
        var actionHeight = dc.getFontHeight(Graphics.FONT_XTINY);
        var actionY = layout.fitCenteredY(layout.footerRowBottom(), layout.bandTop(3), actionWidth, actionHeight);
        dc.drawText(layout.centerX(), actionY, Graphics.FONT_XTINY, action, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
