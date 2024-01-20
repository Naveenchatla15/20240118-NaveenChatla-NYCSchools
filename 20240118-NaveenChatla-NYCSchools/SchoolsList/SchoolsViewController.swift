//
//  ViewController.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 18/01/24.
//

import UIKit

protocol searchDataHandle {
    
    func injectDataWithSearch(isSearch: Bool, modelArray: [NYCSchoolResponseModel])
}

class SchoolsViewController: UIViewController {
    
    var schoolVM = NYCSchoolViewModel()
    
    @IBOutlet weak var schoolsListTableView : UITableView!
    @IBOutlet weak var searchTF : UITextField!
    
    var searchedArray : [NYCSchoolResponseModel] = []
    var isSerching = false
    var delegate : searchDataHandle? = nil
    
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
                searchedArray = schoolVM.nycHighSchoolsList
                DispatchQueue.main.async {
                    self.schoolsListTableView.reloadData()
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
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}




