//
//  PhotoImageView.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit

final class PhotoImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = Constants.Design.cornerRadius
        layer.borderWidth = Constants.Design.borderWidth
        layer.borderColor = Constants.BaseColor.border
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
