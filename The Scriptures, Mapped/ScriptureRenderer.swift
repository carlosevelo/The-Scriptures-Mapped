//
//  ScriptureRenderer.swift
//  Map Scriptures
//
//  Created by Stephen W. Liddle on 10/24/19.
//  Copyright (c) 2019 IS 543. All rights reserved.
//

import Foundation

// MARK: - ScriptureRenderer class
//
// There are three things you need to know about ScriptureRenderer:
//
// 1. This is a singleton, accessed by ScriptureRenderer.shared.
// 2. There are two public methods, htmlForBookId(bookId:chapter:),
//    and injectGeoPlaceCollector().
// 3. Whenever you use htmlForBookId(), it has a side effect.  If you
//    have supplied a GeoPlaceCollector, htmlForBookId() passes any
//    geoplaces for this book/chapter to the collector for processing.
//
// So you use this class by injecting a GeoPlaceCollector into the singleton
// with ScriptureRenderer.shared.injectGeoPlaceCollector(collector) and
// then calling ScriptureRenderer.shared.htmlForBookId(bookId:chapter:)
// whenever you want the HTML for a chapter in the scriptures.

class ScriptureRenderer {

    // MARK: - Constants

    struct Constant {
        static let baseUrl = "https://scriptures.byu.edu/mapscrip/"
        static let classHeadVerse = "headVerse"
        static let classVerse = "verse"
        static let footnoteVerse = 1000
        static let headVerseFlag = "H"
        static let renderLongTitles = true
    }

    // MARK: - Properties

    private var collectedGeocodedPlaces = [GeoPlace]()

    private var geoPlaceCollector: GeoPlaceCollector?

    private lazy var scriptureStyle: String =
        tagWithBundleFileContents(tag: "style", tagType: "text/css",
                                  resource: "scripture", type: "css")

    private lazy var scriptureScript: String =
        tagWithBundleFileContents(tag: "script", tagType: "text/javascript",
                                  resource: "geocode", type: "js")

    // MARK: - Singleton

    // See http://bit.ly/1tdRybj for a discussion of this singleton pattern.
    static let shared = ScriptureRenderer()

    private init() {
        // This guarantees that code outside this file can't instantiate a ScriptureRenderer.
        // So others must use the shared singleton.
    }

    // MARK: - Helpers

    func htmlForBookId(_ bookId: Int, chapter: Int) -> String {
        let book = GeoDatabase.shared.bookForId(bookId)

        collectedGeocodedPlaces = [GeoPlace]()

        var page = """
                   <!doctype html>
                   <html>
                   <head>
                       <title>\(titleForBook(book, chapter, Constant.renderLongTitles))</title>
                       \(scriptureStyle)
                       <meta name="viewport" content="initial-scale=1.0, user-scalable=NO" />
                   </head>
                   <body>
                       <div class="heading1">\(book.webTitle)</div>
                       <div class="heading2">\(secondaryHeadingForBook(book, chapter: chapter))</div>
                       <div class="chapter">
                       \(versesForBookId(bookId, chapter: chapter))
                       </div>
                   </body>
                   \(scriptureScript)
                   </html>
                   """

        if let collector = geoPlaceCollector {
            collector.setGeocodedPlaces(collectedGeocodedPlaces)
            
        }

        return page.convertToHtmlEntities()
    }

    func injectGeoPlaceCollector(_ collector: GeoPlaceCollector) {
        geoPlaceCollector = collector
    }

    // MARK: - Private helpers

    private func classForVerse(_ verse: Scripture) -> String {
        if verse.flag == Constant.headVerseFlag {
            return Constant.classHeadVerse
        }

        return Constant.classVerse
    }

    private func collectGeoPlace(_ geoplace: GeoPlace) {
        collectedGeocodedPlaces.append(geoplace)
    }

    private func endIndexInVerse(_ verseText: String, for geotag: GeoTag,
                                 from startIndex: String.Index) -> String.Index {
        return verseText.index(startIndex, offsetBy: geotag.endOffset - geotag.startOffset)
    }

    private func geocodedTextForVerseText(_ originalVerseText: String, _ scriptureId: Int) -> String {
        var verseText = originalVerseText

        for (geoplace, geotag) in GeoDatabase.shared.geoTagsForScriptureId(scriptureId) {
            collectGeoPlace(geoplace)
            verseText = hyperlinkedText(for: verseText, of: geoplace, with: geotag)
        }

        return verseText
    }

    private func hyperlinkedText(for verseText: String, of geoplace: GeoPlace,
                                 with geotag: GeoTag) -> String {
        let startIndex = startIndexInVerse(verseText, for: geotag)
        let endIndex = endIndexInVerse(verseText, for: geotag, from: startIndex)

        return """
               \(verseText[..<startIndex])\
               <a href="\(Constant.baseUrl)\(geoplace.id)">\
               \(verseText[startIndex ..< endIndex])</a>\
               \(verseText[endIndex...])
               """
    }

    private func isSupplementary(_ book: Book) -> Bool {
        return book.numChapters == nil && book.parentBookId != nil;
    }

    private func secondaryHeadingForBook(_ book: Book, chapter: Int) -> String {
        if !isSupplementary(book) {
            if book.heading2 != "" {
                return "\(book.heading2)\(chapter)"
            }
        }

        return ""
    }

    private func spanForVerseNumber(_ verseNumber: Int) -> String {
        if verseNumber > 1 && verseNumber < Constant.footnoteVerse {
            return """
                   <span class="verseNumber">\(verseNumber)</span>
                   """
        }

        return ""
    }

    private func startIndexInVerse(_ verseText: String, for geotag: GeoTag) -> String.Index {
        return verseText.index(verseText.startIndex, offsetBy: geotag.startOffset)
    }

    private func tagWithBundleFileContents(tag: String, tagType: String,
                                           resource: String, type: String) -> String {
        if let path = Bundle.main.path(forResource: resource, ofType: type) {
            if let contents = try? String(contentsOfFile: path, encoding: .utf8) {
                return """
                       <\(tag) type="\(tagType)">
                           \(contents)
                       </\(tag)>
                       """
            }
        }

        return ""
    }

    private func titleForBook(_ book: Book, _ chapter: Int, _ renderLongTitles: Bool) -> String {
        var title = renderLongTitles ? book.citeFull : book.citeAbbr
        let numChapters = book.numChapters ?? 0

        if chapter > 0 && numChapters > 1 {
            title += " \(chapter)"
        }

        return title
    }

    private func versesForBookId(_ bookId: Int, chapter: Int) -> String {
        var verses = ""

        for scripture in GeoDatabase.shared.versesForScriptureBookId(bookId, chapter) {
            verses = """
                    \(verses)\
                    <a name="\(scripture.verse)">\
                    <div class="\(classForVerse(scripture))">\
                    \(spanForVerseNumber(scripture.verse))
                    \(geocodedTextForVerseText(scripture.text, scripture.id))
                    </div>
                    """
        }

        return verses
    }
}
