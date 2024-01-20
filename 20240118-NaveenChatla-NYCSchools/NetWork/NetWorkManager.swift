//
//  NetWorkManager.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 18/01/24.
//

import Foundation
import Alamofire
import SVProgressHUD

class NetWorkManager : NSObject {
    
    static let shared = NetWorkManager()
    private override init(){}
    typealias ResultHandler<T> = (Result<T, Errors>) -> Void
    
    //MARK:- Generics Get Network Methods
    func get<T: Codable>(urlString: String, modelType: T.Type, completionHandler : @escaping ResultHandler<Any>)
    {
        SVProgressHUD.show()
        if !isConnectedToNetwork()
        {
            SVProgressHUD.dismiss()
            showToast(message: "Please check your Internet")
            print("No Internet")
        }
        AF.request(urlString, method: .get).response { response in
            print(response)
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let data):
                guard let data else
                {
                    completionHandler(.failure(.invalidData))
                    return
                }
                guard let response = response.response, 200...299 ~= response.statusCode else
                {
                    completionHandler(.failure(.invalidResponse))
                    return
                }
                self.responseDecode(data: data ,modelType: modelType) { response in
                        switch response {
                        case .success(let originalResponse):
                            completionHandler(.success(originalResponse))
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
            case .failure(let error):
                completionHandler(.failure(.network(error)))
                print(error.localizedDescription)
            }
        }
    }
    
 //MARK:- Response Decode
    func responseDecode<T: Decodable>(data: Data,modelType: T.Type,completionHandler: ResultHandler<T>
    ) {
        do {
            let response = try JSONDecoder().decode(modelType, from: data)
            completionHandler(.success(response))
        }catch {
            completionHandler(.failure(.decoding(error)))
        }
    }
    
}





