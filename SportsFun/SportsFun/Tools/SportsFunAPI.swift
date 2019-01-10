import Foundation

enum Endpoint: String {
  case userSearch = "/api/user/p/%@"
  case userFollow = "/api/user/link/%@"
  case registerCode = "/api/qr"
  case gymSubscribe = "/api/user/sub/%@"
}

struct SportsFunAPI {

  static let baseURL = URL(string: "http://api.sportsfun.shr.ovh:8080")

  private static func sportsFunURL(endpoint: String) -> URL {
    let endpoint = baseURL?.appendingPathComponent(endpoint)
    return endpoint!
  }

  static func userSearch(username: String) -> URL {
    return sportsFunURL(endpoint: String(format: Endpoint.userSearch.rawValue, username))
  }

  static func userFollow(id: String) -> URL {
    return sportsFunURL(endpoint: String(format: Endpoint.userFollow.rawValue, id))
  }

  static func registerCode() -> URL {
    return sportsFunURL(endpoint: Endpoint.registerCode.rawValue)
  }

  static func subscribeGym(id: String) -> URL {
    return sportsFunURL(endpoint: String(format: Endpoint.gymSubscribe.rawValue, id))
  }

}
