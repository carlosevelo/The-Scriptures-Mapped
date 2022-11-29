//
//  GeoPlace.swift
//  Map Scriptures
//
//  Created by Stephen W. Liddle on 10/11/19.
//  Copyright © 2019 Stephen W. Liddle. All rights reserved.
//

import Foundation
import GRDB

struct GeoPlace : TableRecord, FetchableRecord {

    // MARK: - Constants

    struct Table {
        static let databaseTableName = "geoplace"

        static let id = "Id"
        static let placename = "Placename"
        static let latitude = "Latitude"
        static let longitude = "Longitude"
        static let flag = "Flag"
        static let viewLatitude = "ViewLatitude"
        static let viewLongitude = "ViewLongitude"
        static let viewTilt = "ViewTilt"
        static let viewRoll = "ViewRoll"
        static let viewAltitude = "ViewAltitude"
        static let viewHeading = "ViewHeading"
        static let category = "Category"
    }

    // MARK: - Nested types

    enum GeoFlag: String {
        // Flags indicate different levels of certainty in the Open Bible database
        case None = "",
        Open1 = "~",
        Open2 = ">",
        Open3 = "?",
        Open4 = "<",
        Open5 = "+"
    }

    // MARK: - Properties

    var id: Int
    var placename: String
    var latitude: Double
    var longitude: Double
    var flag: GeoFlag
    var viewLatitude: Double?
    var viewLongitude: Double?
    var viewTilt: Double?
    var viewRoll: Double?
    var viewAltitude: Double?
    var viewHeading: Double?
    var category: GeoCategory.Category?

    // MARK: - Initialization

    init(row: Row) {
        id = row[Table.id]
        placename = row[Table.placename]
        latitude = row[Table.latitude]
        longitude = row[Table.longitude]
        category = GeoCategory.Category(rawValue: row[Table.category])

        flag = GeoPlace.geoFlagFromString(row[Table.flag]) ?? .None

        if let vLatitude = row[Table.viewLatitude] as? Double {
            viewLatitude = vLatitude
            viewLongitude = row[Table.viewLongitude]
            viewTilt = row[Table.viewTilt]
            viewRoll = row[Table.viewRoll]
            viewAltitude = row[Table.viewAltitude]
            viewHeading = row[Table.viewHeading]
        }
    }

    // MARK: - Helpers

    // This helper is static because I need to use it in the initializer
    // (before all properties have been initialized), and you can't do
    // that in Swift with a non-static instance method.
    private static func geoFlagFromString(_ flagString: DatabaseValueConvertible?) -> GeoFlag? {
        if let geoFlagString = flagString as? String {
            if let geoFlag = GeoFlag(rawValue: geoFlagString) {
                return geoFlag
            }
        }

        return nil
    }
}
