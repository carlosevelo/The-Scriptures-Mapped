//
//  Book.swift
//  Map Scriptures
//
//  Created by Stephen W. Liddle on 10/11/19.
//  Copyright © 2019 Stephen W. Liddle. All rights reserved.
//

import Foundation
import GRDB

struct Book : TableRecord, FetchableRecord, Hashable {
    
    // MARK: - Constants

    struct Table {
        static let databaseTableName = "book"

        static let id = "ID"
        static let abbr = "Abbr"
        static let citeAbbr = "CiteAbbr"
        static let citeFull = "CiteFull"
        static let fullName = "FullName"
        static let numChapters = "NumChapters"
        static let parentBookId = "ParentBookId"
        static let webTitle = "WebTitle"
        static let tocName = "TOCName"
        static let subdiv = "Subdiv"
        static let backName = "BackName"
        static let gridName = "GridName"
        static let heading2 = "Heading2"
    }

    // MARK: - Properties
    
    var id: Int             // Surrogate ID (1, 2, 3, 4, 5, 101, 102, ...)
    var abbr: String        // Internal abbrevation (gen, ex)
    var citeAbbr: String    // Abbreviation suitable for use in citation (Gen., Ex.)
    var fullName: String    // Full name of the book
    var numChapters: Int?   // Number of chapters in this book
    var parentBookId: Int?  // ID of parent book (null for volumes)
    var webTitle: String    // Title suitable for displaying in web page
    var tocName: String     // Name suitable for use in table of contents
    var subdiv: String?     // Name of subdivisions of this book (Chapter, Psalm)
    var backName: String    // Name suitable for use in a back button
    var gridName: String    // Name suitable for use in a grid of book buttons
    var citeFull: String    // Full citation name for this book (Genesis, Exodus)
    var heading2: String    // Secondary heading used for most books (CHAPTER, PSALM)
    
    // MARK: - Initialization
    
    init() {
        id = 0
        abbr = ""
        citeAbbr = ""
        fullName = ""
        webTitle = ""
        tocName = ""
        backName = ""
        gridName = ""
        citeFull = ""
        heading2 = ""
    }

    init(row: Row) {
        id = row[Table.id]
        abbr = row[Table.abbr]
        citeAbbr = row[Table.citeAbbr]
        citeFull = row[Table.citeFull]
        fullName = row[Table.fullName]
        numChapters = row[Table.numChapters]
        parentBookId = row[Table.parentBookId]
        webTitle = row[Table.webTitle]
        tocName = row[Table.tocName]
        subdiv = row[Table.subdiv]
        backName = row[Table.backName]
        gridName = row[Table.gridName]
        heading2 = row[Table.heading2]
    }
}
