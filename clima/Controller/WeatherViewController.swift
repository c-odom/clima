//
//  ViewController.swift
//  clima
//
//  Created by Jayz Walker on 11/10/20.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextfield: UITextField!
    
    //MARK: - Properties
    var weatherManager = WeatherManager()
    let locationManger = CLLocationManager()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupDelegation()
        setupLocationReqeuest()
        
    }
    
    //MARK: - Functions
    func setupDelegation() {
        searchTextfield.delegate = self
        weatherManager.delegate = self
        locationManger.delegate = self
    }
    
    func setupLocationReqeuest() {
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
    }
    
    //MARK: - IBActions
    @IBAction func onSearchButtonPressed(_ sender: UIButton) {
        searchTextfield.endEditing(true)
    }
    
    @IBAction func onLocationButtonPressed(_ sender: UIButton) {
        locationManger.requestLocation()
    }
    
}

//MARK: - UITextFeildDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != "") {
            return true
        }
        textField.placeholder = "Please type something!"
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let city = textField.text ?? ""
        weatherManager.fetchWeather(cityName: city)
        textField.text = ""
        textField.placeholder = "Search"
    }
    
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel?) {
        guard let safeWeather = weather else { return }

        DispatchQueue.main.async {[weak self] in
            self?.temperatureLabel.text = safeWeather.temperatureString
            self?.cityLabel.text = safeWeather.cityName
            self?.conditionImageView.image = UIImage(systemName: safeWeather.conditionName)
        }
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {[weak self] in
            self?.cityLabel.text = "No information for this city."
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManger.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeather(latitude: lat, longitude: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError(error)
    }
}
