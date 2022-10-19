//
//  AppContext.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation
import Leanplum

class AppContext {

    var apps: [LeanplumApp] = UserDefaults.standard.apps {
        didSet {
            if apps != oldValue {
                UserDefaults.standard.apps = apps
            }
        }
    }

    var app: LeanplumApp? = UserDefaults.standard.app {
        didSet {
            if app != oldValue {
                UserDefaults.standard.app = app
            }
        }
    }

    var envs: [LeanplumEnv] = UserDefaults.standard.envs {
        didSet {
            if envs != oldValue {
                UserDefaults.standard.envs = envs
            }
        }
    }

    var env: LeanplumEnv? = UserDefaults.standard.env {
        didSet {
            env?.setNetworkConfig()
        }
    }
    
    var logLevel: LeanplumLogLevel = UserDefaults.standard.logLevel {
        didSet {
            if logLevel != oldValue {
                UserDefaults.standard.logLevel = logLevel
                Leanplum.setLogLevel(logLevel)
            }
        }
    }
    
    var useApiConfig: Bool = UserDefaults.standard.useApiConfig {
        didSet {
            if useApiConfig != oldValue {
                UserDefaults.standard.useApiConfig = useApiConfig
            }
        }
    }

    init() {
        // defer to force didSet
        defer {
            if apps.isEmpty {
                apps = [
                    LeanplumApp(name: "Rondo QA Production",
                                appId: "app_ve9UCNlqI8dy6Omzfu1rEh6hkWonNHVZJIWtLLt6aLs",
                                productionKey: "prod_D5ECYBLrRrrOYaFZvAFFHTg1JyZ2Llixe5s077Lw3rM",
                                developmentKey: "dev_cKF5HMpLGqhbovlEGMKjgTuf8AHfr2Jar6rrnNhtzQ0"),
                    LeanplumApp(name: "Rondo Automation",
                                appId: "app_UQcFGVeXzOCVsovrlUebad9R67hFJqzDegfQPZRnVZM",
                                productionKey: "prod_lL8RSFzmHy0iVYXQpzjUVEHDlaUz5idT0H7BVs6Bn1Q",
                                developmentKey: "dev_b9qX0tcazL5PCQFuZ7pxsfT6XHA7xQkaFtYVrgt4Kq0"),
                    LeanplumApp(name: "Musala QA",
                                appId: "app_qA781mPlJYjzlZLDlTh68cdNDUOf31kcTg1TCbSXSS0",
                                productionKey: "prod_kInQHXLJ0Dju7QJRocsD5DYMdYAVbdGGwhl6doTfH0k",
                                developmentKey: "dev_WqNqX0qOOHyTEQtwKXs5ldhqErHfixvcSAMlYgyIL0U")
                ]
            }

            if app == nil {
                app = apps.first
            }

            if envs.isEmpty {
                envs = [
                    LeanplumEnv(
                        apiHostName: "ct-dot-ingester.prod.leanplum.com",
                        ssl: true,
                        socketHostName: "dev.leanplum.com",
                        socketPort: 443),
                    LeanplumEnv(
                        apiHostName: "api.leanplum.com",
                        ssl: true,
                        socketHostName: "dev.leanplum.com",
                        socketPort: 443),
                    LeanplumEnv(
                        apiHostName: "ingester.qa.leanplum.com",
                        ssl: true,
                        socketHostName: "dev-qa.leanplum.com",
                        socketPort: 443),
                    LeanplumEnv(
                        apiHostName: "api-staging.leanplum.com",
                        ssl: true,
                        socketHostName: "dev-staging.leanplum.com",
                        socketPort: 443),
                ]
            }
            
            if env == nil && !useApiConfig {
                env = envs.first
            }
        }
    }

    func start(with app: LeanplumApp?, environment: LeanplumEnv?, callback: ((Bool) -> Void)?) throws {
        guard let app = app, let env = env else {
            return
        }

        if !useApiConfig {
            self.env = env
        }
        self.app = app
        
        switch app.mode {
        case .development:
            Leanplum.setAppId(app.appId, developmentKey: app.developmentKey)
        case .production:
            Leanplum.setAppId(app.appId, productionKey: app.productionKey)
        }
        
        Leanplum.onStartResponse { (success) in
            callback?(success)
        }

        try LPExceptionCatcher.catchException {
            let startAttr = ["startAttributeInt": 1,
                             "startAttributeString": "stringValueFromStart"] as [String : Any]
            Leanplum.start(attributes: startAttr)
        }
    }
}
