import Foundation

class SessionNetworking {
  typealias JSONObject = [String: Any]
  typealias RequestResponseHandler = (Data?) -> ()

  private static let session: URLSession = {
    let config = URLSessionConfiguration.default
    return URLSession(configuration: config)
  }()

  // TODO: Use Success and Failure enum
  // http://alisoftware.github.io/swift/async/error/2016/02/06/async-errors/
  static func get(url: URL, completionHandler: @escaping (_ data: Any) -> Void, withToken: Bool) throws {
    let request = try self.makeGetUrlRequest(url: url, withToken: true)

    let task = session.dataTask(with: request, completionHandler: {
      (data, response, error) -> Void in
      if let jsonData = data {
        do {
          let decoded = try JSONSerialization.jsonObject(with: jsonData)
          if let jsonObject = decoded as? [String: Any] {
            if (jsonObject["success"] as? Int != 1) {
              if let message = jsonObject["message"] as? String {
                throw NSError(domain: message, code: 42)
              } else {
                throw NSError(domain: "Unknown error", code: 42)
              }
            } else if let data = jsonObject["data"] {
              completionHandler(data)
            }
          }
        } catch {
          //throw error
        }
      } else if let requestError = error {
        //throw NSError(domain: "Error fetching \(url.path): \(requestError)", code: 42)
      } else {
        //throw NSError(domain: "Unexpected error with the request", code: 42)
      }
    })

    task.resume()
  }

  private static func makeGetUrlRequest(url: URL, withToken: Bool) throws -> URLRequest {
    return try makeUrlRequest(url: url, httpMethod: "GET", withToken: withToken)
  }

  private static func makePostUrlRequest(url: URL, withToken: Bool, jsonObject: JSONObject = [:]) throws -> URLRequest {
    return try makeUrlRequest(url: url, httpMethod: "POST", withToken: withToken, jsonObject: jsonObject)
  }

  private static func makeUrlRequest(url: URL, httpMethod: String, withToken: Bool, jsonObject: JSONObject = [:]) throws -> URLRequest {
    var rq = URLRequest(url: url)
    rq.httpMethod = httpMethod
    rq.addValue("application/json", forHTTPHeaderField: "Content-Type")
    rq.addValue("application/json", forHTTPHeaderField: "Accept")
    if (withToken) {
      rq.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YmRlYzdkMTE0YzhmZDAwMTFkMDhiMTAiLCJpYXQiOjE1NDMxMjAxMzJ9.IEUh3Ur2BUtN02UNSmlStAZTx5c6QoKCrzcZREltPNI", forHTTPHeaderField: "token")
    }
    if (!jsonObject.isEmpty) {
      rq.httpBody = try JSONSerialization.data(withJSONObject: jsonObject)
    }
    return rq
  }
}
