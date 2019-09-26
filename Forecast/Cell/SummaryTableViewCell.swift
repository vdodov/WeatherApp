//
//  SummaryTableViewCell.swift
//  Forecast
//
//  Created by 차수연 on 25/09/2019.
//  Copyright © 2019 차수연. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
  static let identifier = "SummaryTableViewCell"
  
  @IBOutlet weak var weatherImageView: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var minMaxLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = .clear
    statusLabel.textColor = .white
    minMaxLabel.textColor = statusLabel.textColor
    currentTemperatureLabel.textColor = statusLabel.textColor
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
