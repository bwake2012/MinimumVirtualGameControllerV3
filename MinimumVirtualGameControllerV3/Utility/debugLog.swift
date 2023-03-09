// debugLog.swift
//
// Created by Bob Wakefield on 5/22/22.
// for BotTime
//
// Using Swift 5.0
// Running on macOS 12.3
//
// Copyright © 2022 Cockleburr Software. All rights reserved.
//

import Foundation

func debugLog(_ string: String) {

    #if DEBUG
    print(string)
    #endif
}
