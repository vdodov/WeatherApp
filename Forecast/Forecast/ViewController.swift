//
//  ViewController.swift
//  Forecast
//
//  Created by 차수연 on 21/09/2019.
//  Copyright © 2019 차수연. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let tempFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0 //소수점아래 0이면 출력하지 않는다.
    formatter.maximumFractionDigits = 1//그렇지 않으면 소수점아래 1자리만
    return formatter
  }()
  
  @IBOutlet weak var listTableView: UITableView!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    WeatherDataSource.shared.fetchSummary(lat: 37.498206, lon: 127.02761) { [weak self] in
      self?.listTableView.reloadData()
      
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
      return 0
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
        
        cell.minMaxLabel.text = "최대 \(maxStr)º 최소\(minStr)"
        
        //
        let current = Double(data.temperature.tc)
        let currentStr = tempFormatter.string(for: current) ?? "-"
        
        cell.currentTemperatureLabel.text = "\(currentStr)º"
        
      }
      
      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
    //...
    
    return cell
  }
  
}
