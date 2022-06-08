//
//  PomodoroModel.swift
//  PomodoroTimer
//
//  Created by  Mr.Ki on 05.06.2022.
//

import SwiftUI

class PomodoroModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    
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
    @Published var isFinishedScreen: Bool = false
    
    @Published var staticHour: Int = 0
    @Published var staticMinute: Int = 0
    @Published var staticSeconds: Int = 0
    
    
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
        staticHour = hour
        staticMinute = minute
        staticSeconds = seconds
        
        withAnimation(.easeInOut(duration: 0.25)){
            isStarted = true
            //MARK: - Settting string timer
            timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minute >= 10 ? "\(minute)":"0\(minute)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
            //MARK: - Calculating total seconds
            totalSeconds = (hour * 3600) + (minute * 60) + seconds
            staticTotalSeconds = totalSeconds
            addNewTimer = false
            addNotification()
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
    
    //MARK: - Repeat timer
    
    func repeatPrepare() {
        timerStringValue = "00:00"
        progress = 1
        totalSeconds = staticTotalSeconds
        isStarted = true
        hour = staticHour
        minute = staticMinute
        seconds = staticSeconds
    }
    
    //MARK: - Update timer
    func updateTimer() {
        withAnimation {
            totalSeconds -= 1
            progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
            progress = (progress < 0 ? 0 : progress)
            hour = totalSeconds / 3600
            minute = (totalSeconds / 60) % 60
            seconds = (totalSeconds % 60)
            timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minute >= 10 ? "\(minute)":"0\(minute)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
            if hour == 0 && seconds == 0 && minute == 0 {
               //   addNotification()
                isStarted = false
                print("Timer finished")
                isFinished = true
                isFinishedScreen = true
            }
        }
    }
    
    func addNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Pocus timer"
        content.subtitle = "👏 That's great!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        
        UNUserNotificationCenter.current().add(request)
        afterBlock(seconds: staticTotalSeconds) {
            self.cleanProgress()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() += staticTotalSeconds) {
//            cleanProgress()
//        }
        
    }
    
    func afterBlock(seconds: Int, queue: DispatchQueue = DispatchQueue.global(),
                    completion: @escaping () -> ()) {
        queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            completion()
        }
    }
    
    func cleanProgress() {
        DispatchQueue.main.async {
            self.timerStringValue = "00:00"
            self.progress = 1
            
        }
    }
    
}

