//
//  NYCSchoolViewModel.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 18/01/24.
//

import Foundation
import CoreData
import Combine


final class NYCSchoolViewModel : ObservableObject{
    
    @Published var nycHighSchoolsList : [NYCSchoolResponseModel] = []
    
    var checkEvent: ((_ event: EventManager) -> Void)?
    var managedContext : NSManagedObjectContext!
    typealias ResultHandler<T> = (Result<T, Errors>) -> Void
    
    func fetchNYCSchools()
    {
        if isConnectedToNetwork()
        {
            self.checkEvent?(.loading)
            NetWorkManager.shared.get(urlString: API.BASE_URL + API.SCHOOLS_LIST_URL, modelType: [NYCSchoolResponseModel].self, completionHandler:  { [weak self] response in
                switch response
                {
                case .success(let products):
                    self?.nycHighSchoolsList = (products as! [NYCSchoolResponseModel]).sorted { (model1, model2) -> Bool in
                        if let name1 = model1.school_name, let name2 = model2.school_name {
                            return name1 < name2
                        } else if model1.school_name == nil {
                            return false
                        } else {
                            return true
                        }
                    }
                    self?.storeSchoolsToLocalDB()
                    self?.checkEvent?(.loaded)
                case .failure(let error):
                    self?.checkEvent?(.error(error))
                }
            }
            )
        }
        else
        {
            fetchSchoolsFromLocalDB()
        }
    }
    
    func fetchSchoolsFromLocalDB()  {
        nycHighSchoolsList.removeAll()
        managedContext = CoreDataBase.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<School> = School.fetchRequest()
        do {
            let existingSchools = try managedContext.fetch(fetchRequest)
            if !existingSchools.isEmpty
            {
                for exist in existingSchools {
                    let newSchool = NYCSchoolResponseModel(dbn: exist.schoolID, school_name: exist.schoolName, school_email: exist.schoolEmail, phone_number: exist.schoolPhone, city: exist.schoolCity)
                    nycHighSchoolsList.append(newSchool)
                }
            }
            
            //            self.objectWillChange.send()
            DispatchQueue.main.async {
                print("This Data is from Local Database")
                self.checkEvent?(.loaded)
            }
        }
        catch
        {
            print("Error fetching schools: \(error)")
        }
    }
    
    func storeSchoolsToLocalDB()
    {
        managedContext = CoreDataBase.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<School> = School.fetchRequest()
        
        do {
            let existingSchools = try managedContext.fetch(fetchRequest)
            // existingSchools now contains the data from Core Data
            if !nycHighSchoolsList.isEmpty
            {
                for apiSchool in nycHighSchoolsList {
                    // Check if the school with the same ID already exists
                    if let existingSchool = existingSchools.first(where: { $0.schoolID == apiSchool.dbn }) {
                        // Update the existing school
                        existingSchool.schoolName = apiSchool.school_name
                        existingSchool.schoolEmail = apiSchool.school_email
                        existingSchool.schoolPhone = apiSchool.phone_number
                        existingSchool.schoolCity = apiSchool.city
                        // Update any other attributes you need
                    } else {
                        // Create a new school entity and insert it
                        let newSchool = School(context: managedContext)
                        newSchool.schoolID = apiSchool.dbn
                        newSchool.schoolName = apiSchool.school_name
                        newSchool.schoolEmail = apiSchool.school_email
                        newSchool.schoolPhone = apiSchool.phone_number
                        newSchool.schoolCity = apiSchool.city
                        // Set any other attributes as needed
                    }
                }
                
                // Save the context after updating or inserting entities
                do {
                    try managedContext.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        } catch {
            print("Error fetching schools: \(error)")
        }
    }
    
    
    enum EventManager {
        case loading
        case loaded
        case error(Error?)
        
    }
}

