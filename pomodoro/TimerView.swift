//
//  Timer.swift
//  pomodoro
//
//  Created by Dias on 08/07/23.
//

import SwiftUI

struct TimerView: View {
    static let runningColor = Color.accentColor;
    
    static let stoppedColor = Color.white;
    
    @StateObject var timer: RunningTimer;
    var startAction: () -> Void;
    var stopAction: () -> Void;
    var changeAction: () -> Void;
    var configureAction: () -> Void;
    
    var body: some View {
        let c = timer.isRunning() ?
            TimerView.runningColor :
            TimerView.stoppedColor;
        
        VStack {
            Text(timer.label)
                .foregroundColor(c)
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))
            Text(timer.toDisplayDecrement)
                .frame(width: 120)
                .foregroundColor(c)
                .font(Font.title)
                .padding()
            switch (timer.runningState) {
            case .stopped:
                Button("Start", action: {
                    startAction()
                })
                Button("Configure", action: {
                    configureAction()
                })
            case .running:
                HStack {
                    Button("Stop", action: {
                        stopAction()
                    })
                }
            case .done:
                Button("Change", action: {
                    changeAction()
                })
            }
        }
        .padding()
    }
}

struct Timer_Previews: PreviewProvider {
    @StateObject static var timer: RunningTimer = RunningTimer.fromConfiguration(TimerSettings())
    
    static var previews: some View {
        TimerView(
            timer: timer,
            startAction: {},
            stopAction: {},
            changeAction: {},
            configureAction: {}
        )
    }
}
