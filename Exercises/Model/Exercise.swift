//
//  Exercise.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

typealias CategoryId = Int
typealias EquipmentIdList = [Int]
typealias MusclesIdList = [Int]

protocol Searchable  {
    var name: String { get }
}

struct Exercise: Codable, Searchable {
    let id: Int
    let name: String
    let categoryId: CategoryId
    let equipmentIdList: EquipmentIdList
    let musclesIdList: MusclesIdList
    let musclesSecondaryIdList: MusclesIdList
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case categoryId = "category"
        case equipmentIdList = "equipment"
        case musclesIdList = "muscles"
        case musclesSecondaryIdList = "muscles_secondary"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        categoryId = try values.decode(CategoryId.self, forKey: .categoryId)
        equipmentIdList = try values.decode(EquipmentIdList.self, forKey: .equipmentIdList)
        musclesIdList = try values.decode(MusclesIdList.self, forKey: .musclesIdList)
        musclesSecondaryIdList = try values.decode(MusclesIdList.self, forKey: .musclesSecondaryIdList)
    }
}
