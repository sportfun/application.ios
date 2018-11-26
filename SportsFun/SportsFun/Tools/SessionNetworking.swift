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
  static func get(url: URL, completionHandler: @escaping (_ data: JSONObject) -> Void, withToken: Bool) throws {
    let request = try self.makeGetUrlRequest(url: url, withToken: true)

    let task = session.dataTask(with: request, completionHandler: {
      (data, response, error) -> Void in
      if let jsonData = data {
        do {
          let decoded = try JSONSerialization.jsonObject(with: jsonData)
          if let jsonObject = decoded as? JSONObject {
            completionHandler(jsonObject)
          } else {
            completionHandler(["Success": false])
          }
        } catch {
          completionHandler(["Success": false])
        }
      } else {
        completionHandler(["Success": false])
      }
    })

    task.resume()
  }

  static func put(url: URL, completionHandler: @escaping (_ data: JSONObject) -> Void, withToken: Bool) throws {
    let request = try self.makePutUrlRequest(url: url, withToken: true)

    let task = session.dataTask(with: request, completionHandler: {
      (data, response, error) -> Void in
      if let jsonData = data {
        do {
          let decoded = try JSONSerialization.jsonObject(with: jsonData)
          if let jsonObject = decoded as? JSONObject {
            completionHandler(jsonObject)
          } else {
            completionHandler(["Success": false])
          }
        } catch {
          completionHandler(["Success": false])
        }
      } else {
        completionHandler(["Success": false])
      }
    })

    task.resume()
  }

  private static func makeGetUrlRequest(url: URL, withToken: Bool) throws -> URLRequest {
    return try makeUrlRequest(url: url, httpMethod: "GET", withToken: withToken)
  }

  private static func makePutUrlRequest(url: URL, withToken: Bool) throws -> URLRequest {
    return try makeUrlRequest(url: url, httpMethod: "PUT", withToken: withToken)
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
      do {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
          let fileURL = documentDirectory.appendingPathComponent("token.txt")
          let token = try String(contentsOf: fileURL)
          rq.addValue(token, forHTTPHeaderField: "token")
        }
      } catch {
        print(error)
      }
    }
    if (!jsonObject.isEmpty) {
      rq.httpBody = try JSONSerialization.data(withJSONObject: jsonObject)
    }
    return rq
  }
}
