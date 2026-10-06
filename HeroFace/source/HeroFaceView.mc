import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// The face: gather one HeroFaceState, then draw it. Awake it is HeroSet's
// dashboard around a clock; asleep on AMOLED it is only a dim, drifting time
// to respect burn-in limits; asleep on MIP it stays the full face.
class HeroFaceView extends WatchUi.WatchFace {

    private var _settings as HeroFaceSettings;
    private var _kinds as Array<Number>;
    private var _streak as HeroFaceStreak;
    private var _link as HeroFaceLink;
    private var _layout as HeroFaceLayout?;
    private var _sleeping as Boolean = false;
    private var _burnIn as Boolean;
    // [x, y, width, height] of the seconds, for low-power partial updates.
    // Pro only: Free draws no seconds (docs/decisions.md ADR-001, the Free + Pro ladder).
    (:pro)
    private var _secondsBox as Array<Number>?;
    // Last gathered frame, reused until the minute (or the data behind it)
    // changes: reading activity, weather and history every second costs
    // battery for values that cannot have moved.
    private var _state as HeroFaceState?;
    private var _stateMinute as Number = -1;
    private var _stateLink as Number = -1;

    function initialize(link as HeroFaceLink) {
        WatchFace.initialize();
        _link = link;
        _streak = new HeroFaceStreak();
        _settings = new HeroFaceSettings();
        _kinds = HeroFaceMetrics.resolve(_settings.slots, ActivityMonitor.getInfo());
        var device = System.getDeviceSettings();
        _burnIn = (device has :requiresBurnInProtection) && device.requiresBurnInProtection;
    }

    function reloadSettings() as Void {
        _settings = new HeroFaceSettings();
        _kinds = HeroFaceMetrics.resolve(_settings.slots, ActivityMonitor.getInfo());
        _state = null;
    }

    // The watch stopped granting the partial-update budget: stop promising
    // seconds until the next settings change. Pro only, like every seconds path
    // that touches the system (docs/decisions.md ADR-001, the Free + Pro ladder).
    (:pro)
    function disableSeconds() as Void {
        _settings.seconds = false;
        _secondsBox = null;
        _state = null;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        _layout = new HeroFaceLayout(dc);
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var layout = _layout;
        if (layout == null) {
            return;
        }
        if (_sleeping && _burnIn) {
            rememberSeconds(null);
            _state = null;
            HeroFaceSleep.draw(dc, layout);
            return;
        }
        drawState(dc, layout, frameFor(System.getClockTime()));
    }

    // One gathered frame per minute; in between, only the seconds are refreshed
    // on the frame already in hand.
    private function frameFor(clock as System.ClockTime) as HeroFaceState {
        var state = _state;
        if (state == null || clock.min != _stateMinute || _link.version() != _stateLink) {
            if (!_link.isLinked()) {
                _link.start();
            }
            state = HeroFaceReadings.take(_settings, _kinds, _streak, _link, _settings.seconds);
            _state = state;
            _stateMinute = clock.min;
            _stateLink = _link.version();
            return state;
        }
        state.seconds = _settings.seconds ? clock.sec.format("%02d") : null;
        return state;
    }

    // Pure drawing, shared with the screen-fit test.
    function drawState(dc as Graphics.Dc, layout as HeroFaceLayout, state as HeroFaceState) as Void {
        dc.setColor(HeroFacePalette.TEXT, HeroFacePalette.BACKGROUND);
        dc.clear();
        HeroFaceRing.draw(dc, layout, state.ringPermille, state.ringColor);
        drawDate(dc, layout, state);
        rememberSeconds(HeroFaceClock.draw(dc, layout, state));
        drawUnderTime(dc, layout, state);
        HeroFaceMissions.draw(dc, layout, state);
        HeroFaceFooter.draw(dc, layout, state);
    }

    (:pro)
    private function rememberSeconds(box as Array<Number>?) as Void {
        _secondsBox = box;
    }

    (:free)
    private function rememberSeconds(box as Array<Number>?) as Void {
    }

    // Seconds while the rest of the face sleeps (MIP, or AMOLED without
    // burn-in rules): redraw only the seconds' box, within the power budget.
    // Pro only: the Free face has no seconds, and a face that defines this is
    // woken every second in low power for nothing.
    (:pro)
    function onPartialUpdate(dc as Graphics.Dc) as Void {
        var box = _secondsBox;
        var layout = _layout;
        if (box == null || layout == null || !_settings.seconds) {
            return;
        }
        dc.setClip(box[0], box[1], box[2], box[3]);
        dc.setColor(HeroFacePalette.MUTED, HeroFacePalette.BACKGROUND);
        dc.clear();
        dc.drawText(box[0], box[1], Graphics.FONT_XTINY, System.getClockTime().sec.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT);
        dc.clearClip();
    }

