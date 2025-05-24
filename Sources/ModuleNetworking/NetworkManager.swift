import Foundation

public class NetworkManager {
    public init() {}

    public func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}