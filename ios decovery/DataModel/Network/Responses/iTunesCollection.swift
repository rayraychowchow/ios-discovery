//
//  iTunesCollection.swift
//  ios decovery
//
//  Created by Ray Chow on 29/5/2023.
//

import Foundation

struct iTunesCollection: Codable {
    
    var wrapperType: String? = ""
    var collectionType: String? = ""
    var artistId: Int? = 0
    var collectionId: Int? = 0
    var amgArtistId: Int? = 0
    var artistName: String? = ""
    var collectionName: String? = ""
    var collectionCensoredName: String? = ""
    var artistViewUrl: String? = ""
    var collectionViewUrl: String? = ""
    var artworkUrl60: String? = ""
    var artworkUrl100: String? = ""
    var collectionPrice: Double? = 0
    var collectionExplicitness: String? = ""
    var trackCount: Int? = 0
    var copyright: String? = ""
    var country: String? = ""
    var currency: String? = ""
    var releaseDate: Date? = Date() //"2005-03-01T08:00:00Z"
    var primaryGenreName: String? = ""
    var bookmarked: Bool? = false
}

class iTunesCollectionObject {
    @objc dynamic var wrapperType: String = ""
    @objc dynamic var collectionType: String = ""
    @objc dynamic var artistId: Int = 0
    @objc dynamic var collectionId: Int = 0
    @objc dynamic var amgArtistId: Int = 0
    @objc dynamic var artistName: String = ""
    @objc dynamic var collectionName: String = ""
    @objc dynamic var collectionCensoredName: String = ""
    @objc dynamic var artistViewUrl: String = ""
    @objc dynamic var collectionViewUrl: String = ""
    @objc dynamic var artworkUrl60: String = ""
    @objc dynamic var artworkUrl100: String = ""
    @objc dynamic var collectionPrice: Double = 0
    @objc dynamic var collectionExplicitness: String = ""
    @objc dynamic var trackCount: Int = 0
    @objc dynamic var copyright: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var currency: String = ""
    @objc dynamic var releaseDate: Date = Date() //"2005-03-01T08:00:00Z"
    @objc dynamic var primaryGenreName: String = ""
    
//    static func convertFromITunesCollection(collection: iTunesCollection) -> iTunesCollectionObject {
//        let object = iTunesCollectionObject()
//        object.wrapperType = collection.wrapperType
//        object.collectionType = collection.collectionType
//        object.artistId = collection.artistId
//        object.collectionId = collection.collectionId
//        object.amgArtistId = collection.amgArtistId
//        object.artistName = collection.artistName
//        object.collectionName = collection.collectionName
//        object.collectionCensoredName = collection.collectionCensoredName
//        object.artistViewUrl = collection.artistViewUrl
//        object.collectionViewUrl = collection.collectionViewUrl
//        object.artworkUrl60 = collection.artworkUrl60
//        object.artworkUrl100 = collection.artworkUrl100
//        object.collectionPrice = collection.collectionPrice
//        object.collectionExplicitness = collection.collectionExplicitness
//        object.trackCount = collection.trackCount
//        object.copyright = collection.copyright
//        object.country = collection.country
//        object.currency = collection.currency
//        object.releaseDate = collection.releaseDate
//        object.primaryGenreName = collection.primaryGenreName
//        return object
//    }

}
