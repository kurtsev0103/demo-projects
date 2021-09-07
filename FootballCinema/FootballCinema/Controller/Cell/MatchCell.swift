//
//  MatchCell.swift
//  FootballCinema
//
//  Created by Oleksandr Kurtsev on 05/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import SDWebImage

class MatchCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "MatchCell"
    
    let matchImageView = UIImageView(image: nil, contentMode: .scaleToFill)
    let matchName = UILabel()
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 4
        self.layer.shadowColor = Colors.niceGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        matchName.font = Fonts.avenir16
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        matchImageView.image = nil
    }

    func configure<U>(with value: U) where U : Hashable {
        guard let match: Match = value as? Match else { return }
        matchName.text = match.title
        guard let url = URL(string: match.thumbnail) else { return }
        matchImageView.sd_setImage(with: url, completed: nil)
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Constraints
extension MatchCell {
    private func setupConstraints() {
        matchImageView.translatesAutoresizingMaskIntoConstraints = false
        matchName.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerView)
        containerView.addSubview(matchImageView)
        containerView.addSubview(matchName)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            matchImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            matchImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            matchImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            matchImageView.bottomAnchor.constraint(equalTo: matchName.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            matchName.heightAnchor.constraint(equalToConstant: 40),
            matchName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            matchName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            matchName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
