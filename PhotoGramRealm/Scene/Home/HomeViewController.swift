//
//  HomeViewController.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import RealmSwift

final class HomeViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.register(PhotoListTableViewCell.self, forCellReuseIdentifier: PhotoListTableViewCell.reuseIdentifier)
        return view
    }()
    
    private var tasks: Results<Diary>!
    private let realm = try! Realm()
    private let repository = DiaryRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = repository.fetch()
        
        repository.checkSchemaVersion()
        
//        guard let fileURL = realm.configuration.fileURL else { return }
//        print(fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData() // 실시간 갱신!
    }
    
    override func configure() {
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton, backupButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc
    func plusButtonClicked() {
        navigationController?.pushViewController(AddViewController(), animated: true)
    }
    
    @objc
    func backupButtonClicked() {
        navigationController?.pushViewController(BackupViewController(), animated: true)
    }
    
    @objc
    func sortButtonClicked() {
        tasks = realm.objects(Diary.self).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    @objc
    func filterButtonClicked() {
        tasks = DiaryRepository().fetchFilter()
        tableView.reloadData()
    }
}

//MARK: UITablewView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let data = tasks[indexPath.row]
        
        //Cell Configuration
        var configuration = cell.defaultContentConfiguration()
        configuration.text = data.title
        configuration.textProperties.color = .black
        configuration.textToSecondaryTextVerticalPadding = 15
        configuration.secondaryText = "\(data.date.formatted(date: .abbreviated, time: .shortened))"
        configuration.secondaryTextProperties.color = .systemGray
        configuration.image = loadImageFromDocument(fileName: "andy_\(data._id).jpg")
        configuration.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        cell.contentConfiguration = configuration
        
        var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
        backgroundConfiguration.backgroundColor = .systemGray6
        backgroundConfiguration.cornerRadius = 15
        backgroundConfiguration.strokeWidth = 2
        backgroundConfiguration.strokeColor = .systemTeal
        cell.backgroundConfiguration = backgroundConfiguration
        
        //======================================================================================
        //Traditional Cell
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.reuseIdentifier) as? PhotoListTableViewCell else { return UITableViewCell() }
//        cell.titleLabel.text = data.title
//        cell.contentLabel.text = data.mainContents
//        cell.dateLabel.text = "\(data.date.formatted(date: .abbreviated, time: .shortened))"
//        cell.diaryImageView.image = loadImageFromDocument(fileName: "andy_\(data._id).jpg")
        //======================================================================================
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.data = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
        //MARK: 셀 선택 시 파일 삭제 & Realm 삭제
        
        //Realm Delete -> 삭제 코드는 생각보다 간단
//        let data = tasks[indexPath.row]
//
//        removeImageFromDocument(fileName: "andy_\(data._id).jpg")
//
//        try! realm.write {
//            realm.delete(data)
//        }
//
//        tableView.reloadData() // 데이터를 변경했으니 갱신! B.U.T 저장된 이미지 파일은 그대로!
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let like = UIContextualAction(style: .normal, title: "Like") { action, view, completionHandler in
            print("SELECTED LIKE")
        }
        
        like.backgroundColor = .systemRed
        like.image = tasks[indexPath.row].isLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        let sample = UIContextualAction(style: .normal, title: "Sample") { action, view, completionHandler in
            print("SELECTED SAMPLE")
        }
        
        sample.backgroundColor = .systemBlue
        sample.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [like, sample])
    }
}

/*
  String -> URL -> Data -> UIImage
  DB에서 가져오는 String이라 global에 접근하면 안된다
  1. cell의 서버 통신 용량이 크면 로드가 오래 걸릴 수 있다
  2. 이미지를 미리 UIImage 형식으로 변환하여 cell에 UIImage를 바로 보여 주자!
  -> 재사용 메커니즘을 효율적으로 사용 못할 수 있고, UIImage 배열 구성 자체가 오래 걸릴 수 있다
 
        let url = URL(string: data.photo ?? "")
        DispatchQueue.global().async {

            if let url = url, let data = try? Data(contentsOf: url) {

                DispatchQueue.main.async {
                    cell.diaryImageView.image = UIImage(data: data)
                }
            }
        }
 */
