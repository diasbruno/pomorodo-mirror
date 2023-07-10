//
//  pomodoroApp.swift
//  pomodoro
//
//  Created by Dias on 08/07/23.
//

import SwiftUI

let defaultHA = "00";
let defaultMA = "45";
let defaultHR = "00";
let defaultMR = "15";

class TimerSettings: ObservableObject {
    @Published var hourActive: String = defaultHA;
    @Published var minutesActive: String = defaultMA;
    @Published var hourResting: String = defaultHR;
    @Published var minutesResting: String = defaultMR;
}

enum RunningState {
    case stopped
    case running
    case done
}

enum TimerObjectKey {
    case active
    case resting
}

struct TimerObject {
    static func fromHoursAndMinutesString(_ key: TimerObjectKey, _ hours: String, _ minutes: String) -> TimerObject {
        let hs = Int(hours) ?? 0;
        let min = Int(minutes) ?? 0;
        let secs = hs * 3600 + min * 60;
        
        return TimerObject(key: key, hours: hs, minutes: min, seconds: secs);
    }
    
    let key: TimerObjectKey;
    let hours: Int;
    let minutes: Int;
    let seconds: Int;
}



class RunningTimer: ObservableObject {
    var timer: Timer?
    
    var toDisplayIncrement: String = "00:00";
    var toDisplayDecrement: String = "00:00";
    
    var activeTimerObject: TimerObject;
    var restingTimerObject: TimerObject;
    
    @Published var currentTimerObject: TimerObject;
    @Published var label: String = "";
    @Published var elapsedSeconds: Int = 0;
    @Published var runningState: RunningState = .stopped;
    
    static func fromConfiguration(_ configuration: TimerSettings) -> RunningTimer {
        return RunningTimer(
            active: TimerObject.fromHoursAndMinutesString(.active, configuration.hourActive, configuration.minutesActive),
            resting: TimerObject.fromHoursAndMinutesString(.resting, configuration.hourResting, configuration.minutesResting)
        );
    }
    
    init(active activeSeconds: TimerObject, resting restingSeconds: TimerObject) {
        activeTimerObject = activeSeconds;
        restingTimerObject = restingSeconds;
        
        currentTimerObject = activeTimerObject;
        label = "Active";
        updateDisplayDecrement(elapsedSeconds)
    }
    
    func isRunning() -> Bool {
        return runningState == .running;
    }
    
    func toClockString(x: Int) -> String {
        return (x < 10 ? "0" : "") + String(x)
    }
    
    func updateDisplayDecrement(_ elapsedSeconds: Int) {
        let countingDown = currentTimerObject.seconds - elapsedSeconds;
        let h = countingDown / 3600
        let m = (countingDown - h * 3600) / 60
        let s = countingDown - h * 3600 - m * 60
        
        if (countingDown < 0) {
            runningState = .done;
        } else {
            toDisplayDecrement = "\(toClockString(x: h)):\(toClockString(x: m)):\(toClockString(x: s))";
        }
    }
    
    func updateDisplayIncrement(_ elapsedSeconds: Int) {
        toDisplayIncrement = "\(toClockString(x: elapsedSeconds / 3600)):\(toClockString(x: elapsedSeconds / 60))";
    }
    
    @objc func onTimer() {
        if isRunning() {
            elapsedSeconds += 1;
            updateDisplayDecrement(elapsedSeconds)
        }
    }
    
    func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        }
        runningState = .running;
    }
    
    func stop() {
        runningState = .stopped;
    }
    
    func change() {
        if currentTimerObject.key == .active {
            currentTimerObject = restingTimerObject;
            label = "Resting";
        } else {
            currentTimerObject = activeTimerObject;
            label = "Active";
        }
        elapsedSeconds = 0;
        updateDisplayDecrement(elapsedSeconds);
        runningState = .stopped;
    }
}

enum CurrentView {
    case settings(TimerSettings)
    case timer(RunningTimer)
}

class TimerController: ObservableObject {
    @Published var viewState: CurrentView = .settings(TimerSettings());
    
    func configured() {
        switch (viewState) {
        case .settings(let configuration):
            viewState = .timer(RunningTimer.fromConfiguration(configuration));
        case .timer(_): break
        }
    }
    
    func configure() {
        switch (viewState) {
        case .settings(_): break
        case .timer(_):
            viewState = .settings(TimerSettings())
        }
    }
}

@main
struct pomodoroApp: App {
    @StateObject var timer: TimerController = TimerController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(controller: timer)
        }
    }
}
