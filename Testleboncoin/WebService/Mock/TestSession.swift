//
//  TestSession.swift
//  testleboncoin
//
//  Created by zhizi yuan on 16/07/2021.
//

import Foundation

public class TestSession: URLSession {
    fileprivate typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    typealias HttpHeadersField = [String: String]

    fileprivate static let bundleId = Bundle(for: TestSession.self).bundleIdentifier ?? "Unknown Bundle ID"

    struct MockError: Error {
        static let Domain: String = TestSession.bundleId
        enum Code: Int {
            case NoResponseRegistered = 2000
        }
    }

    fileprivate var responses: [URL: Response] = [:]
    fileprivate var tasks: [URL: TestSessionDataTask] = [:]

    // MARK: - methods
    public override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let error = NSError(domain: MockError.Domain,
                            code: MockError.Code.NoResponseRegistered.rawValue,
                            userInfo: [NSLocalizedDescriptionKey: "No mocked response found by '\(url)'."])

        let response: Response = responses[url] ?? (
            data: nil,
            urlResponse: nil,
            error: error)
        let task = TestSessionDataTask(response: response,
                                          completionHandler: completionHandler)
        tasks[url] = task
        return task
    }

    public class TestSessionDataTask: URLSessionDataTask {
        fileprivate var mockResponse: Response
        fileprivate (set) var called: [String: Response] = [:]
        fileprivate let handler: CompletionHandler?

        fileprivate init(response: Response, completionHandler: CompletionHandler?) {
            self.mockResponse = response
            self.handler = completionHandler
        }

        public override func resume() {
            register(callee: mockResponse, name: "\(#function)")
            handler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }

        fileprivate func register(callee value: Response, name: String) {
            return called[name] = value
        }

        fileprivate func callee(_ name: String) -> Response? {
            return called["\(name)()"]
        }
    }

    public override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask {
        return self.dataTask(with: request.url!, completionHandler: completionHandler)
    }

    // MARK: - Utils
    @discardableResult
    func registerTestResponse(_ url: URL,
                              data: Data,
                              statusCode: Int = 200,
                              httpVersion: String? = nil,
                              headerFields: HttpHeadersField? = nil,
                              error: MockError? = nil) -> Response? {
        let urlResponse = HTTPURLResponse(url: url,
                                          statusCode: statusCode,
                                          httpVersion: httpVersion,
                                          headerFields: headerFields)
        return responses.updateValue((data: data, urlResponse: urlResponse, error: error),
                                     forKey: url)
    }

    func resumedResponse(_ url: URL, methodName: String = "resume") -> Response? {
        return tasks[url]?.callee(methodName)
    }
}
