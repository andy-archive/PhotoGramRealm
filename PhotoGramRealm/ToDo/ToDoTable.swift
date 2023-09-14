//
//  ToDoTable.swift
//  PhotoGramRealm
//
//  Created by Taekwon Lee on 2023/09/08.
//

import Foundation
import RealmSwift

final class ToDoTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId // Primary Key
    @Persisted var title: String
    @Persisted var isFavorite: Bool
    
    // To Many Realtionship (일대다 관계)
    @Persisted var detail: List<DetailTable>
    
    // To One Relationship (일대일 관계)
    // EmbeddedObject -> Optional 필수
    // 별도의 테이블이 생성되는 형태는 아니다
    @Persisted var memo: Memo?

    convenience init(title: String, isFavorite: Bool) {
        self.init()

        self.title = title
        self.isFavorite = isFavorite
    }
}

final class DetailTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId // Primary Key
    @Persisted var detail: String
    @Persisted var deadline: Date

    //Inverse Relationship Property (역관계, LinkingObjects)
    @Persisted(originProperty: "detail") var mainTodo: LinkingObjects<ToDoTable>
    
    convenience init(detail: String, deadline: Date) {
        self.init()

        self.detail = detail
        self.deadline = deadline
    }
}

final class Memo: EmbeddedObject {
    // EmbeddedObject는 id가 없다!
//    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var content: String
    @Persisted var createdDate: Date

    convenience init(content: String, createdDate: Date) {
        self.init()

        self.content = content
        self.createdDate = createdDate
    }
}
