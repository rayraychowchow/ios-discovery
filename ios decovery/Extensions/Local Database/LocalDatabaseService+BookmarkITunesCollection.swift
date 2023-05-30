//
//  LocalDatabaseService+BookmarkITunesCollection.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation
import RealmSwift

extension LocalDatabaseService: LocalDatabaseITunesCollectionType {
    func getAllSavedITunesCollection() -> Results<iTunesCollectionObject>? {
        return realmManager.getAll()
    }
    
    func removeSavedCollection(object: iTunesCollectionObject) -> Bool {
        return realmManager.remove(object)
    }
    
    func saveITunesCollection(object: iTunesCollectionObject) -> Bool {
        return realmManager.save(object)
    }
}
