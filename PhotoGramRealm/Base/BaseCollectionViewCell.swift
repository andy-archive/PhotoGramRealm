//
//  BaseCollectionViewCell.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {}
    
    func setConstraints() {}
}
