//
//  AppDelegate.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(schemaVersion: 5) { migration, oldSchemaVersion in
         
            // column & table의 단순 추가/삭제는 별도의 코드가 필요 없다
            if oldSchemaVersion < 1 {} // add isPinned
            
            if oldSchemaVersion < 2 {} // delete isPinned
            
            if oldSchemaVersion < 3 { // change photo to photoURL
                migration.renameProperty(onType: Diary.className(), from: "photo", to: "photoURL")
            }
            
            if oldSchemaVersion < 4 { // change contents -> mainContents
                migration.renameProperty(onType: Diary.className(), from: "contents", to: "mainContents")
            }
            
            if oldSchemaVersion < 5 { // add summary & summary = title + mainContents
                
                migration.enumerateObjects(ofType: Diary.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["summary"] = "\(old["title"]) \(old["mainContents"])"
                }
                
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

