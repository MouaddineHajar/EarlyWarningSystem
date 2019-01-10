//
//  WeatherCollCellCollectionViewCell.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/24/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit

class WeatherCollCell: UICollectionViewCell {
    
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var timezone: UILabel!
    @IBOutlet weak var date: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(highTemp : Double, lowTemp : Double, timezone : String, date : String) {
        self.highTemp.text = "H: \(highTemp)F"
        self.lowTemp.text = "L: \(lowTemp)F"
        self.timezone.text = timezone
        self.date.text = date
    }
}
