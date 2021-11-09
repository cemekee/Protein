//
//  Service.swift
//  ProteinCase
//
//  Created by Cem Eke on 7.11.2021.
//

import UIKit

typealias SuccessCallback<T:Codable> = (_ response : T) -> Void

class Service:NSObject {
    
    private var session : URLSession?
    public static let instance = Service.init()
    override init() {
        super.init()
        session = URLSession.init(configuration: .default, delegate: nil, delegateQueue: nil)
    }
    
    func request<T : Codable>(_ serviceName: String ,params : [String:Any]?, _ onSuccess: @escaping SuccessCallback<T>){
        var urlRequest = URLRequest( url: URL.init(string: serviceName)!)
        
        var jsonBody: Data?
        if let _param = params, _param.count > 0 {
            
            jsonBody = _param.jsonStringRepresentation?.data(using: String.Encoding.utf8) ?? Data.init()
            
            if #available(iOS 13.0, *) {} else
            {
                if let jBody = jsonBody{
                    if var str = String(data: jBody, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
                    {
                        jsonBody = str.data(using: .utf8)!
                        if str == "{}"{
                            str = ""
                            jsonBody = str.data(using: .utf8)!
                        }
                    }
                }
            }
            
            urlRequest.httpBody =  jsonBody
            
        }
        
        session?.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
            do{
                guard let httpResponse = urlResponse as? HTTPURLResponse, let receivedData = data
                else {
                    
                    return
                }
                if let obj = try T.decode(from: receivedData) {
                    DispatchQueue.main.async {
                        onSuccess(obj)
                    }
                }
            }catch{}
        }).resume()
    }
}

extension Decodable {
    
    static func decode(from data: Data) throws -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatters.instance.dateFormatter)
            return try decoder.decode(Self.self, from: data)
        } catch let error as DecodingError {
            
            return nil
        }
    }
    
    static func decode(from data: Data, keyPath: String) throws -> Self? {
        let toplevel = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(from: nestedJsonData)
        } else {
            return nil
        }
        
    }
}
extension Dictionary{
    var jsonStringRepresentation: String? {
        guard var theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.fragmentsAllowed,.prettyPrinted,]) else {
            return nil
        }
        
        if var str = String(data: theJSONData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
        {
            if str == "{}"{
                str = ""
            }
            theJSONData = str.data(using: .utf8) ?? Data.init()
        }
        
        return String(data: theJSONData, encoding: .utf8)
    }
    
}

class DateFormatters {
    
    static let instance = DateFormatters()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    lazy var dateFormatterService: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    lazy var dateFormatterFull: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        return formatter
    }()
    
    lazy var dateFormatterCustom : ((_ format : String) ->DateFormatter)  = { format in
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "tr_TR")
        formatter.dateFormat = format
        return formatter
    }
    
}

