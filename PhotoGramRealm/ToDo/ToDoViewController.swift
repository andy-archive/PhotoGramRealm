//
//  ToDoViewController.swift
//  PhotoGramRealm
//
//  Created by Taekwon Lee on 2023/09/08.
//

import UIKit
import RealmSwift

final class ToDoViewController: BaseViewController {
    
    private let realm = try! Realm()
    private let tableView = UITableView()
    
//    var list: Results<ToDoTable>!
    var list: Results<DetailTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let fileURL = realm.configuration.fileURL else { return }
//        print(fileURL)
        
//        createDetail()
//        createMemo()
//        print(realm.objects(DetailTable.self))
//        print(realm.objects(Memo.self))
        
        list = realm.objects(DetailTable.self)
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createMemo() {
        
        let data = ToDoTable(title: "watch a movie", isFavorite: false)
        
        let memo = Memo()
        memo.content = "watch oppenheimer on weekends"
        memo.createdDate = Date()
        
        data.memo = memo
        
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
        
//        let data = ToDoTable(title: "Go Shopping", isFavorite: true)
//
//        let detail = DetailTable(detail: "Onion", deadline: Date())
//        let detail2 = DetailTable(detail: "Apple", deadline: Date())
//        let detail3 = DetailTable(detail: "Potato", deadline: Date())
//
//        data.detail.append(detail)
//        data.detail.append(detail2)
//        data.detail.append(detail3)
//
//        do {
//            try realm.write {
//                realm.add(data)
//            }
//        } catch {
//            print(error)
//        }
    }
    
    private func createDetail() {
//        print(realm.objects(ToDoTable.self))
        createTodo()
        
        //ToDoTable에서 title이 go shopping인 것
        let main = realm.objects(ToDoTable.self).where {
            $0.title == "go shopping"
        }.first!
        
        for i in 1...10 {
            let detailTodo = DetailTable(detail: "Detail To do \(i)", deadline: Date())
            
            try! realm.write {
//                realm.add(detailTodo) // realm을 통한 직접 추가
                main.detail.append(detailTodo) // 테이블을 추가 (to many relationship, 일대다 관계)
            }
        }
    }
    
    private func createTodo() {
        for item in ["go shopping", "do recap assignment", "watch a movie", "study Swift", "go to bed"] {
            
            let data = ToDoTable(title: item, isFavorite: false)
            
            try! realm.write {
                realm.add(data)
            }
        }
    }
}

//MARK: UITableView

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") else { return UITableViewCell() }
//        cell.textLabel?.text = "\(list[indexPath.row].title) \(list[indexPath.row].detail.count)개 \(list[indexPath.row].memo?.content ?? "")"
        
//        cell.textLabel?.text = list[indexPath.row].detail
        
        let data = list[indexPath.row]
        cell.textLabel?.text = "\(data.detail) in \(data.mainTodo.first?.title ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        
//        try! realm.write {
//            realm.delete(data.detail) // 데이터 안의 테이블 먼저 지우기 (순서가 중요)
//            realm.delete(data) // 데이터 지우기
//        }
//
//        tableView.reloadData() // CRUD 이후 뷰 갱신
        
    }
}
