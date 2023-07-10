//
//  Settings.swift
//  pomodoro
//
//  Created by Dias on 08/07/23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var timer: TimerSettings;
    var action: () -> Void
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Active")
                HStack {
                    TextField("hour", text: $timer.hourActive)
                        .frame(width: 36.0)
                    TextField("minute", text: $timer.minutesActive)
                        .frame(width: 36.0)
                }
                Text("Resting")
                HStack {
                    TextField("hour", text: $timer.hourResting)
                        .frame(width: 36.0)
                    TextField("minute", text: $timer.minutesResting)
                        .frame(width: 36.0)
                }
            }.padding()
            .multilineTextAlignment(.leading)
            Button("Ready!", action: {
                action()
            })
        }.padding(20)
    }
}

struct Settings_Previews: PreviewProvider {
    @StateObject static var timer = TimerSettings()
    static var previews: some View {
        SettingsView(
            timer: timer, action: {}
        )
    }
}
