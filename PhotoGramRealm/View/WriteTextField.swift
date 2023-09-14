//
//  WriteTextField.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//
 
import UIKit

final class WriteTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        backgroundColor = Constants.BaseColor.background
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = Constants.Design.cornerRadius
        layer.borderWidth = Constants.Design.borderWidth
        layer.borderColor = Constants.BaseColor.border
    }

}