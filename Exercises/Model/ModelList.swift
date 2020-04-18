//
//  ExerciseList.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

protocol ModelListProtocol {
    associatedtype ItemList
    var count: Int {get set }
    var next: String? {get set }
    var previous: String? {get set }
    var list: [ItemList] {get set }
    
}

typealias Id = Int

extension ModelListProtocol {
 
    var nextPage: Int?{
        guard let next = try? self.next?.asURL().valueOf("page") else { return nil}
        return Int(next)
    }
    
    var previousPage: Int? {
        guard let next = try? self.previous?.asURL().valueOf("page") else { return nil}
        return Int(next)
    }
    
    mutating func merge(newObject : Self){
        self.count = newObject.count
        self.next = newObject.next
        self.previous = newObject.previous
        self.list += newObject.list
    }
    
    
    func numberOfItem()-> Int {
        return self.list.count
    }
    
    func itemAtIdex(index: Int)-> ItemList? {
        return self.list[safeIndex: index]
    }
    
    
}
extension ModelListProtocol where ItemList: Identifiable {
    func toDictionary()-> [Id: ItemList] {
      return list.reduce(into: [Id: ItemList]()) {
        $0[$1.id] = $1
      }
    }
}



struct ModelList<T: Codable>: Codable, ModelListProtocol {
    typealias ItemList = T
    var count: Int
    var next: String?
    var previous: String?
    var list: [T]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
       case list = "results"
    }
    
}


//
//extension ModelListProtocol where T: Mappable {
//    func toDictionArray()-> [Id: [T]] {
//        guard self.list.count > 0,
//            let item = self.list.first else {return [:]}
//        return [item.mapKey: list]
//    }
//
//}
