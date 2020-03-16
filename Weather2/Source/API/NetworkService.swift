//
//  NetworkService.swift
//  Weather2
//
//  Created by 차수연 on 2020/03/16.
//  Copyright © 2020 차수연. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
  
  enum ErrorType: Error {
    case netWorkError, NoData, ValidCodeError, sameData, failToParsing
  }
  
  static func getCurrentForecast(lat: Double, lon: Double, completion: @escaping (Swift.Result<WeatherSummary, ErrorType>) -> ()) {
    let url = "https://apis.openapi.sk.com/weather/current/minutely?version=2&lat=\(lat)&lon=\(lon)&appKey=\(appKey)"
    
    let req = AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
    
    req.validate().responseData { (res) in
      switch res.result {
      case .success(let data):
        guard let resultData = try? JSONDecoder().decode(WeatherSummary.self, from: data) else {
          completion(.failure(.NoData))
          return
        }
        completion(.success(resultData))
      case .failure:
        completion(.failure(.netWorkError))
      }
    }
  }
}
