//
//  CountryTableViewCell.swift
//  iWeather
//
//  Created by Oleksandr Kurtsev on 02/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    static let identifier = "CountryTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "CountryTableViewCell", bundle: nil)
    }
    
    func configure(withCountry country: Country) {
        nameLabel.text = country.name
        codeLabel.text = country.code
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
