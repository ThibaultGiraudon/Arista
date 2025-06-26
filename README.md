# 🚀 Vitesse

## Summary

- [Description](#description)
- [Installation](#installation)
- [Features](#features)
  - [API Integration](#api-integration)

---

## Description

**Vitesse** is an iOS application developed as part of my iOS developer training with OpenClassrooms.

This app is designed to help manage job candidates. Users can:

- View a list of candidates
- Add new candidates
- Edit existing ones
- Delete candidates
- Mark/unmark candidates as favorites

The application communicates with a Swift backend API for all data operations.

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/ThibaultGiraudon/Vitesse.git
````

### 2. Run the API

Ensure Swift is installed, then run:

```bash
cd CandidatesCAPI/
swift run App --auto-migrate
```

>  Replace `192.168.1.59` with your actual local IP address in the `Constants` file if needed.

---

## Features

### API Integration

To manage all API interactions, a robust and reusable pattern was implemented.

#### 1. Constants Setup

```swift
struct Constants {
    static var scheme = "http"
    static var host = "192.168.1.59"
    static var port = 8080
}
```

#### 2. EndPoint Protocol

This protocol defines the structure of an API endpoint:

```swift
protocol EndPoint {
    var path: String { get }
    var authorization: Authorization { get }
    var method: Method { get }
    var body: Data? { get }
    var request: URLRequest? { get }
}
```

Authorization and HTTP method types:

```swift
enum Authorization {
    case none
    case user
}

enum Method: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
```

#### 3. Candidates API Endpoints

Defined using an `enum` that conforms to `EndPoint`:

```swift
enum CandidatesEndPoints: EndPoint {
    case candidates
    case create(candidate: Candidate)
    case delete(id: String)
    case favorite(id: String)
    case update(candidate: Candidate)

    var path: String { ... }
    var method: Method { ... }
    var body: Data? { ... }
    var request: URLRequest? { ... }
}
```

#### 4. API Errors

Robust error handling ensures clear feedback to users:

```swift
enum Error: Swift.Error, LocalizedError, Hashable {
    case malformed, badRequest, unauthorized, notFound, responseError
    case internalServerError
    case custom(reason: String)

    var errorDescription: String? { ... }
}
```

#### 5. Request Execution

Generic function to call API and decode JSON responses:

```swift
func call<T: Decodable>(endPoint: EndPoint) async throws -> T {
    guard let request = endPoint.request else {
        throw Error.badRequest
    }

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw Error.responseError
    }

    guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
        let decoded = try JSONDecoder().decode(APIError.self, from: data)
        switch httpResponse.statusCode {
            case 401:
                throw Error.custom(reason: decoded.reason)
            case 404:
                throw Error.notFound
            case 500:
                throw Error.custom(reason: "This email is already taken.")
            default:
                throw Error.internalServerError
        }
    }

    if data.isEmpty {
        return EmptyResponse() as! T
    }

    return try JSONDecoder().decode(T.self, from: data)
}
```
