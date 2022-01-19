//
//  TabBarHandler.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import UIKit

class TabBarHandler: ObservableObject {
    var tabBarController: UITabBarController?

    enum NotificationNames: String, CaseIterable {
        case showBottomTabBar,
             hideBottomTabBar,
             enableTouchTabBar,
             disableTouchTabBar
    }

    init() {
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }

        startListeningNotifications()
    }

    func startListeningNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showTabBarView),
            name: NSNotification.Name(
                TabBarHandler.NotificationNames.showBottomTabBar.rawValue),
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideTabBarView),
            name: NSNotification.Name(
                TabBarHandler.NotificationNames.hideBottomTabBar.rawValue),
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enableTabBarTouch),
            name: NSNotification.Name(
                TabBarHandler.NotificationNames.enableTouchTabBar.rawValue),
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(disableTabBarTouch),
            name: NSNotification.Name(
                TabBarHandler.NotificationNames.disableTouchTabBar.rawValue),
            object: nil)
    }

    @objc private func showTabBarView() {
        tabBarController?.tabBar.isHidden = false
    }

    @objc private func hideTabBarView() {
        tabBarController?.tabBar.isHidden = true
    }

    @objc private func disableTabBarTouch() {
        tabBarController?.tabBar.isUserInteractionEnabled = false
    }

    @objc private func enableTabBarTouch() {
        tabBarController?.tabBar.isUserInteractionEnabled = true
    }

    public func showTabBar() {
        if #available(iOS 15, *) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name(
                        TabBarHandler.NotificationNames.showBottomTabBar.rawValue),
                    object: nil)
            }
        }
    }

    public func hideTabBar() {
        if #available(iOS 15, *) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name(
                        TabBarHandler.NotificationNames.hideBottomTabBar.rawValue),
                    object: nil)
            }
        }
    }

    public func enableTouchTabBar() {
        if #available(iOS 15, *) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name(
                        TabBarHandler.NotificationNames.enableTouchTabBar.rawValue),
                    object: nil)
            }
        }
    }

    public func disableTouchTabBar() {
        if #available(iOS 15, *) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name(
                        TabBarHandler.NotificationNames.disableTouchTabBar.rawValue),
                    object: nil)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
