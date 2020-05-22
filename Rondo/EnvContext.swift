//
//  AppContext.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2019 Leanplum. All rights reserved.
//

import Foundation
import Leanplum

class EnvContext {

    var envs: [LeanplumEnv] = UserDefaults.standard.envs {
        didSet {
            if envs != oldValue {
                UserDefaults.standard.envs = envs
            }
        }
    }

    var env: LeanplumEnv? = UserDefaults.standard.env {
        didSet {
            if env != oldValue {
                UserDefaults.standard.env = env
            }
        }
    }

    init() {
        defer {
            if envs.isEmpty {
                envs = [
                LeanplumEnv(
                    apiHostName: "api.leanplum.com",
                    ssl: true,
                    socketHostName: "dev.leanplum.com",
                    socketPort: 443),
                LeanplumEnv(
                    apiHostName: "leanplum-qa-1372.appspot.com",
                    ssl: true,
                    socketHostName: "dev-qa.leanplum.com",
                    socketPort: 80),
                LeanplumEnv(
                    apiHostName: "leanplum-staging.appspot.com",
                    ssl: true,
                    socketHostName: "dev-staging.leanplum.com",
                    socketPort: 80),
                ]
            }

            if env == nil {
                env = envs.first
            }
        }
    }
}
