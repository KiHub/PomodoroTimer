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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroModel)
        }
    }
}
