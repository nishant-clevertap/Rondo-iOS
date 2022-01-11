//
//  Log.swift
//  Rondo-iOS
//
//  Created by Dejan Krstevski on 11.01.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation

enum Log {
    static func print(_ message: String) {
        let bundle = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        NSLog("[LEANPLUM] [\(bundle)] \(message)")
    }
}
