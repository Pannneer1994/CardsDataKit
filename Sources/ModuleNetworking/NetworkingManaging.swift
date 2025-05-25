import Foundation

public protocol NetworkingManaging {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}