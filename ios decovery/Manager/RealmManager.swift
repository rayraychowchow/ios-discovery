//
//  RealmManager.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation
import RealmSwift

class RealmManager {
    public static let shared = RealmManager()
    
    func save<T: Object>(_ object: T) -> Bool {
            if let realm = try? Realm() {
                do {
                    try realm.write {
                        realm.add(object)
                    }
                    return true
                } catch {
                    return false
                }
            }
            return false
        }
        
        func remove<T: Object>(_ object: T) -> Bool  {
            if let realm = try? Realm() {
                do {
                    try realm.write {
                        realm.delete(object)
                    }
                    return true
                } catch {
                    return false
                }
            }
            return false
        }
        
        func getAll<T: Object>() -> Results<T>? {
            if let realm = try? Realm() {
                realm.refresh()
                return realm.objects(T.self)
            }
            return nil
        }

}
