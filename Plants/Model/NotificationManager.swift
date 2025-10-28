//
//  NotificationManager.swift
//  Plants
//
//  Created by Maram Ibrahim  on 06/05/1447 AH.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    // MARK: - Authorization (لا يستدعي تلقائياً — لديك خيار استدعاءه عند الحاجة)
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let err = error {
                print("Notification auth error:", err.localizedDescription)
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    // MARK: - Repeating reminders (existing)
    /// جدول تذكير متكرر (يومي/كل N أيام/أسبوعي)
    /// - daysInterval: 1 => يومي (repeats true using calendar hour/minute),
    ///                 7 => أسبوعي (نفس يوم الأسبوع والساعة),
    ///                 >1 and !=7 => كل N يوم (repeats true using time interval)
    func scheduleReminder(id: UUID,
                          title: String,
                          subtitle: String? = nil,
                          daysInterval: Int = 1,
                          atHour: Int = 9,
                          atMinute: Int = 0) {

        let center = UNUserNotificationCenter.current()

        // إلغاء أي إشعار بنفس الـ id قبل جدولة جديد (تجنُّب التكرار)
        center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])

        // محتوى الإشعار
        let content = UNMutableNotificationContent()
        content.title = title
        if let sub = subtitle { content.body = sub }
        content.sound = .default

        // يومي (repeats true)
        if daysInterval == 1 {
            var dateComponents = DateComponents()
            dateComponents.hour = atHour
            dateComponents.minute = atMinute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let e = error { print("schedule error:", e.localizedDescription) }
            }
            return
        }

        // أسبوعي (نفس weekday)
        if daysInterval == 7 {
            let now = Date()
            let comps = Calendar.current.dateComponents([.weekday], from: now)
            var dateComponents = DateComponents()
            dateComponents.weekday = comps.weekday
            dateComponents.hour = atHour
            dateComponents.minute = atMinute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let e = error { print("schedule error:", e.localizedDescription) }
            }
            return
        }

        // كل N أيام (باستخدام time interval، repeats true). ملاحظة: repeats true يتطلب interval >= 60s
        let interval = TimeInterval(daysInterval * 24 * 60 * 60)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(60, interval), repeats: true)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let e = error { print("schedule error:", e.localizedDescription) }
        }
    }

    // MARK: - One-time reminders (new)
    /// جدولة إشعار لمرة واحدة بعد عدد محدد من الثواني (مثال: بعد 10s)
    func scheduleReminderAfter(id: UUID,
                               title: String,
                               subtitle: String? = nil,
                               after seconds: TimeInterval = 10) {
        let center = UNUserNotificationCenter.current()

        // إزالة أي طلب سابق لنفس المعرف لتجنّب التكرار
        center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])

        let content = UNMutableNotificationContent()
        content.title = title
        if let s = subtitle { content.body = s }
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, seconds), repeats: false)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)

        center.add(request) { error in
            if let e = error {
                print("Error scheduling one-time notification:", e.localizedDescription)
            } else {
                print("Scheduled one-time notification \(id.uuidString) after \(seconds)s")
            }
        }
    }

    /// جدولة إشعار لمرة واحدة عند تاريخ محدد (اختياري)
    func scheduleOneTimeReminder(id: UUID, title: String, subtitle: String? = nil, date: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])

        let content = UNMutableNotificationContent()
        content.title = title
        if let s = subtitle { content.body = s }
        content.sound = .default

        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)

        center.add(request) { error in
            if let e = error {
                print("Error scheduling one-time calendar notification:", e.localizedDescription)
            } else {
                print("Scheduled one-time calendar notification for \(date) (id: \(id.uuidString))")
            }
        }
    }

    // MARK: - Cancel
    /// إلغاء إشعار بناءً على معرف النبته
    func cancelReminder(id: UUID) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        center.removeDeliveredNotifications(withIdentifiers: [id.uuidString])
    }
}
