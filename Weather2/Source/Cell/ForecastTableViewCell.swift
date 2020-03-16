//
//  ForecastTableViewCell.swift
//  Weather2
//
//  Created by 차수연 on 2020/03/02.
//  Copyright © 2020 차수연. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
  static let identifer = "ForecastTableViewCell"

  let dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let weatherImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let statusLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let temperatureLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 40, weight: .thin)
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }
  
  private func configure() {
    backgroundColor = .clear
    addSubviews()
    autoLayout()
  }
  
  private func addSubviews() {
    addSubview(dateLabel)
    addSubview(timeLabel)
    addSubview(temperatureLabel)
    addSubview(statusLabel)
    addSubview(weatherImageView)
    
  }
  
  private func autoLayout() {
    
    dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
    
    timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
    timeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
    
    temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    temperatureLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
    temperatureLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    
    statusLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -10).isActive = true
    statusLabel.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
    statusLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    
    weatherImageView.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -10).isActive = true
    weatherImageView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
    weatherImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    weatherImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    weatherImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
