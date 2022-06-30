//
//  LPApp.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2019 Leanplum. All rights reserved.
//

import Foundation

struct LeanplumApp: Equatable, Codable {

    enum Mode: String, CaseIterable, Codable {
        case production
        case development
    }

    let name: String
    let appId: String
    let productionKey: String
    let developmentKey: String

    var mode: Mode = .development
}

extension LeanplumApp: CustomStringConvertible {

    var description: String {
        return name
    }
}

extension Leanplum.LogLevel: CustomStringConvertible {
    public var description : String {
        switch self {
        case .off: return "Off"
        case .debug: return "Debug"
        case .info: return "Info"
        case .error: return "Error"
        @unknown default:
            return "Unknown"
        }
    }
}
