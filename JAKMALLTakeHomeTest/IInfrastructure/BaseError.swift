//
//  BaseError.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation
import SwiftyJSON

protocol ErrorProtocol{
    func getErrCode() -> String
    func getTitle() -> String
    func getDesc() -> String
}

enum BaseError: Error {
    case networkError
    case httpError(Int)
    case unexpectedError
    case apiFailure(JSON)
    case custom(code: String, title: String, desc: String)
    
    public var getError: (ErrorProtocol) {
        switch self {
        case .networkError:
            return GenericError(errCode: "1000",
                                         title: "Failed",
                                         desc: "Network Error")
        case .httpError(let code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure(let json):
            let code = json["messagecode"].stringValue
            let msg = json["message"].stringValue
            if msg.contains("|"){
                let splitMsg = msg.components(separatedBy: "|")
                return GenericError(errCode: code,
                                    title: splitMsg.first ?? "Failed",
                                    desc: splitMsg.last ?? msg)
            }else{
                return GenericError(errCode: code,
                                    title: "Failed",
                                    desc: msg)
            }
        case .custom(let code, let title, let desc):
            return GenericError(errCode: code, title: title, desc: desc)
        default:
            return GenericError(errCode: "0",
                                title: "Failed",
                                desc: "Unexpected Error")
        }
    }
    
    
    private func getHttpErrorMessage(httpCode: Int) -> (ErrorProtocol)
    {
        if (httpCode == 0) {
            return GenericError(
                errCode: "0",
                title: "Failed",
                desc: "Time Out"
            )
        }
        
        if (httpCode >= 300 && httpCode <= 309) {
            // Redirection
            return GenericError(errCode: String(httpCode),
                                title: "Failed",
                                desc: "It was transferred to a different URL. I'm sorry for causing you trouble!")
        }
        if httpCode == 400{
            return GenericError(errCode: String(httpCode),
                                title: "Failed",
                                desc: "occured_error")
        }
        if httpCode == 401{
            return GenericError(errCode: String(httpCode),
                                title: "session_done",
                                desc: "please_try_again")
        }
        if httpCode == 404 || httpCode == 403{
            return GenericError(errCode: String(httpCode),
                                title: "Failed",
                                desc: "URL Not Found!")
        }
        if (httpCode >= 405 && httpCode <= 451) {
            return GenericError(errCode: String(httpCode),
                                title: "Failed",
                                desc: "An error occurred on the application side. Please try again later!")
        }
        if (httpCode >= 500 && httpCode <= 511) {
            // Server error
            return GenericError(errCode: String(httpCode),
                                title: "Maintenance",
                                desc: "Saat ini kami sedang perbaikan untuk yang lebih baik, tunggu sebentar yah."
            )
        }
        // Unofficial error
        return GenericError(errCode: "0",
                            title: "Failed",
                            desc: "occured_error"
        )
    }
}

struct GenericError : ErrorProtocol, Error {
    var errCode = ""
    var title = ""
    var desc = ""
    
    init(errCode: String = "", title: String, desc: String) {
        self.errCode = errCode
        self.title = title
        self.desc = desc
    }
    
    func getErrCode() -> String {
        return errCode
    }
    
    func getTitle() -> String {
        return title == "" ? "Failed" : title
    }
    
    func getDesc() -> String {
        return desc
    }
}

