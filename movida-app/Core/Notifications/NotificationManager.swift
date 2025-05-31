//
//  NotificationManager.swift
//  movida-app
//
//  Created by Bagus Subagja on 29/05/25.
//


import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hello from SwiftUI"
        content.body = "This is a local notification example."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled")
            }
        }
    }
}
