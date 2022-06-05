//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by  Mr.Ki on 05.06.2022.
//

import SwiftUI

@main
struct PomodoroTimerApp: App {
    
    @StateObject var pomodoroModel: PomodoroModel = .init()
    @Environment(\.scenePhase) var phase
    @State var lastActiveTimeStamp: Date = Date()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroModel)
        }
        .onChange(of: phase) { newValue in
            if pomodoroModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                if newValue == .active {
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                    } else {
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}
