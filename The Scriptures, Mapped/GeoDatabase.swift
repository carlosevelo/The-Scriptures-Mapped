//
//  GeoDatabase.swift
//  Map Scriptures
//
//  Created by Stephen W. Liddle on 10/5/19.
//  Copyright (c) 2019 IS 543. All rights reserved.
//

import Foundation
import GRDB

class GeoDatabase {

    // MARK: - Constants

    struct Constant {
        static let fileName = "geo.21"
        static let fileExtension = "sqlite"
    }
    
    // MARK: - Properties

    var dbQueue: DatabaseQueue

    // MARK: - Singleton

    static let shared = GeoDatabase()

    private init() {
        if let path = Bundle.main.path(forResource: Constant.fileName,
                                       ofType: Constant.fileExtension) {
            if let queue = try? DatabaseQueue(path: path) {
                dbQueue = queue
                return
            }
        }

        fatalError("Unable to connect to database")
    }

    // MARK: - Helpers

    //
    // Return a Book object for the given book ID.
    //
    func bookForId(_ bookId: Int) -> Book {
        do {
            let book = try dbQueue.inDatabase { (db: Database) -> Book in
                let row = try Row.fetchOne(db,
                                           sql: """
                                                select * from \(Book.Table.databaseTableName) \
                                                where \(Book.Table.id) = ?
                                                """,
                                           arguments: [ bookId ])
                if let returnedRow = row {
                    return Book(row: returnedRow)
                }

                return Book()
            }
            
            return book
        } catch {
            return Book()
        }
    }

    //
    // Return array of Book objects for the given volume ID (i.e. parent book ID).
    //
    func booksForParentId(_ parentBookId: Int) -> [Book] {
        do {
            let books = try dbQueue.inDatabase { (db: Database) -> [Book] in
                var books = [Book]()
                
                let rows = try Row.fetchCursor(db,
                                               sql: """
                                                    select * from \(Book.Table.databaseTableName) \
                                                    where \(Book.Table.parentBookId) = ? \
                                                    order by \(Book.Table.id)
                                                    """,
                                               arguments: [ parentBookId ])
                while let row = try rows.next() {
                    books.append(Book(row: row))
                }

                return books
            }

            return books
        } catch {
            return []
        }
    }

    //
    // Return the GeoPlace corresponding to the given ID.
    //
    func geoPlaceForId(_ geoplaceId: Int) -> GeoPlace? {
        do {
            let geoplace = try dbQueue.inDatabase { (db: Database) -> GeoPlace? in
                let row = try Row.fetchOne(db,
                                           sql: """
                                                select * from \(GeoPlace.databaseTableName) \
                                                where \(GeoPlace.Table.id) = ?
                                                """,
                                           arguments: [ geoplaceId ])
                if let returnedRow = row {
                    return GeoPlace(row: returnedRow)
                }

                return nil
            }

            return geoplace
        } catch {
            return nil
        }
    }

    //
    // Return a query that will generate the join of geotags and geoplaces for
    // a given scripture ID.
    //
    func geoTagsForScriptureId(_ scriptureId: Int) -> [(GeoPlace, GeoTag)] {
        do {
            let geotags = try dbQueue.inDatabase { (db: Database) -> [(GeoPlace, GeoTag)] in
                var geotags = [(GeoPlace, GeoTag)]()

                for row in try Row.fetchAll(db,
                                            sql: """
                                                 select * from \(GeoTag.databaseTableName) \
                                                 join \(GeoPlace.databaseTableName) \
                                                 where \(GeoTag.Table.geoplaceId) = \(GeoPlace.Table.id) \
                                                 and \(GeoTag.Table.scriptureId) = ? \
                                                 order by \(GeoTag.Table.endOffset) desc
                                                 """,
                                            arguments: [ scriptureId ]) {
                    geotags.append((GeoPlace(row: row), GeoTag(row: row)))
                }

                return geotags
            }

            return geotags
        } catch {
            return []
        }
    }

    //
    // Return a query that will generate all verses for a given book ID and chapter.
    //
    func versesForScriptureBookId(_ bookId: Int, _ chapter: Int) -> [Scripture] {
        do {
            let verses = try dbQueue.inDatabase { (db: Database) -> [Scripture] in
                var verses = [Scripture]()

                for row in try Row.fetchAll(db,
                                            sql: """
                                                 select * from \(Scripture.databaseTableName) \
                                                 where \(Scripture.Table .bookId) = ? \
                                                 and \(Scripture.Table .chapter) = ? \
                                                 order by \(Scripture.Table .verse)
                                                 """,
                                            arguments: [ bookId, chapter ]) {
                    verses.append(Scripture(row: row))
                }

                return verses
            }

            return verses
        } catch {
            return []
        }
    }

    //
    // Return an array of strings listing the titles of all scripture volumes.
    //
    func volumes() -> [Book] {
        do {
            let volumes = try dbQueue.inDatabase { (db: Database) -> [Book] in
                var volumes = [Book]()
                
                for row in try Row.fetchAll(db,
                                            sql: """
                                                 select * from \(Book.databaseTableName) \
                                                 where \(Book.Table .parentBookId) is null \
                                                 order by \(Book.Table .id)
                                                 """) {
                    volumes.append(Book(row: row))
                }

                return volumes
            }

            return volumes
        } catch {
            return []
        }
        // NEEDSWORK: get this from the database -- don't hard-code anything
//        return ["Old Testament", "New Testament", "Book of Mormon",
//                "Doctrine and Covenants", "Pearl of Great Price"]
    }
}
