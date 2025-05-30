//
//  NotificationPermissionManager.swift
//  movida-app
//
//  Created by Bagus Subagja on 29/05/25.
//


import UserNotifications

final class NotificationPermissionManager {
    static let shared = NotificationPermissionManager()

    private init() {}

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Permission error: \(error.localizedDescription)")
                }
                completion(granted)
            }
        }
    }
}
