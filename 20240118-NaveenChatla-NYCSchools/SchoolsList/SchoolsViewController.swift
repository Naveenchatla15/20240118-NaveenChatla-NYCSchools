//
//  ViewController.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 18/01/24.
//

import UIKit
import CoreData
class SchoolsViewController: UIViewController {
    
    var managedContext : NSManagedObjectContext!
    var schoolVM = NYCSchoolViewModel()
    var searchedArray : [NYCSchoolResponseModel] = []
    var isSerching = false
    var pageCount = 3
    
//MARK: - Outlets
    @IBOutlet weak var schoolsListTableView : UITableView!
    @IBOutlet weak var searchTF : UITextField!
    @IBOutlet weak var preBtn : UIButton!
    @IBOutlet weak var nextBtn : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTF.delegate = self
        setUpTableView()
        getNYCSchools()
    }

    //MARK: - GetSchools API Call
    func getNYCSchools()
    {
        schoolVM.fetchNYCSchools()
        schoolsObserver()
        
    }
    
    //MARK: - Setup TableView
    func setUpTableView()
    {
        self.schoolsListTableView.register(UINib(nibName: "SchoolNameTableViewCell", bundle: nil), forCellReuseIdentifier: "SchoolNameTableViewCell")
        schoolsListTableView.delegate = self
        schoolsListTableView.dataSource = self
        schoolsListTableView.estimatedRowHeight = 150
    }
    
    //MARK: - Network call Observer - Data Binding with Check Event
    func schoolsObserver(){
        schoolVM.checkEvent = { [weak self]  event in
            guard let self else { return }
            switch event {
            case .loading:
                print("loading")
            case .loaded:
                print("loaded")
//                searchedArray = schoolVM.nycHighSchoolsList
//                var i = 0
                for recored in schoolVM.nycHighSchoolsList
                {
//                    i += i
                    searchedArray.append(recored)
                    
                    if searchedArray.count == 3
                    {
                        DispatchQueue.main.async {
                            self.schoolsListTableView.reloadData()
                        }
                        return
                    }
//                    if i == 3
//                    {
//                        i = 0
//                       break
//                    }
                }
                
            case .error(let error):
                print(error as Any)
            }
        }
    }
    
    @IBAction func refreshBtnAction()
    {
        self.searchTF.text = ""
        self.searchTF.resignFirstResponder()
        getNYCSchools()
    }
}

//MARK: - TableView Delegate Metods
extension SchoolsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolNameTableViewCell", for: indexPath) as! SchoolNameTableViewCell
        let school = searchedArray[indexPath.row]
        cell.schools = school
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // School name showing in 1 line so give static 150
        // if want school in multple line -> numberlines should be zero & row height is UITableView.automaticDimension
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.dbnUniqueNo = searchedArray[indexPath.row].dbn ?? ""
        detailsVC.schoolName = searchedArray[indexPath.row].school_name ?? ""
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    
    
}


extension SchoolsViewController
{
    @IBAction func preBtnAction()
    {
        
        
    }
    
    @IBAction func nextBtnAction()
    {
        print(searchedArray.count)

        for recored in schoolVM.nycHighSchoolsList
        {
            for dbn in searchedArray
            {
                if dbn.dbn != recored.dbn
                {

                    searchedArray.append(recored)
                    
                }
            }
        }
        print(searchedArray.count)
        DispatchQueue.main.async {
            self.schoolsListTableView.reloadData()
        }
        
        
    }
}



