//
//  LocationNotificationSchedulerDelegate.swift
//  LocationNotifier
//
//  Created by Mian Miftah on 4/20/2021.
//

import UserNotifications

protocol LocationNotificationSchedulerDelegate: UNUserNotificationCenterDelegate {
    
    /// Called when the user has denied the notification permission prompt.
    func notificationPermissionDenied()
    
    /// Called when the user has denied the location permission prompt.
    func locationPermissionDenied()
    
    /// Called when the notification request completed.
    ///
    /// - Parameter error: Optional error when trying to add the notification.
    func notificationScheduled(error: Error?)
}
