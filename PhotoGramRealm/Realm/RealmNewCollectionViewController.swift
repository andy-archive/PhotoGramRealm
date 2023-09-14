//
//  RealmNewCollectionViewController.swift
//  PhotoGramRealm
//
//  Created by Taekwon Lee on 2023/09/14.
//

import UIKit
import RealmSwift

final class RealmNewCollectionViewController: BaseViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
    private var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ToDoTable>!
    
    private var list = ["Andy", "Han", "Noah", "Joey", "Roen", "Dana"]
    
    private let realm = try! Realm()
    private var todoList: Results<ToDoTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        todoList = realm.objects(ToDoTable.self)
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @available(iOS 14.0, *)
    private func configureCollectionView() {
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.textProperties.color = .black
            content.secondaryText = "\(itemIdentifier.detail.count) 개의 세부 할 일"
            content.textToSecondaryTextVerticalPadding = 10
//            content.prefersSideBySideTextAndSecondaryText = false
            content.image = itemIdentifier.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            content.imageProperties.tintColor = .systemRed
            content.imageToTextPadding = 10
            cell.contentConfiguration = content
            
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            backgroundConfiguration.backgroundColor = .systemGray5
            backgroundConfiguration.cornerRadius = 10
            backgroundConfiguration.strokeWidth = 1
            backgroundConfiguration.strokeColor = .systemGray4
            cell.backgroundConfiguration = backgroundConfiguration
        })
    }
    
    static func setCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}

extension RealmNewCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = todoList[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: data)
        return cell
    }
}