    // The date takes the narrow row inside the ring's top: it is always there,
    // so the row is never empty.
    private function drawDate(dc as Graphics.Dc, layout as HeroFaceLayout, state as HeroFaceState) as Void {
        var y = layout.topRowTop;
        var text = HeroFaceDraw.firstFitting(dc, layout, layout.contentRadius(), 0, y, Graphics.FONT_XTINY, state.dateLines);
        dc.setColor(HeroFacePalette.MUTED, Graphics.COLOR_TRANSPARENT);
        HeroFaceDraw.text(dc, layout, layout.rowCenterX(y, dc.getFontHeight(Graphics.FONT_XTINY)), y, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // The wide row under the time carries the streak and the temperature as one centred group (streak, a gap, the
    // temperature), so the temperature stays put whether or not a streak shows (design critique 2026-10-05, ROADMAP
    // 13.8). A group too wide takes a shorter streak wording that still says the streak; if none fits beside the
    // temperature, the temperature drops and the streak takes its longest wording that fits alone. The gold streak
    // (kept and losable) outranks the optional temperature, so HeroSet's rank-only line is never chosen to keep it.
    private function drawUnderTime(dc as Graphics.Dc, layout as HeroFaceLayout, state as HeroFaceState) as Void {
        var y = layout.underTimeTop;
        var line = dc.getFontHeight(Graphics.FONT_XTINY);
        var room = layout.rightInsetWithin(layout.contentRadius(), y, line) - layout.leftInsetWithin(layout.contentRadius(), y, line);
        // Beside the Instinct's window there is one narrow band: the streak, no temperature (ADR-002).
        var temperature = layout.subscreen() == null ? state.temperature : null;
        var streak = state.streakLines.size() > 0
            ? HeroFaceDraw.firstFitting(dc, layout, layout.contentRadius(), 0, y, Graphics.FONT_XTINY, state.streakLines)
            : null;
        if (streak != null && temperature != null && groupWidth(dc, layout, streak, temperature) > room) {
            var lines = state.streakLines;
            var beside = null as String?;
            for (var i = 0; i < lines.size() - (state.streakLastDropsStreak ? 1 : 0) && beside == null; i++) {
                if (groupWidth(dc, layout, lines[i], temperature) <= room) {
                    beside = lines[i];
                }
            }
            if (beside != null) {
                streak = beside;
            } else {
                temperature = null;
            }
        }
        if (streak != null && layout.subscreen() != null) {
            streak = HeroFaceDraw.truncated(dc, streak, Graphics.FONT_XTINY, layout.rightInset(y, line) - layout.leftInset(y, line));
        }
        var left = layout.rowCenterX(y, line) - groupWidth(dc, layout, streak, temperature) / 2;
        if (streak != null) {
            drawStreakText(dc, layout, left, y, streak, state, Graphics.TEXT_JUSTIFY_LEFT);
            left += dc.getTextWidthInPixels(streak, Graphics.FONT_XTINY) + layout.columnGap();
        }
        if (temperature != null) {
            dc.setColor(HeroFacePalette.MUTED, Graphics.COLOR_TRANSPARENT);
            HeroFaceDraw.text(dc, layout, left, y, Graphics.FONT_XTINY, temperature, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    private function groupWidth(dc as Graphics.Dc, layout as HeroFaceLayout, streak as String?, temperature as String?) as Number {
        var width = streak != null ? dc.getTextWidthInPixels(streak, Graphics.FONT_XTINY) : 0;
        if (temperature != null) {
            width += dc.getTextWidthInPixels(temperature, Graphics.FONT_XTINY) + (streak != null ? layout.columnGap() : 0);
        }
        return width;
    }

    private function drawStreakText(dc as Graphics.Dc, layout as HeroFaceLayout, x as Number, y as Number, text as String, state as HeroFaceState, justify as Graphics.TextJustification) as Void {
        dc.setColor(state.streakKept ? HeroFacePalette.GOLD : HeroFacePalette.MUTED, Graphics.COLOR_TRANSPARENT);
        HeroFaceDraw.text(dc, layout, x, y, Graphics.FONT_XTINY, text, justify);
    }

    function onEnterSleep() as Void {
        _sleeping = true;
        WatchUi.requestUpdate();
    }

    function onExitSleep() as Void {
        _sleeping = false;
        WatchUi.requestUpdate();
    }
}
