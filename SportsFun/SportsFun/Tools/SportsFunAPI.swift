import Foundation

enum Endpoint: String {
  case userSearch = "/api/user/p/%@"
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

}