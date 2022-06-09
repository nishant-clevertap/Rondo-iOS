//
//  LPEnv.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2019 Leanplum. All rights reserved.
//

import Foundation
import Leanplum

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

extension LeanplumEnv {
    func setNetworkConfig() {
        Leanplum.setApiHostName(self.apiHostName, apiPath: "api", ssl: self.ssl)
        Leanplum.setSocketHostName(self.socketHostName, port: Int32(self.socketPort))
    }
}

