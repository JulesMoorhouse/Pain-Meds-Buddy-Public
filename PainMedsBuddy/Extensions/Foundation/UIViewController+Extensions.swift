//
//  UIViewController+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import UIKit

extension UIViewController {
    var rootParent: UIViewController {
        if let parent = parent {
            return parent.rootParent
        } else {
            return self
        }
    }
}
