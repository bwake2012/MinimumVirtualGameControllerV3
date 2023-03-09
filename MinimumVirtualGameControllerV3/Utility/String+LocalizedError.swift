// String+LocalizedError.swift
//
// Created by Bob Wakefield on 5/23/22.
// for BotTime
//
// Using Swift 5.0
// Running on macOS 12.3
//
// Copyright © 2022 Cockleburr Software. All rights reserved.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
