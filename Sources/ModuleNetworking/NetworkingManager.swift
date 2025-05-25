import Foundation

// MARK: - Networking Manager

/// A basic implementation of `NetworkingManaging` that uses `URLSession`
/// to fetch raw data from a given URL.
public class NetworkingManager: NetworkingManaging {
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `NetworkingManager`.
    public init() {}
    
    // MARK: - Data Fetching
    
    /// Fetches data from the specified URL asynchronously.
    ///
    /// - Parameters:
    ///   - url: The URL from which to fetch the data.
    ///   - completion: A closure that returns either the fetched `Data` on success,
    ///                 or an `Error` on failure.
    public func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        // Create a data task with the given URL
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                // Handle error response
                completion(.failure(error))
            } else if let data = data {
                // Handle success with received data
                completion(.success(data))
            } else {
                // No data and no error (shouldn't happen often)
                completion(.failure(NSError(domain: "NetworkingError", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Unknown error occurred while fetching data."
                ])))
            }
        }
        
        // Start the network request
        task.resume()
    }
}
