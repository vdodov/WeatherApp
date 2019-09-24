//
//  ForecastTableViewCell.swift
//  Forecast
//
//  Created by 차수연 on 25/09/2019.
//  Copyright © 2019 차수연. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
  static let identifier = "ForecastTableViewCell"

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var weatherImageView: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
