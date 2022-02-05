//
//  JsonFileDocument.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import UniformTypeIdentifiers

struct JsonFileDocument: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.json]

    // by default our document is empty
    var text = ""

    // a simple initialised that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initialiser loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
