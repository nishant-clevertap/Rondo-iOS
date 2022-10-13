//
//  Util.swift
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 19.07.22.
//  Copyright © 2022 Leanplum. All rights reserved.
//

import Foundation

struct Util {
    static func getPrivateValue(subject: Any, label: String, _ isLazy: Bool = false, _ isOptional: Bool = false) -> Any? {
        let mirror = Mirror(reflecting: subject)
        let fullLabel = isLazy ? "$__lazy_storage_$_" + label : label
        let child = mirror.children.first { (_label: String?, value: Any) in
            _label == fullLabel
        }
        
        let value = child?.value
        
        if isOptional, let value = value {
            return Mirror(reflecting: value).children.first?.value
        }
        return value
    }
    
    static func jsonPrettyString<T>(_ model: T) -> String where T: Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try! encoder.encode(model)
        return String(data: data, encoding: .utf8)!
    }
}
