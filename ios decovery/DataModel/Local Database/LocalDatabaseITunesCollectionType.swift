//
//  LocalDatabaseITunesCollectionType.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation
import RealmSwift

protocol LocalDatabaseITunesCollectionType {
    func getAllSavedITunesCollection() -> Results<iTunesCollectionObject>?
    func removeSavedCollection(object: iTunesCollectionObject) -> Bool
    func saveITunesCollection(object: iTunesCollectionObject) -> Bool
}
