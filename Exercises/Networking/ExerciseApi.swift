//
//  ExerciseApi.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

//https://github.com/Moya/Moya/blob/master/Examples/_shared/GitHubAPI.swift

import Foundation
import Moya


// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum ExerciseApi {
    case searchExercise(term: String)
    case getExerciseById(id: Int)
    case getExercise(page: Int, filter: Filter? )
    case getImage(exerciseId: Int)
    case getEquipment
    case getMuscle
    case getCategory
}

extension ExerciseApi: TargetType {
    public var baseURL: URL {
        return URL(string: "https://wger.de/api/v2/")!
    }
    public var path: String {
        switch self {
        case .searchExercise: return "exercise/search/"
        case .getExercise: return "exercise/"
        case .getImage: return "exerciseimage/"
        case .getEquipment: return "equipment/"
        case .getMuscle: return "muscle/"
        case .getCategory: return "exercisecategory/"
        case .getExerciseById(let id): return "exerciseinfo/" + String(id) + "/"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var task: Task {
        switch self {
        case .getExercise(let page, let filter):
            var params: [String: Any] =  ["status": "2", "page": page]
            if (filter != nil) { params[filter!.value.key] = filter!.value.value }
            print("getExercise for param: \(params)")
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getCategory, .getEquipment, .getMuscle:
            return .requestPlain
        case .getImage(let exerciseId):
            let params: [String: Any] =  ["exercise": exerciseId]
            print("getImage for param: \(params)")
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .searchExercise(let term):
            let params: [String: Any] =  ["term": term]
            print("searchExercise for param: \(params)")
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getExerciseById(id: let id):
            print("getExerciseById for id: \(id)")
            return .requestPlain
        }
    }
    public var validationType: ValidationType {
        switch self {
        default:
            return .none
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    public var headers: [String: String]? {
        return nil
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
