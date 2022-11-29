//
//  Scripture.swift
//  Map Scriptures
//
//  Created by Stephen W. Liddle on 10/11/19.
//  Copyright © 2019 Stephen W. Liddle. All rights reserved.
//

import Foundation
import GRDB

struct Scripture : TableRecord, FetchableRecord {

    // MARK: - Constants

    struct Table {
        static let databaseTableName = "scripture"

        static let id = "ID"
        static let bookId = "BookID"
        static let chapter = "Chapter"
        static let verse = "Verse"
        static let flag = "Flag"
        static let text = "Text"
    }

    // MARK: - Properties

    var id: Int
    var bookId: Int
    var chapter: Int
    var verse: Int
    var flag: String
    var text: String

    // MARK: - Initialization
    
    init(row: Row) {
        id = row[Table.id]
        bookId = row[Table.bookId]
        chapter = row[Table.chapter]
        verse = row[Table.verse]
        flag = row[Table.flag]
        text = String(data: row[Table.text], encoding: .utf8)!
    }
}
