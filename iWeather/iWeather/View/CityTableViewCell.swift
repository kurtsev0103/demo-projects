//
//  CityTableViewCell.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 03/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    static let identifier = "CityTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "CityTableViewCell", bundle: nil)
    }
    
    func configure(withCity city: City) {
        nameLabel.text = city.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
