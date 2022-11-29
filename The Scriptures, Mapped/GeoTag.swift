//
//  GeoTag.swift
//  Map Scriptures
//
//  Created by Steve Liddle on 10/28/19.
//  Copyright © 2019 IS 543. All rights reserved.
//

import Foundation
import GRDB

struct GeoTag : TableRecord, FetchableRecord {

    // MARK: - Constants

    struct Table {
        static let databaseTableName = "geotag"

        static let geoplaceId = "GeoplaceId"
        static let scriptureId = "ScriptureId"
        static let startOffset = "StartOffset"
        static let endOffset = "EndOffset"
    }

    // MARK: - Properties

    var geoplaceId: Int
    var scriptureId: Int
    var startOffset: Int
    var endOffset: Int

    // MARK: - Initialization

    init(row: Row) {
        geoplaceId = row[Table.geoplaceId]
        scriptureId = row[Table.scriptureId]
        startOffset = row[Table.startOffset]
        endOffset = row[Table.endOffset]
    }
}
