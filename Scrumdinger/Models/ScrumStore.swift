import Foundation
import SwiftUI

class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("scrums.data")
    }
    
    static func load() async throws -> [DailyScrum] {
        try await withCheckedContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error as! Never)
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[DailyScrum], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                // ユーザーがアプリを初めて起動したときには存在しないため、
                // ファイルハンドルを開くときにエラーが発生した場合は、
                // 空の配列を使用して完了ハンドラーを呼び出す。
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(dailyScrums))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // 戻り値を無視
    @discardableResult
    static func save(scrums: [DailyScrum]) async throws -> Int {
        try await withCheckedContinuation { continuation in
            save(scrums: scrums) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error as! Never)
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }
    
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
