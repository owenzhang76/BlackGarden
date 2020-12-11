//
//  MCViewController.swift
//  finalProject
//
//  Created by Marissa Kalkar on 12/2/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.

import UIKit

class MCViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource {
    
    
    
    //collection view stuff

    @IBOutlet weak var collectionView: UICollectionView!
    //var emptyDict: [String: String] = [:]

   // var playerStats = UserDefaults.standard.dictionary(forKey: String, forValue: Int) ?? [String:Int]
    var itemsCollected = UserDefaults.standard.stringArray(forKey: "playerItems") ?? []
    var items = [Item]()
    let compass = Item(image: UIImage(named: "black_garden_compass_1")!, itemName: "compass" )
    let crown = Item(image: UIImage(named: "black_garden_crown_1")!, itemName: "crown")
    let shotgun = Item(image: UIImage(named: "black_garden_shotgun_1")!, itemName: "shotgun")
    let sword = Item(image: UIImage(named: "black_garden_sword_1")!, itemName: "sword")
   
    let stringArray: [String] = ["Crown Count: ", "Health: ",]
   
    //var items: [Item] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return itemsCollected.count
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myColCell", for: indexPath)
        
       // need to ask owen for larger pictures here because creates a pattern with it.. doesn't fit
        cell.backgroundColor = UIColor(patternImage: (items[indexPath.row]).image)
        let title = UILabel(frame: CGRect(x:0, y:0, width: cell.bounds.size.width, height: cell.bounds.size.height/4))
        title.textColor = UIColor.white
        title.text = (items[indexPath.row]).itemName
        print((items[indexPath.row]).itemName)
        title.textAlignment = .center
        //title.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        title.backgroundColor = UIColor.red
        return cell
        
    }
    
    //table view stuff
    
    @IBOutlet weak var tableView: UITableView!
    var myArray: [Int] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theTabCell")! as UITableViewCell
        
        
        myCell.textLabel!.text = stringArray[indexPath.row] +  String(myArray[indexPath.row])
        
        return myCell
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let stats = UserDefaults.standard
        let crowns = stats.integer(forKey: "crowns")
        let health  = stats.integer(forKey: "health")
        //let damage  = stats.integer(forKey: "damage")
        
        myArray = [crowns, health]
        
        
        
        
        for item in itemsCollected{
            if(item == "sword"){
                items.append(sword)
            }
            if(item == "compass"){
                items.append(compass)
            }
            if(item == "shotgun"){
                items.append(shotgun)
            }
          
        }
        
        // Do any additional setup after loading the view.
        //items = [compass, crown, shotgun, sword]
        collectionView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "theTabCell")
        tableView.dataSource = self
    }


}
