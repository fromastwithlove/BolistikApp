//
//  EnvironmentKeys.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 19.07.25.
//

import SwiftUICore

private struct EnvironmentKeys: EnvironmentKey {
    static var defaultValue: AppDependenciesProtocol {
        return AppDependencies()
    }
}

extension EnvironmentValues {
    var dependencies: AppDependenciesProtocol {
        get { self[EnvironmentKeys.self] }
        set { self[EnvironmentKeys.self] = newValue }
    }
}
