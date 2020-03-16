//
//  WeatherDataManager.swift
//  Weather2
//
//  Created by 차수연 on 2020/03/10.
//  Copyright © 2020 차수연. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherDataManager {
  static let shared = WeatherDataManager()
  
  private init() {}
  
  var summary: WeatherSummary?
  var forecastList = [ForecastData]()
  
  let group = DispatchGroup()
  let workQueue = DispatchQueue(label: "apiQueue", attributes: .concurrent)
  
  func fetch(location: CLLocation, completion: @escaping () -> ()) {
    group.enter()
    workQueue.async {
      self.fetchSummary(lat: location.coordinate.latitude, lon: location.coordinate.longitude, completion: {
        self.group.leave()
      })
    }
    
    group.enter()
    workQueue.async {
      self.fetchForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude, completion: {
        self.group.leave()
      })
    }
    
    group.notify(queue: DispatchQueue.main) {
      completion()
    }
    
  }
  
  func fetchSummary(lat: Double, lon: Double, completion: @escaping () -> ()) {
    let apiUrl = "https://apis.openapi.sk.com/weather/current/minutely?version=2&lat=\(lat)&lon=\(lon)&appKey=\(appKey)"

    let url = URL(string: apiUrl)!

    let session = URLSession.shared

    let task = session.dataTask(with: url) { (data, response, error) in
      defer {
        DispatchQueue.main.async {
          completion()
        }
      }

      if let error = error {
        print(error)
        return
      }

      guard let httpResponse = response as? HTTPURLResponse else {
        print("Invalid response")
        return
      }

      guard (200...299).contains(httpResponse.statusCode) else {
        print(httpResponse.statusCode)
        return
      }

      guard let data = data else {
        fatalError("Invalid Data")
      }

      do {
        let decoder = JSONDecoder()
        self.summary = try decoder.decode(WeatherSummary.self, from: data)

      } catch {

      }
    }

    task.resume()

  }
  
  func fetchForecast(lat: Double, lon: Double, completion: @escaping () -> ()) {
    forecastList.removeAll()
    
    let apiUrl = "https://apis.openapi.sk.com/weather/forecast/3days?version=2&lat=\(lat)&lon=\(lon)&appKey=\(appKey)"
    
    let url = URL(string: apiUrl)!
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: url) { (data, response, error) in
      defer {
        DispatchQueue.main.async {
          completion()
        }
      }
      
      if let error = error {
        print(error)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        print("Invalid response")
        return
      }
      
      guard (200...299).contains(httpResponse.statusCode) else {
        print(httpResponse.statusCode)
        return
      }
      
      guard let data = data else {
        fatalError("Invalid Data")
      }
      
      do {
        let decoder = JSONDecoder()
        let forecast = try decoder.decode(Forecast.self, from: data)
        
        if let list = forecast.weather.forecast3days.first?.fcst3hour.arryRepresentation() {
          self.forecastList = list
        }
      } catch {
        
      }
    }
    
    task.resume()
    
  }
}

