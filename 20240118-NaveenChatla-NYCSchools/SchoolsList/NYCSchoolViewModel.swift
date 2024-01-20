//
//  NYCSchoolViewModel.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 18/01/24.
//

import Foundation

final class NYCSchoolViewModel {
    
    var nycHighSchoolsList : [NYCSchoolResponseModel] = []
    var checkEvent: ((_ event: EventManager) -> Void)?
    
    func fetchNYCSchools()
    {
        self.checkEvent?(.loading)
        NetWorkManager.shared.get(urlString: API.BASE_URL + API.SCHOOLS_LIST_URL, modelType: [NYCSchoolResponseModel].self, completionHandler:  { response in
            switch response
            {
            case .success(let products):
                self.nycHighSchoolsList = (products as! [NYCSchoolResponseModel]).sorted { (model1, model2) -> Bool in
                    if let name1 = model1.school_name, let name2 = model2.school_name {
                        return name1 < name2
                    } else if model1.school_name == nil {
                        return false
                    } else {
                        return true
                    }
                }
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

