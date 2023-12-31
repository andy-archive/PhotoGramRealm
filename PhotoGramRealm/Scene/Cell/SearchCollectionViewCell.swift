//
//  SearchCollectionViewCell.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/04.
//

import UIKit
import SnapKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = PhotoImageView(frame: .zero)
        return view
    }()
      
    override func configureCell() {
        contentView.addSubview(imageView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
