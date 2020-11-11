//
//  WeatherManager.swift
//  clima
//
//  Created by Jayz Walker on 11/11/20.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=place your appid here&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // create url
        guard let url = URL(string: urlString) else {
            return
        }
        
        // create session
        let session = URLSession(configuration: .default)
        
        // give session a task
        let task = session.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                delegate?.didFailWithError(error!)
                return
            }
            guard let safeData = data else {
                return
            }
            let weather = parseJSON(safeData)
            delegate?.didUpdateWeather(self, weather: weather)
        }
        
        // start the task
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather.first?.id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id ?? 0, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
        
    }
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManger: WeatherManager, weather: WeatherModel?)
    func didFailWithError(_ error: Error)
}
