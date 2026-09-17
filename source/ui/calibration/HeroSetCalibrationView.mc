import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.WatchUi;

// Calibration records counted cycles with the provisional SAMPLE_* thresholds,
// then fits per-exercise arm/release thresholds from the mean cycle excursion.
class HeroSetCalibrationView extends WatchUi.View {
    private var _exercise;
    private var _label;
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
        _label = HeroSetText.exerciseLabel(exercise);
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
                HeroSetHaptics.rep();
                WatchUi.requestUpdate();
                if (_cycles >= HeroSetConfig.CALIBRATION_REQUIRED_CYCLES) {
                    finishCalibration();
                    break;
                }
            }
        }
    }

    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_SMALL, HeroSetText.load(Rez.Strings.calibration_title), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(layout.centerX(), layout.bandTop(1), Graphics.FONT_SMALL, _label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(_recording ? Graphics.COLOR_YELLOW : (_saved ? Graphics.COLOR_GREEN : Graphics.COLOR_WHITE), Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(2), Graphics.FONT_LARGE, repsText(), Graphics.TEXT_JUSTIFY_CENTER);

        var status = statusText();
        var statusY = layout.bandTop(3);
        var fonts = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Lang.Array<Graphics.FontDefinition>;
        dc.setColor(_rejected ? Graphics.COLOR_RED : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), statusY, HeroSetDraw.largestFont(dc, layout, statusY, status, fonts), status, Graphics.TEXT_JUSTIFY_CENTER);
        HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), statusY, HeroSetText.load(actionId()));
    }

    // After a rejection the count stays on screen so the reason below it
    // (too few vs. weak) is visibly backed by the number.
    private function repsText() as Lang.String {
        if (_saved) {
            return HeroSetText.format(Rez.Strings.calibration_reps_saved, [HeroSetConfig.CALIBRATION_REQUIRED_CYCLES]);
        }
        return HeroSetText.format(Rez.Strings.calibration_reps_progress, [_cycles, HeroSetConfig.CALIBRATION_REQUIRED_CYCLES]);
    }

    // isUsable needs the full cycle count, and reaching it auto-finishes —
    // so stopping early can never succeed. Name that failure separately
    // from a full session whose signal was too weak, since the fixes differ
    // (finish the reps vs. move the watch / exaggerate the movement).
    private function statusText() as Lang.String {
        if (_recording) {
            return HeroSetText.load(Rez.Strings.calibration_status_recording);
        }
        if (_saved) {
            return HeroSetText.load(Rez.Strings.calibration_status_saved);
        }
        if (!_rejected) {
            return HeroSetText.load(Rez.Strings.calibration_status_ready);
        }
        if (_cycles < HeroSetConfig.CALIBRATION_REQUIRED_CYCLES) {
            return HeroSetText.format(Rez.Strings.calibration_status_too_few, [_cycles, HeroSetConfig.CALIBRATION_REQUIRED_CYCLES]);
        }
        return HeroSetText.load(Rez.Strings.calibration_status_weak);
    }

    // While recording, Select can only abandon the session (see statusText),
    // so it is labelled as a stop, not a finish.
    private function actionId() as Lang.ResourceId {
        if (_recording) {
            return Rez.Strings.calibration_action_stop;
        }
        return _saved ? Rez.Strings.calibration_action_again : Rez.Strings.calibration_action_start;
    }
}
