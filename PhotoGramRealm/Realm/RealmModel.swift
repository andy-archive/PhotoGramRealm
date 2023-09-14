//
//  RealmModel.swift
//  PhotoGramRealm
//
//  Created by Taekwon Lee on 2023/09/04.
//

import Foundation
import RealmSwift

final class Diary: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var mainContents: String?
    @Persisted var photoURL: String?
    @Persisted var isLike: Bool
//    @Persisted var isPinned: Bool
    @Persisted var summary: String
    
    convenience init(title: String, date: Date, mainContents: String?, photoURL: String?, isLike: Bool) {
        self.init()
        
        self.title = title
        self.date = date
        self.mainContents = mainContents
        self.photoURL = photoURL
        self.isLike = true
        self.summary = "\(title) \(mainContents ?? "")"
    }
}

