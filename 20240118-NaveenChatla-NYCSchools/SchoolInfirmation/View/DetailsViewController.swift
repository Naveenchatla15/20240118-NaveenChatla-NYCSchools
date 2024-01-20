//
//  DetailsViewController.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 18/01/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var informationAry : [InformationResponseModel] = []
    var dbnUniqueNo = ""
    var schoolName = ""
    private var informationVM = InformationViewModel()

//MARK: - OutLets
    
    @IBOutlet weak var schoolNameLbl : UILabel!
    @IBOutlet weak var mathsAvgLbl : UILabel!
    @IBOutlet weak var readingAvgLbl : UILabel!
    @IBOutlet weak var writeingAvgLbl : UILabel!
    @IBOutlet weak var satTestLbl : UILabel!
    @IBOutlet weak var shadow : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNYCSchoolsInformation()
    }
    
    func getNYCSchoolsInformation()
    {
        informationVM.fetchSchoolsInformation()
        informationobserver()
    }
    
//MARK: - Network call Observer -  Data Binding with Check Event
    func informationobserver(){
        informationVM.checkEvent = { [weak self]  event in
            guard let self else { return }
            switch event {
            case .loading:
                print("loading")
            case .loaded:
                filterSchoolData()
            case .error(let error):
                print(error as Any)
            }
        }
    }
 
//MARK: - Filter School information based on selection
    func filterSchoolData()
    {
        print(dbnUniqueNo)
        informationAry = informationVM.informationList
        if !informationVM.informationList.isEmpty
        {
            let filteredArray = informationVM.informationList.filter({$0.dbn == dbnUniqueNo})
            print(filteredArray)
            if !filteredArray.isEmpty
            {
                schoolNameLbl.text = filteredArray[0].school_name
                satTestLbl.text = filteredArray[0].num_of_sat_test_takers
                mathsAvgLbl.text = filteredArray[0].sat_math_avg_score
                readingAvgLbl.text = filteredArray[0].sat_critical_reading_avg_score
                writeingAvgLbl.text = filteredArray[0].sat_writing_avg_score
            }
            else
            {
                schoolNameLbl.text = schoolName
                showToast(message: "No Infirmation Found")
            }
        }
    }
    
    @IBAction func backBtnAction()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
}
