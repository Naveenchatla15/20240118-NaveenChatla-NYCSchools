//
//  SchoolsViewController+Extension.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 20/01/24.
//

import Foundation
import UIKit

extension SchoolsViewController: UITextFieldDelegate {
    
    //MARK: - TextFiels Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        filterSchools(with: searchText)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchedArray = schoolVM.nycHighSchoolsList
        schoolsListTableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Helper method to filter schools based on search text
    func filterSchools(with searchText: String) {
        if searchText.isEmpty {
            searchedArray = schoolVM.nycHighSchoolsList
        } else {
            searchedArray = schoolVM.nycHighSchoolsList.filter({$0.school_name!.localizedCaseInsensitiveContains(searchText)})
        }
        
        schoolsListTableView.reloadData()
    }
}
