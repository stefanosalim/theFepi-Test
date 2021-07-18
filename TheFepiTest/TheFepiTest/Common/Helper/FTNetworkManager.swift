//
//  FTNetworkManager.swift
//  TheFepiTest
//
//  Created by stefano.salim on 19/07/21.
//

import UIKit

protocol FTNetworkManagerProtocol {
    static var shared: Self { get }
    func fetch<T:Decodable>(urlString: String, completion: @escaping (T) -> ())
}

final class FTNetworkManager: FTNetworkManagerProtocol {
    
    static let shared: FTNetworkManager = FTNetworkManager()
    
    private init() {}
    
    func fetch<T:Decodable>(urlString: String, completion: @escaping (T) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(object)
                }
            }
            catch let jsonError {
                print("Parsing failed for:", jsonError)
            }
        }.resume()
    }
}
