//
//  BaseService.swift
//  coinRank
//
//  Created by Jeeraponnnnnnnn on xx/x/2564 BE.
//

import Alamofire
import SwiftyJSON
import Foundation

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

class BaseService: NSObject {

    class var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }

    class var buildNumber: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return ""
    }

    class var deviceNamed: String {
        return UIDevice.current.name
    }

    class var uuid: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    class var platform: String {
        return UIDevice.current.model
    }
    
    class private var environmentHeader: HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
    }

    private var requestParameters: Parameters {
        return [
            // "appCode": Configurations.APP_CODE,
            "platform": UIDevice.current.model,
            "additionalAppCodes": [],
            "deviceId": "devi/\(BaseService.uuid)",
        ]
    }
    
    
    public func request(_ url: String, isRefreshToken: Bool = true, method: Alamofire.HTTPMethod = .post, parameters: Parameters, encoding: ParameterEncoding? = URLEncoding.default, headers: HTTPHeaders = [:], completionHandler: @escaping (JSON) -> Void, errorHandler: @escaping (Error) -> Void) {
        var requestParams = requestParameters
        requestParams.merge(dict: parameters)

        if let requestUrl = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            print(url)

            AlamofireSessionManager.sharedManager.request(requestUrl, method: method, parameters: parameters, encoding: encoding ?? URLEncoding.default, headers: headers == [:] ? BaseService.environmentHeader : headers).responseJSON { response in

                //                print(self.requestHeaders)
                switch response.result {
                case .success:
                    let statusCode = response.response?.statusCode

                    if let data = response.data {
                        do {
                            var json = try JSON(data: data)
                            json["statusCode"] = JSON(statusCode ?? 200)

                            guard statusCode == 200 else {
                                let errorTemp = self.getLocalizedErrorFromJSON(json, statusCode: statusCode, url: url)
                                if statusCode == 410, !url.contains("auth") {
                                    return
                                }
                                errorHandler(errorTemp)
                                return
                            }

                            completionHandler(json)
                        } catch {
                            errorHandler(error)
                        }
                    } else {
                        let emptyJSON = JSON([])
                        completionHandler(emptyJSON)
                    }

                    break
                case .failure:
                    guard response.response?.statusCode != 200 else {
                        let emptyJSON = JSON([])
                        completionHandler(emptyJSON)
                        return
                    }
                    
                    let localizedError: NSError = self.getLocalizedError(response: response, url: url)
                    errorHandler(localizedError)
                    break
                }
            }
        }
    }
    
    /// สร้างข้อความ error จาก json ตอนได้ response success จาก alamofier (service ส่งข้อความมา)
    func getLocalizedErrorFromJSON(_ json: JSON, statusCode: Int?, url: String) -> NSError {
        var errorMsg = json["error"]["exception"]["Message"].stringValue
        if errorMsg.count == 0 {
            errorMsg = json["error"]["message"].stringValue
        }

        let userInfo: [String : Any] = [
            NSLocalizedDescriptionKey: errorMsg,
            NSLocalizedFailureReasonErrorKey: "Get error from response JSON.",
            "message": errorMsg,
            "statusCode": statusCode ?? 0
        ]
        let errorTemp = NSError(domain: url, code: statusCode ?? 0, userInfo: userInfo)
        return errorTemp
    }

    /// สร้างข้อความ error แสดงให้ user อ่าน
    private func getLocalizedError(response: DataResponse<Any>, url: String) -> NSError {
        var statusCode = response.response?.statusCode
        var errorMessage = "Cannot process your request.\nPlease try again."

        if let manager = NetworkReachabilityManager(), !manager.isReachable {
            errorMessage = "Cannot connect to internet."
        } else if let statusCode = statusCode {
            if statusCode == 404 {
                errorMessage = "The service you requested is not avaliable at this time. Please try again later."
            } else {
                errorMessage = "Cannot process your request.\nPlease try again."
            }
        } else if let error = response.result.error {
            if error._code == NSURLErrorTimedOut {
                if statusCode == nil {
                    statusCode = NSURLErrorTimedOut
                }
                errorMessage = "Request timeout.\nPlease try again."
            } else {
                errorMessage = "Cannot process your request.\nPlease try again."
            }
        } else {
            errorMessage = "Cannot process your request.\nPlease try again."
        }

        let userInfo: [String : Any] = [
            NSLocalizedDescriptionKey: errorMessage,
            NSLocalizedFailureReasonErrorKey: response.result.error ?? "",
            "response": response
        ]
        let responseError = NSError(domain: url, code: statusCode ?? 0, userInfo: userInfo)

        return responseError
    }
    
}


struct AlamofireSessionManager {
    static let sharedManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constants.REQUEST_TIMEOUT
        return Alamofire.SessionManager(configuration: configuration)
    }()
}
