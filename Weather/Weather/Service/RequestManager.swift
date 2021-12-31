//
//  RequestManager.swift
//  Weather
//
//  Created by Mohammed Aleem on 26/12/21.
//

import Foundation

typealias ServerResult<T> = Result<T, Error>

enum WeatherError: Error {
 case invalidURL
}

class RequestManager {
    private init(){ }
    static let shared = RequestManager()
    private var dataTask: URLSessionDataTask?
    private let session = URLSession(configuration: .default)
    
    func fetchData<T: Codable>(urlString: String, completion: @escaping(ServerResult<T>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(Result.failure(WeatherError.invalidURL))
            return
        }
        
        self.dataTask = session.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                print("DataTask error: " + error.localizedDescription)
                completion(Result.failure(error))
            } else if let data = data {
                self.logValues(request: urlString, data: data)
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(Result.success(result))
                } catch (let decodingError) {
                    print("Decoding Error error: " + decodingError.localizedDescription)
                    completion(Result.failure(decodingError))
                }
            }
        }
        self.dataTask?.resume()
    }
    
    private func logValues(request: String, data: Data) {
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(request + "\n" + jsonString)
            }
        } catch {
            print("JSONSerialization Error: " + error.localizedDescription)
        }
    }
}


