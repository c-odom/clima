//
//  WeatherData.swift
//  clima
//
//  Created by Jayz Walker on 11/11/20.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
