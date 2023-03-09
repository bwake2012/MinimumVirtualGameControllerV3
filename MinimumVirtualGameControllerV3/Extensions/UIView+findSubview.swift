// UIView+findSubview.swift
//
// Created by Bob Wakefield on 1/2/22.
// for BotTime
//
// Using Swift 5.0
// Running on macOS 12.0
//
// Copyright © 2022 Cockleburr Software. All rights reserved.
//

import UIKit

extension UIView {

    func findSubview(matchesCriteria: (UIView) -> Bool, completion: (UIView) -> Void) {

        // do any of the current view's subview meet the criteria?
        for view in subviews {

            if matchesCriteria(view) {

                completion(view)
                return
            }
        }

        // check the subviews' subviews
        for view in subviews {

            view.findSubview(matchesCriteria: matchesCriteria, completion: completion)
        }
    }
}
