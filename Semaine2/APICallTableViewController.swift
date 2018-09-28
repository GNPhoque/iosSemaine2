//
//  APICallTableViewController.swift
//  Semaine2
//
//  Created by etudiant on 24/09/2018.
//

import UIKit
import Alamofire
import SwiftyJSON
import Reachability

class APICallTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    var apiResponses = [String]()
    let reachability = Reachability()!

    override func viewDidLoad() {
        let reachable = checkReachability()
        /*if reachable == true{
            request()
        }
        else{
            loadStoredData()
        }*/
        request()
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func loadStoredData(){
        let records = UserDefaults.standard.array(forKey: "records")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.apiResponses.count
    }
    
    func checkReachability()->Bool{
        var reachable = false
        reachability.whenReachable = { _ in
            reachable = true
        }
        return reachable
    }
    
    func request() {
        Alamofire.request("https://opendata.paris.fr/api/records/1.0/search/?dataset=zones-30&facet=arrdt").responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var records = [Record]()
                for i in 0..<json["records"].count{
                    records.append(Record(json: json["records"][i]))
                    self.apiResponses.append(json["records"][i]["fields"]["nom_zca"].stringValue)
                }
                Helper.shared.records = records
                // ENCODE TO USER DEFAULTS
                if let encoded = try? JSONEncoder().encode(records) {
                    UserDefaults.standard.set(encoded, forKey: "records")
                }
                
                if let records = UserDefaults.standard.data(forKey: "records"),
                    let user = try? JSONDecoder().decode(Record.self, from: records) {
                    
                }
                //
                UserDefaults.standard.set(records, forKey: "records")
                print(self.apiResponses)
                self.tableview.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        print(self.apiResponses[indexPath.row])
        cell.textLabel?.text = self.apiResponses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Helper.shared.selectedItem = indexPath.row
        print(indexPath.row)
        performSegue(withIdentifier: "cellClickedSegue", sender: self)
    }
}
