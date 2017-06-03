import Foundation


public enum Result<ValueType> {
    case success(ValueType)
    case failure(Error)
    
    public var value:ValueType? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error:Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

enum APIClientError: Error {
    case NoHTTPResponse
    case HTTPErro(statusCode: Int, errorDescription: String?)
    case NoData
    case JSONConversionFailed
}

fileprivate enum URLPaths: String {
    case apilayer = "http://www.apilayer.net/api/live?access_key=e871bc98f93d9b738b1b64546a645b3e&currencies=USD,EUR,GBP,AUD,CAD,AED"
}

public typealias JSON = Dictionary<String, Any>

class APIClient {
    
    static let shared = APIClient()
    private init() {}
    
    let sesstion = URLSession(configuration: URLSessionConfiguration.default)
    
    private func requestTask(with urlRequest: URLRequest, completion: @escaping (Result<Data>, HTTPURLResponse?) -> ()) -> URLSessionTask {
        return sesstion.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return completion(.failure(error!), response as? HTTPURLResponse)
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(APIClientError.NoHTTPResponse), response as? HTTPURLResponse)
            }
            guard let returnedData = data else {
                return completion(.failure(APIClientError.NoData), httpResponse)
            }
            guard(200...299).contains(httpResponse.statusCode) else {
                let responseBody: String?
                if let data = data {
                    responseBody = String(data: data, encoding: .utf8)
                } else {
                    responseBody = nil
                }
                return completion(.failure(APIClientError.HTTPErro(statusCode: httpResponse.statusCode, errorDescription: responseBody)), httpResponse)
            }
            completion(.success(returnedData), httpResponse)
        }
    }

    func fetchLatestCurrenciesWithResult(_ completion: @escaping (Result<[Currency]>) -> ()) -> URLSessionTask? {
        
        return requestTask(with: URLRequest(url: URL(string:URLPaths.apilayer.rawValue)!), completion: { result, response in
            switch result {
            case .success(let data):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                        throw APIClientError.JSONConversionFailed
                    }
                    if let quotes = json["quotes"] as? [String: Double]{
                        let currencies = quotes.map{Currency(name: $0.key, rate: $0.value)}
                        completion(.success(currencies))
                    } else {
                        throw APIClientError.JSONConversionFailed
                    }
                } catch let error as APIClientError {
                    completion(.failure(error))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
