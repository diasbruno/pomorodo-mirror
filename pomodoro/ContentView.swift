//
//  ContentView.swift
//  pomodoro
//
//  Created by Dias on 08/07/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var controller: TimerController;
    
    var body: some View {
        switch (controller.viewState) {
        case .settings(let c):
            SettingsView(timer: c, action: {
                controller.configured()
            })
        case .timer(let timer):
            TimerView(
                timer: timer,
                startAction: { timer.start() },
                stopAction: { timer.stop() },
                changeAction: { timer.change() },
                configureAction: { controller.configure() })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var timer: TimerController = TimerController()
    
    static var previews: some View {
        ContentView(controller: timer)
    }
}
