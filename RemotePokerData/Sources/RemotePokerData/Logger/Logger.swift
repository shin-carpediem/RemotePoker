import Foundation.NSBundle
import os.log

struct Log {
    static let main = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "main")
    
    // MARK: Private
    
    private init() {}
}
