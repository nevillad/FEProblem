//
//  FENetworkService.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//

import Foundation

enum CustomResult<T> {
    case success(T)
    case failure(Error)
}

enum CustomeErrors: Error {
    case backend
    case decodingFailed
    case dataUnavailable
    case custome(message: String)
    ///To show  bottom error prompt with user action
    case customErrorPrompt(message: String)
    ///To show top bar error pop up/ banner with auto dismissal
    case customErrorPopup(message: String)
}

/// HTTP method type
enum HTTPMethod {
    case GET,POST,DELETE,PUT
    var value : String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .DELETE:
            return "DELETE"
        case .PUT:
            return "PUT"
        }
    }
}

struct Resource<T: Decodable> {
    let url: String
    var httpMethod = HTTPMethod.GET.value
    var useCacheResponse: Bool = true
}

final class FENetworkServices {

    static let shared = FENetworkServices()

    ///size define for cache
    private let size = 10 * 1024 * 1024

    private lazy var urlCache: URLCache = {
        /// here we can also define storage path using : URLCache(memoryCapacity: , diskCapacity: , directory: )
        return URLCache(memoryCapacity: 0, diskCapacity: size, diskPath: "FEProblemAppAPICache")
    }()


    func urlSession() -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = urlCache
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: sessionConfig)
    }


    func fetchJson<T>(resource: Resource<T>,
                      completion: @escaping(CustomResult<T>) -> Void) {


        guard let serverURL = URL(string: resource.url) else {
            completion(.failure(CustomeErrors.dataUnavailable))
            return
        }

        var urlRequest = URLRequest(url: serverURL)
        urlRequest.httpMethod = resource.httpMethod


        // Single request in a day
        // Load offline data if available
        //Step 1: Retrive url reponse cached for url request
        //Step 2: Check if url reponse cached is of same day
        ///If data is of same day retunr clouser with cached data
        //Step 3: if response data found then cache those data
        /// NOTE: nagative case not handle here assume response get success with 200 status code
        //Step 4: Return local cache data if error occuered OR data not available
        ///Retrive url reponse cached for url request

        var apiCachedResponse: CachedURLResponse?
        if let cacheData = urlCache.cachedResponse(for: urlRequest) {
            apiCachedResponse = cacheData
            //Step 2
            ///Check if url reponse cached is of same day
            ///If data is of same day retunr clouser with cached data
            if let userInfo = cacheData.userInfo, let dateTime = userInfo[kDateTime] as? Date, Calendar.current.isDateInToday(dateTime), let decodeData = try? JSONDecoder().decode(T.self, from: cacheData.data) {
                completion(.success(decodeData))
                return
            }
        }

        let session = urlSession()
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data,response,error) in
            DispatchQueue.main.async {
                if error != nil {
                    //Step 4
                    /// return local cache data if error occuered and data not available
                    if let cacheData = apiCachedResponse, let decodeData = try? JSONDecoder().decode(T.self, from: cacheData.data)  {
                        completion(.success(decodeData))
                        return
                    } else {
                        completion(.failure(CustomeErrors.backend))
                        return
                    }
                }

                debugPrint("APIClient :: Server data return using API calling")
                if let responseObject = response as? HTTPURLResponse {
                    if responseObject.statusCode == 200, let responseData = data {
                        //Step 3
                        /// if response data found then cache those data
                        /// NOTE: nagative case not handle here assume response get success with 200 status code
                        urlRequest.url = serverURL
                        let userInfo = [kDateTime: Date()]
                        let cachedResponse = CachedURLResponse(response: responseObject, data: responseData, userInfo: userInfo, storagePolicy: .allowed)
                        self.urlCache.storeCachedResponse(cachedResponse, for: urlRequest)
                        if let decodeData = try? JSONDecoder().decode(T.self, from: responseData) {
                            completion(.success(decodeData))
                        }
                        //completionHandler(try? newJSONDecoder().decode(T.self, from: responseData), response, nil)
                        return
                    } else {
                        completion(.failure(CustomeErrors.backend))
                        return
                    }
                } else {
                    //Step 4
                    /// return local cache data if error occuered and data not available
                    if let cacheData = apiCachedResponse, let decodeData = try? JSONDecoder().decode(T.self, from: cacheData.data)  {
                        completion(.success(decodeData))
                        return
                    } else {
                        completion(.failure(CustomeErrors.backend))
                        return
                    }
                }
            }

        })
        task.resume()
    }
}

