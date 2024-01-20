//
//  SchoolNameTableViewCell.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 18/01/24.
//

import UIKit

class SchoolNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var schoolNameLbl : UILabel!
    @IBOutlet weak var locationLbl : UILabel!
    @IBOutlet weak var phoneNoLbl : UILabel!
    @IBOutlet weak var emailLbl : UILabel!
    @IBOutlet weak var shadowView : UIView!
    
    var schools : NYCSchoolResponseModel? {
        didSet {
            // property Observer if any Modifications in NYCSchool
            schoolsConfiguration()
            selectionStyle = .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.dropShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Data Binding
    func schoolsConfiguration(){
        guard let schools else {return}
        schoolNameLbl.text = schools.school_name
        locationLbl.text = schools.city
        phoneNoLbl.text = schools.phone_number
        emailLbl.text = schools.school_email
    }
    
}
