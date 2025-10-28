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

    // طلب إذن الإشعارات
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

    // جدولة إشعار للنبته
    // - parameter id: نستخدم id.uuidString كمعرّف للإشعار حتى نقدر نلغيّه لاحقًا
    // - parameter title/subtitle: نص الإشعار
    // - parameter daysInterval: عدد الأيام بين التذكيرات (1 = يومي، 2 = كل يومين، 7 = أسبوعي)
    // - parameter atHour/atMinute: الوقت المطلوب لظهور الإشعار (افتراضي 09:00)
    func scheduleReminder(id: UUID,
                          title: String,
                          subtitle: String?,
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

        // إذا كان التكرار يومي/أسبوعي (قائمة محددة)، نستخدم UNCalendarNotificationTrigger
        if daysInterval == 1 {
            // كل يوم عند الساعة المحددة -> نستخدم Calendar components مع repeats = true
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

        // إذا كان كل أسبوع (7 أيام) عند نفس اليوم والساعة: نستخدم weekday حسب اليوم المقبل
        if daysInterval == 7 {
            var calendar = Calendar.current
            calendar.locale = Locale.current
            // نختار اليوم الحالي + theHour
            let now = Date()
            let comps = calendar.dateComponents([.weekday], from: now)
            var dateComponents = DateComponents()
            dateComponents.weekday = comps.weekday // نفس يوم الأسبوع
            dateComponents.hour = atHour
            dateComponents.minute = atMinute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let e = error { print("schedule error:", e.localizedDescription) }
            }
            return
        }

        // إذا كان التكرار كل N أيام غير 1 و 7، نستخدم UNTimeIntervalNotificationTrigger مع repeats = true
        // ملاحظة: repeats true يحتاج interval >= 60s، لذلك نستخدم daysInterval * 86400
        let interval = TimeInterval(daysInterval * 24 * 60 * 60)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let e = error { print("schedule error:", e.localizedDescription) }
        }
    }

    // إلغاء إشعار بناءً على معرف النبته
    func cancelReminder(id: UUID) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        // يمكن أيضاً حذف الإشعارات التي ظهرت (غير ضروري عادة)
        center.removeDeliveredNotifications(withIdentifiers: [id.uuidString])
    }
}

