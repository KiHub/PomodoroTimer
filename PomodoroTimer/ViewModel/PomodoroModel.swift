//
//  PomodoroModel.swift
//  PomodoroTimer
//
//  Created by  Mr.Ki on 05.06.2022.
//

import SwiftUI

class PomodoroModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
  
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    @Published var hour: Int = 0
    @Published var minute: Int = 0
    @Published var seconds: Int = 0
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var isFinished: Bool = false
    
    
    //MARK: - NSObject
    override init() {
            super.init()
        self.authorizeNotification()
        }
    
    
    //MARK: - Notification request
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
        }
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    
    //MARK: - Start timer
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)){
            isStarted = true
            //MARK: - Settting string timer
            timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minute >= 10 ? "\(minute)":"0\(minute)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
            //MARK: - Calculating total seconds
            totalSeconds = (hour * 3600) + (minute * 60) + seconds
            staticTotalSeconds = totalSeconds
            addNewTimer = false
        }
    }
    
    //MARK: - Stop timer
    func stopTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minute = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    //MARK: - Update timer
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        hour = totalSeconds / 3600
        minute = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minute >= 10 ? "\(minute)":"0\(minute)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        if hour == 0 && seconds == 0 && minute == 0 {
            isStarted = false
            print("Timer finished")
            isFinished = true
            addNotification()
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro focus timer"
        content.subtitle = "👏That's great!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
        
    }
}

