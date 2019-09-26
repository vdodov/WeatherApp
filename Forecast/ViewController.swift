//
//  ViewController.swift
//  Forecast
//
//  Created by 차수연 on 21/09/2019.
//  Copyright © 2019 차수연. All rights reserved.
//

import UIKit
import CoreLocation

extension UIViewController {
  func show(message: String) {
    let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
    alert.addAction(ok)
    
    present(alert, animated: true, completion: nil)
  }
}

class ViewController: UIViewController {
  
  
  
  lazy var locationManage: CLLocationManager = {
    let m = CLLocationManager()
    m.delegate = self
    return m
  }()
  
  let tempFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0 //소수점아래 0이면 출력하지 않는다.
    formatter.maximumFractionDigits = 1//그렇지 않으면 소수점아래 1자리만
    return formatter
  }()
  
  let dateFormatter: DateFormatter = {
    let fomatter = DateFormatter()
    fomatter.locale = Locale(identifier: "Ko_kr")
    return fomatter
  }()
  
  @IBOutlet weak var listTableView: UITableView!
  
  @IBOutlet weak var locationLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    listTableView.backgroundColor = .clear
    listTableView.separatorStyle = .none
    listTableView.showsVerticalScrollIndicator = false 
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    locationLabel.text = "업데이트 중..."
    
    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
      case .notDetermined:
        locationManage.requestWhenInUseAuthorization()
      case .authorizedWhenInUse, .authorizedAlways:
        updateCurrentLocation()
      case .denied, .restricted:
        show(message: "위치 서비스 사용 불가")
      }
    } else {
      show(message: "위치 서비스 사용 불가")
    }
  }
  var topInset: CGFloat = 0.0
  
  //view배치가 완료된 다음에 호출됨
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if topInset == 0.0 {
      let first = IndexPath(row: 0, section: 0)
      if let cell = listTableView.cellForRow(at: first) {
        topInset = listTableView.frame.height - cell.frame.height
        listTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
      }
      
    }
  }

  
}


extension ViewController: CLLocationManagerDelegate {
  func updateCurrentLocation() {
    locationManage.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let loc = locations.first {
      print(loc.coordinate)
      
      let decoder = CLGeocoder()
      decoder.reverseGeocodeLocation(loc) { [weak self] (placemarks, error) in
        if let place = placemarks?.first {
          if let gu = place.locality, let dong = place.subLocality {
            self?.locationLabel.text = "\(gu) \(dong)"
          } else {
            self?.locationLabel.text = place.name
          }
        }
      }
      
      WeatherDataSource.shared.fetch(location: loc) {
        self.listTableView.reloadData()
      }
    }
    //배터리를 절약 할 수 있음
    manager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    show(message: error.localizedDescription)
    manager.stopUpdatingLocation()
  }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      updateCurrentLocation()
    default:
      break
    }
  }
}




extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return WeatherDataSource.shared.forecastList.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell
      
      if let data = WeatherDataSource.shared.summary?.weather.minutely.first {
        cell.weatherImageView.image = UIImage(named: data.sky.code)
        cell.statusLabel.text = data.sky.name
        
        //문자열을 Double로 전환후 다시 문자열로
        let max = Double(data.temperature.tmax) ?? 0.0
        let min = Double(data.temperature.tmin) ?? 0.0
        
        let maxStr = tempFormatter.string(for: max) ?? "-"
        let minStr = tempFormatter.string(for: min) ?? "-"
        
        cell.minMaxLabel.text = "최대 \(maxStr)º 최소 \(minStr)º"
        
        //
        let current = Double(data.temperature.tc)
        let currentStr = tempFormatter.string(for: current) ?? "-"
        
        cell.currentTemperatureLabel.text = "\(currentStr)º"
        
      }
      
      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
    
    let target = WeatherDataSource.shared.forecastList[indexPath.row]
    
    dateFormatter.dateFormat = "M.d (E)"
    cell.dateLabel.text = dateFormatter.string(for: target.date)
    
    dateFormatter.dateFormat = "HH:00"
    cell.timeLabel.text = dateFormatter.string(from: target.date)
    
    cell.weatherImageView.image = UIImage(named: target.skyCode)
    cell.statusLabel.text = target.skyName
    
    let tempStr = tempFormatter.string(for: target.temperature) ?? "-"
    cell.temperatureLabel.text = "\(tempStr)º"
    
    return cell
  }
  
}
