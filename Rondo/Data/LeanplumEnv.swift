//
//  LPEnv.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2019 Leanplum. All rights reserved.
//

import Foundation

struct LeanplumEnv: Equatable, Codable {
    let apiHostName: String
    let ssl: Bool
    let socketHostName: String
    let socketPort: Int
}

extension LeanplumEnv: CustomStringConvertible {

    var description: String {
        return apiHostName
    }
}
