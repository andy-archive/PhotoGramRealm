//
//  DiaryRepository.swift
//  PhotoGramRealm
//
//  Created by Taekwon Lee on 2023/09/06.
//

import Foundation
import RealmSwift

protocol DiaryRepositoryType: AnyObject {
    func fetch() -> Results<Diary>
    func fetchFilter() -> Results<Diary>
    func createItem(_ item: Diary)
    func updateItem(id: ObjectId, title: String, mainContents: String)
}

final class DiaryRepository: DiaryRepositoryType {
    
    private let realm = try! Realm()
    
    func checkSchemaVersion() {
        guard let fileURL = realm.configuration.fileURL else { return }
        
        do {
            let version = try schemaVersionAtURL(fileURL)
//            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    //Realm Read
    func fetch() -> Results<Diary> {
        let data = realm.objects(Diary.self).sorted(byKeyPath: "date", ascending: true)
        return data 
    }
    
    func fetchFilter() -> Results<Diary> {
        let data = realm.objects(Diary.self).where {
            //1. String
            // $0.title.contains("Studio", options: .caseInsensitive) // caseInsensitive - 대소문자 구별 없음
            
            //2. Bool
            // $0.isLike == true
            
            //3. 사진이 있는 데이터만 불러오기 (diaryPhoto의 nil 여부 판단)
            $0.photoURL != nil
        }
        return data
    }
    
    func createItem(_ item: Diary) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func updateItem(id: ObjectId, title: String, mainContents: String) {
        do {
            try realm.write {
                realm.create(
                    Diary.self,
                    value: [
                        "_id": id,
                        "title": title,
                        "mainContents": mainContents
                    ],
                    update: .modified
                )
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
}
