//
//  DataController+TestFile.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension DataController {
    @discardableResult
    func processArgumentsForTesting() -> Bool {
        if let index = ProcessInfo.processInfo
            .arguments.firstIndex(where: { $0 == "-fileUrlPath" })
        {
            let path: String = ProcessInfo.processInfo
                .arguments[index + 1]
            let url = URL(string: path)!
            let fileName: String?

            if let index = ProcessInfo.processInfo
                .arguments.firstIndex(where: { $0 == "-fileName" })
            {
                fileName = ProcessInfo.processInfo
                    .arguments[index + 1]
            } else {
                fileName = nil
            }

            copyTestFileLoadJson(url: url, fileName: fileName)

            return true
        }

        return false
    }

    private var documentDirectoryURLOfTheApp: URL {
        let fileManager: FileManager = FileManager.default
        let paths: [URL] = fileManager.urls(for: .documentDirectory, in: .allDomainsMask)
        let documentDirectoryPath: URL = paths.first!
        return documentDirectoryPath
    }

    @discardableResult
    private func copyTestFileLoadJson(url: URL, fileName: String? = nil) -> Bool {
        let fileManager: FileManager = FileManager.default
        let directory: URL = documentDirectoryURLOfTheApp
        let destination: String = directory
            .appendingPathComponent(fileName ?? url.lastPathComponent).path
        let isOkay: Bool

        do {
            if fileManager.fileExists(atPath: destination) {
                try fileManager.removeItem(atPath: destination)
            }
            try fileManager.copyItem(atPath: url.path, toPath: destination)

            if let temp = fileName {
                let path: URL = FileManager.default.urls(
                    for: .documentDirectory,
                    in: .userDomainMask)[0].appendingPathComponent(temp)

                let data = try String(contentsOf: path)

                try jsonToCoreData(data)
            }
            isOkay = true

        } catch {
            isOkay = false
        }
        return isOkay
    }
}
