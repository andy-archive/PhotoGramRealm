//
//  DetailViewController.swift
//  PhotoGramRealm
//
//  Created by Taekwon Lee on 2023/09/05.
//

import UIKit
import RealmSwift

final class DetailViewController: BaseViewController {
    
    var data: Diary?
    private let realm = try! Realm()
    private let repository = DiaryRepository()
    
    let titleTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "제목을 입력하세요"
        view.backgroundColor = .white
        return view
    }()
    
    let contentTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "내용을 입력하세요"
        view.backgroundColor = .white
        return view
    }()
    
    override func configure() {
        super.configure()
        
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        
        passValue()
        configureNavigationBar()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.center.equalTo(view)
        }
        
        contentTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(60)
        }
    }
    
    private func passValue() {
        guard let data = data else { return }
        
        titleTextField.text = data.title
        contentTextField.text = data.mainContents
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "EDIT",
            style: .plain,
            target: self,
            action: #selector(editButtonClicked)
        )
    }
    
    @objc
    func editButtonClicked() {
        
        // Realm Update
        guard let data = data,
              let titleText = titleTextField.text,
              let contentText = contentTextField.text
        else { return }
        
        repository.updateItem(
            id: data._id,
            title: titleText,
            mainContents: contentText
        )
        
        navigationController?.popViewController(animated: true)
    }
}
