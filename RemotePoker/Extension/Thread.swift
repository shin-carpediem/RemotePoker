import Foundation

extension Thread {
    var isRunningXCTest: Bool {
        for key in self.threadDictionary.allKeys {
            guard let keyString = key as? String else {
                continue
            }

            if keyString.split(separator: ".").contains("xctest") {
                return true
            }
        }
        return false
    }
}
