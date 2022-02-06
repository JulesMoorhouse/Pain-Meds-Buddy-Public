//
//  RequestReview.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import StoreKit
import SwiftUI

class RequestReview {
    @AppStorage("runsSinceLastRequest") static var runsSinceLastRequest = 0
    @AppStorage("version") static var version = ""

    enum ReviewRequest {
        static func showReview() {}
    }

    static var limit = 10

    static func showReview() {
        runsSinceLastRequest += 1
        let currentVersion =
            "Version \(Bundle.main.buildVersion), build \(Bundle.main.shortVersion)"

        // NOTE: When a new app version is detected reset the counter to zero
        guard currentVersion != version else {
            runsSinceLastRequest = 0
            return
        }

        // NOTE: If the counter is equal to the limit continue
        guard runsSinceLastRequest == limit else { return }

        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        {
            SKStoreReviewController.requestReview(in: scene)

            // Reset runsSinceLastRequest
            runsSinceLastRequest = 0

            // Set version to currentVersion
            version = currentVersion
        }
    }
}
