//
//  DataFile.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftyJSON

class DataFile {
    static func sampleTextFileURL(fileSuffix: String) -> URL {
        let bundle = Bundle(for: JsonDataTests.self)
        return bundle.url(forResource: fileSuffix, withExtension: "json")!
    }

    static func readBundleJson(fileSuffix: String) throws -> JSON {
        let contents: String = try String(contentsOf: sampleTextFileURL(fileSuffix: fileSuffix))
        print(contents)
        if let string = contents.data(using: .utf8, allowLossyConversion: false) {
            let json: JSON = try JSON(data: string)
            return json
        }

        throw "sampleTextFileURL error"
    }

    static func writeToUrl(jsonString: String) -> URL? {
        let fileName: URL = getDocumentsDirectory().appendingPathComponent("output.txt")

        do {
            try jsonString.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)

            return fileName
        } catch {
            print("\(error.localizedDescription)")
        }

        return nil
    }

    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension String: Error {}
