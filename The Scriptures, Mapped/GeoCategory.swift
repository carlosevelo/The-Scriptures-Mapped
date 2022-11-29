//
//  GeoCategory.swift
//  Map Scriptures
//
//  Created by Steve Liddle on 10/28/19.
//  Copyright © 2019 IS 543. All rights reserved.
//

import Foundation
import GRDB

struct GeoCategory : TableRecord, FetchableRecord {

    // MARK: - Constants

    struct Table {
        static let databaseTableName = "geocategory"

        static let id = "Id"
        static let category = "Category"
    }

    // MARK: - Nested types

    enum Category: Int {
        // Categories represent geocoded places we've constructed from various
        // Church history sources (1) or the Open Bible project (2)
        case churchHistory = 1,
        openBible = 2
    }

    // MARK: - Properties

    var id: Int
    var category: Category

    // MARK: - Initialization

    init(row: Row) {
        id = row[Table.id]
        category = Category(rawValue: row[Table.category])!
    }
}
