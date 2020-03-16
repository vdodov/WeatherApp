//
//  SummaryTableViewCell.swift
//  Weather2
//
//  Created by 차수연 on 2020/03/02.
//  Copyright © 2020 차수연. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
  static let identifier = "SummaryTableViewCell"
  
  let weatherImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let statusLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let maxMinLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let temperatureLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 100, weight: .ultraLight)
    label.textAlignment = .left
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
    contentView.addSubview(weatherImageView)
    contentView.addSubview(statusLabel)
    contentView.addSubview(maxMinLabel)
    contentView.addSubview(temperatureLabel)
  }
  
  private func autoLayout() {
    weatherImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
    weatherImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    weatherImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    statusLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10).isActive = true
    statusLabel.centerYAnchor.constraint(equalTo: weatherImageView.centerYAnchor).isActive = true
    
    maxMinLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 10).isActive = true
    maxMinLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    
    temperatureLabel.topAnchor.constraint(equalTo: maxMinLabel.bottomAnchor, constant: 10).isActive = true
    temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
