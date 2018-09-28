//
//  Helper.swift
//  Semaine2
//
//  Created by etudiant on 24/09/2018.
//

import Foundation
import SwiftyJSON
final class Helper{
    
    private init(){}
    
    static let shared = Helper()
    
    var json = [JSON]()
    
    var selectedItem = 0
    
    var records = [Record]()    
    
}
