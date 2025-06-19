//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Kira on 17.06.2025.
//

import YandexMobileMetrica

final class AnalyticsService {

    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "e609ada8-b5d3-48bc-b59d-b6353378271b") else { return }

        YMMYandexMetrica.activate(with: configuration)
    }

    func reportEvent(event: String, parameters: [String: String]) {
        YMMYandexMetrica.reportEvent(event, parameters: parameters, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
