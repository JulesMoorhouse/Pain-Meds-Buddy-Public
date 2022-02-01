//
//  DataController+Notifications.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import UserNotifications

extension DataController {
    func addCheckReminders(
        for dose: Dose,
        add: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        let centre = UNUserNotificationCenter.current()

        centre.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotifications { success in
                    if success {
                        if add {
                            self.placeReminders(
                                for: dose,
                                completion: completion
                            )
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
            case .authorized:
                if add {
                    self.placeReminders(
                        for: dose,
                        completion: completion
                    )
                } else {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    func removeReminders(for dose: Dose) {
        let centre = UNUserNotificationCenter.current()
        let id = dose.objectID.uriRepresentation().absoluteString

        centre.removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func requestNotifications(completion: @escaping (Bool) -> Void) {
        let centre = UNUserNotificationCenter.current()

        centre.requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            completion(granted)
        }
    }

    private func placeReminders(
        for dose: Dose,
        completion: @escaping (Bool) -> Void
    ) {
        if let notificationDate = dose.doseElapsedDate {
            let content = UNMutableNotificationContent()
            content.title = dose.doseTitle
            content.body =
                "\(dose.doseDisplayFull)\n\(String(.notificationSubtitle))"

            content.sound = .default

            let components = Calendar.current
                .dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: notificationDate
                )

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: true
            )

            let id = dose.objectID.uriRepresentation().absoluteString
            let request = UNNotificationRequest(
                identifier: id,
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current()
                .add(request) { error in
                    DispatchQueue.main.async {
                        if error == nil {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
        }
    }
}
