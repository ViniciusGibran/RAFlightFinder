import Foundation
import Combine

final class APIError: Error, LocalizedError {
    
    enum ErrorType {
        case unknown, apiError(reason: String), notFound
    }
    
    var errorType: ErrorType
    
    init(_ errorType: APIError.ErrorType) {
        self.errorType = errorType
    }
    
    var errorDescription: String {
        switch errorType {
        case .unknown:
            return "Oops. Something went wrong! 💔"
        case .apiError(let reason):
            return reason
        case .notFound:
            return ""
        }
    }
}

class APIRequest: NSObject {
    var cancellable = Set<AnyCancellable>()
    let decoder: JSONDecoder = JSONDecoder()
    
    func fetchDataFrom(
        baseURL: String,
        endpoint: String,
        query: [String: Any] = [:],
        httpMethod: String
    ) -> AnyPublisher<Data, APIError> {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)")
        else { return Fail(error: APIError(.notFound)).eraseToAnyPublisher() }
        
        let params = try? JSONSerialization.data(withJSONObject: query)
        var request = URLRequest(url: url)
        request.httpBody = query.isEmpty ? nil : params
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ios", forHTTPHeaderField: "client") 
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError(.unknown)
                }
                if 200..<300 ~= httpResponse.statusCode {
                    return data
                } else if httpResponse.statusCode == 404 {
                    throw APIError(.notFound)
                } else {
                    throw APIError(.apiError(reason: "Server returned status code \(httpResponse.statusCode)"))
                }
            }
            .mapError { error in
                guard let error = error as? APIError
                else { return APIError(.apiError(reason: error.localizedDescription)) }
                
                return error
            }
            .eraseToAnyPublisher()
    }
}
