//
//  AppContext.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2019 Leanplum. All rights reserved.
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

    init() {
        defer {
            if apps.isEmpty {
                apps = [
                    LeanplumApp(name: "Rondo QA Production",
                                appId: "app_ve9UCNlqI8dy6Omzfu1rEh6hkWonNHVZJIWtLLt6aLs",
                                productionKey: "prod_D5ECYBLrRrrOYaFZvAFFHTg1JyZ2Llixe5s077Lw3rM",
                                developmentKey: "dev_cKF5HMpLGqhbovlEGMKjgTuf8AHfr2Jar6rrnNhtzQ0"),
                    LeanplumApp(name: "Rondo QA Automation",
                                appId: "app_UQcFGVeXzOCVsovrlUebad9R67hFJqzDegfQPZRnVZM",
                                productionKey: "prod_lL8RSFzmHy0iVYXQpzjUVEHDlaUz5idT0H7BVs6Bn1Q",
                                developmentKey: "dev_b9qX0tcazL5PCQFuZ7pxsfT6XHA7xQkaFtYVrgt4Kq0"),
                    LeanplumApp(name: "Musala QA",
                                appId: "app_UQcFGVeXzOCVsovrlUebad9R67hFJqzDegfQPZRnVZM",
                                productionKey: "prod_lL8RSFzmHy0iVYXQpzjUVEHDlaUz5idT0H7BVs6Bn1Q",
                                developmentKey: "dev_b9qX0tcazL5PCQFuZ7pxsfT6XHA7xQkaFtYVrgt4Kq0")
                ]
            }

            if app == nil {
                app = apps.first
            }
        }
    }

    func start(with app: LeanplumApp?, callback: ((Bool) -> Void)?) {
        guard let app = app else {
            return
        }

        self.app = app

        switch app.environment {
        case .development:
            Leanplum.setAppId(app.appId, withProductionKey: app.productionKey)
        case .production:
            Leanplum.setAppId(app.appId, withDevelopmentKey: app.developmentKey)
        }

        Leanplum.onStartResponse { (success) in
            callback?(success)
        }
        Leanplum.start()
    }
}
