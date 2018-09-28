//
//  record.swift
//  Semaine2
//
//  Created by etudiant on 27/09/2018.
//

import Foundation
import SwiftyJSON

public class Record{
    var coordinates = [(lat:Double, long:Double)]()
    let nom_zca:String
    typealias coord = (Double,Double)
    let geo_point2D:coord
    
    init(json:JSON){
        let coords = json["fields"]["geo_shape"]["coordinates"][0].arrayValue
        for i in 0..<json["fields"]["geo_shape"]["coordinates"].count{
            self.coordinates.append((Double(coords[i][1].stringValue)!,Double(coords[i][0].stringValue)!))
        }
        self.nom_zca = json["fields"]["nom_zca"].stringValue
        let geo_point = json["fields"]["geo_point_2d"].arrayValue
        self.geo_point2D = (Double(geo_point[1].stringValue)!,Double(geo_point[0].stringValue)!)
    }
}

extension Record: Decodable {
    enum MyStructKeys: String, CodingKey { // declaring our keys
        case fields = "fields"
        case geo_shape = "geo_shape"
        case coordinates = "coordinates"
        case nom_zca = "nom_zca"
        case geo_point_2d = "geo_point_2d"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
        let fields: String = try container.decode(String.self, forKey: .fields) // extracting the data
        let id: Int = try container.decode(Int.self, forKey: .id) // extracting the data
        let twitter: URL = try container.decode(URL.self, forKey: .twitter) // extracting the data
        
        self.init(fullName: fullName, id: id, twitter: twitter) // initializing our struct
    }
}
