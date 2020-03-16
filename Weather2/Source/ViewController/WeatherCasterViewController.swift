//
//  WeatherCasterViewController.swift
//  Weather2
//
//  Created by 차수연 on 2020/03/02.
//  Copyright © 2020 차수연. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherCasterViewController: UIViewController {
  
  lazy var locationManage: CLLocationManager = {
    let manage = CLLocationManager()
    manage.delegate = self
    return manage
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
  
  let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "background")
    imageView.alpha = 0.5
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let topView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let locationLabel: UILabel = {
    let label = UILabel()
    label.text = "-"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getData()
    configure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    locationLabel.text = "..."
    
    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
      case .notDetermined:
        locationManage.requestWhenInUseAuthorization()
      case .authorizedAlways, .authorizedWhenInUse:
        updateCurrentLocation()
      case .denied, .restricted:
        print("위치 서비스 사용 불가")
      }
    } else {
      print("위치 서비스 사용 불가")
    }
    
    
  }
  
  var topInset: CGFloat = 0.0
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if topInset == 0.0 {
      let first = IndexPath(row: 0, section: 0)
      if let cell = tableView.cellForRow(at: first) {
        topInset = tableView.frame.height - cell.frame.height
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
      }

    }
  }
  
  private func getData() {
    
  }
  
  private func configure() {
    
    tableViewRegister()
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
     
    addSubviews()
    autoLayout()
    
  }
  
  private func tableViewRegister() {
    tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.identifier)
    tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifer)
  }
  
  private func addSubviews() {
    view.addSubview(backgroundImageView)
    
    view.addSubview(topView)
    topView.addSubview(locationLabel)
    view.addSubview(tableView)
  }
  
  private func autoLayout() {
    let guide = view.safeAreaLayoutGuide
    
    backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    topView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
    topView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    topView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    topView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    
    locationLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
    locationLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
    
    tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    
  }
}

extension WeatherCasterViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return WeatherDataManager.shared.forecastList.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell

      if let data = WeatherDataManager.shared.summary?.weather.minutely.first {
        cell.weatherImageView.image = UIImage(named: data.sky.code)
        cell.statusLabel.text = data.sky.name
        
        //문자열을 Double로 전환후 다시 문자열로
        let max = Double(data.temperature.tmax) ?? 0.0
        let min = Double(data.temperature.tmin) ?? 0.0
        
        let maxStr = tempFormatter.string(for: max) ?? "-"
        let minStr = tempFormatter.string(for: min) ?? "-"
        
        cell.maxMinLabel.text = "⤓ \(minStr)º  ⤒ \(maxStr)º"
        //
        let current = Double(data.temperature.tc)
        let currentStr = tempFormatter.string(for: current) ?? "-"
        
        cell.temperatureLabel.text = "\(currentStr)º"
        
      }
      cell.selectionStyle = .none
      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifer, for: indexPath) as! ForecastTableViewCell
    let target = WeatherDataManager.shared.forecastList[indexPath.row]
    
    dateFormatter.dateFormat = "M.d (E)"
    cell.dateLabel.text = dateFormatter.string(for: target.date)
    
    dateFormatter.dateFormat = "HH:00"
    cell.timeLabel.text = dateFormatter.string(from: target.date)
    
    cell.weatherImageView.image = UIImage(named: target.skyCode)
    cell.statusLabel.text = target.skyName
    
    let tempStr = tempFormatter.string(for: target.temperature) ?? "-"
    cell.temperatureLabel.text = "\(tempStr)º"
    
    cell.selectionStyle = .none
    return cell
  }
  
  
}

extension WeatherCasterViewController: CLLocationManagerDelegate {
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
      //테이블뷰 리로드
      WeatherDataManager.shared.fetch(location: loc) {
        self.topInset = 0.0
        self.tableView.reloadData()
      }
    }
    //배터리를 절약 할 수 있음
    manager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("[Log]", error.localizedDescription)
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
