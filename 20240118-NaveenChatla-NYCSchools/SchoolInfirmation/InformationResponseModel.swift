//
//  InformationResponseModel.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 19/01/24.
//

import Foundation

struct InformationResponseModel : Codable {

    let dbn : String?
    let school_name : String?
    let num_of_sat_test_takers : String?
    let sat_critical_reading_avg_score : String?
    let sat_math_avg_score : String?
    let sat_writing_avg_score : String?

    enum CodingKeys: String, CodingKey {

        case dbn = "dbn"
        case school_name = "school_name"
        case num_of_sat_test_takers = "num_of_sat_test_takers"
        case sat_critical_reading_avg_score = "sat_critical_reading_avg_score"
        case sat_math_avg_score = "sat_math_avg_score"
        case sat_writing_avg_score = "sat_writing_avg_score"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dbn = try values.decodeIfPresent(String.self, forKey: .dbn)
        school_name = try values.decodeIfPresent(String.self, forKey: .school_name)
        num_of_sat_test_takers = try values.decodeIfPresent(String.self, forKey: .num_of_sat_test_takers)
        sat_critical_reading_avg_score = try values.decodeIfPresent(String.self, forKey: .sat_critical_reading_avg_score)
        sat_math_avg_score = try values.decodeIfPresent(String.self, forKey: .sat_math_avg_score)
        sat_writing_avg_score = try values.decodeIfPresent(String.self, forKey: .sat_writing_avg_score)
    }

}
