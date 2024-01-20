//
//  InformationModel.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 19/01/24.
//

import Foundation

final class InformationViewModel {
    
    var informationList : [InformationResponseModel] = []
    var checkEvent: ((_ event: EventManager) -> Void)?
    
    func fetchSchoolsInformation()
    {
        self.checkEvent?(.loading)
        NetWorkManager.shared.get(urlString: API.BASE_URL + API.INFORMATION_URL, modelType: [InformationResponseModel].self, completionHandler:  { response in
            switch response
            {
            case .success(let information):
                self.informationList = information as! [InformationResponseModel]
                self.checkEvent?(.loaded)
            case .failure(let error):
                self.checkEvent?(.error(error))
            }
        }
                                                    )
    }
    
    enum EventManager {
        case loading
        case loaded
        case error(Error?)
       
    }
}
