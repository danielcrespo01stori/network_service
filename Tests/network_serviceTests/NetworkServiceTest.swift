import XCTest
@testable import network_service

final class NetworkServiceTest: XCTestCase {
    private var sut: NetworkServiceType!
    private var session: URLSession!
    
    private struct Constants {
        static let baseUrl = "https://stori.com/v1"
        static let search = "/search"
        static let apiKey = "34543534534"
        static let authorizationToken =  "4554565464554"
        
    }
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: config)
        
        sut = NetworkService(url: Constants.baseUrl, urlSession: session)
        sut.setBaseUrl(Constants.baseUrl)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        URLProtocolMock.testURLs = [:]
        URLProtocolMock.error = nil
        URLProtocolMock.response = nil
    }
    
    func testNetworkService_WhenMakeARequestSuccessful_ThenTheResponseShouldBeSuccess() throws {
        //Given
        let expectationReceive = expectation(description: "receiveValue")
        let expectationFailure = expectation(description: "failure")
        expectationFailure.isInverted = true
        
        let endPoint = ApiNetworkRequest<[APIModelMock]>(
            method: .GET,
            relativePath: Constants.search,
            headers: ["test" : "testRun"],
            parameters: nil,
            authorizationToken: Constants.authorizationToken,
            apiKey: Constants.apiKey
        )
        
        let decoder = JSONEncoder()
        let usersURL = URL.getUrl(from: Constants.baseUrl + Constants.search)
        let encodedData = try decoder.encode(TestDataConstants.APIModelResponse)
        let jsonString = String(data: encodedData, encoding: .utf8)
        let jsonData = jsonString!.data(using: .utf8)!
        
        URLProtocolMock.testURLs = [usersURL: jsonData]
        URLProtocolMock.response = HTTPURLResponse(
            url: URL(string: "http://localhost:5000")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        
        //When
        sut.request(endPoint, completionHandler: { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                print(response)
                expectationReceive.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
                expectationFailure.fulfill()
            }
        })
        
        //Then
        self.wait(for: [expectationReceive, expectationFailure], timeout: 1)
    }
    
    func testNetworkService_WhenMakeARequestSuccessfulButRequestFail_ThenCatchAError() throws {
        //Given
        let expectationReceive = expectation(description: "Invalid.receiveValue")
        expectationReceive.isInverted = true
        let expectationFailure = expectation(description: "Invalid.failure")
        
        let endPoint = ApiNetworkRequest<[APIModelMock]>(
            method: .POST,
            relativePath: Constants.search,
            parameters: ["test" : "testRun"],
            authorizationToken: Constants.authorizationToken,
            apiKey: Constants.apiKey
        )
        
        URLProtocolMock.response = HTTPURLResponse(
            url: URL(string: "http://localhost:5000/")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil)
        
        //When
        sut.request(endPoint) { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                print(response)
                expectationReceive.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                expectationFailure.fulfill()
            }
        }
        //Then
        self.wait(for: [expectationReceive, expectationFailure], timeout: 1)
    }
    
    func testNetworkService_WhenInvalidURL_ThenCatchAError() throws {
        //Given
        let expectationReceive = expectation(description: "Invalid.receiveValue")
        expectationReceive.isInverted = true
        let expectationFailure = expectation(description: "Invalid.failure")
        
        sut = NetworkService(url: "", urlSession: session)
        
        let endPoint = ApiNetworkRequest<[APIModelMock]>(
            method: .GET,
            relativePath: Constants.search,
            parameters: ["test" : "testRun"],
            authorizationToken: Constants.authorizationToken,
            apiKey: Constants.apiKey
        )
        
        URLProtocolMock.response = HTTPURLResponse(
            url: URL(string: "http://localhost:5000/")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil)
        
        //When
        sut.request(endPoint) { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                print(response)
                expectationReceive.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                expectationFailure.fulfill()
            }
        }
        
        //Then
        self.wait(for: [expectationReceive, expectationFailure], timeout: 1)
    }
    
}
