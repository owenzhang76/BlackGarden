//
//  MCViewController.swift
//  finalProject
//
//  Created by Marissa Kalkar on 12/2/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.
//

import UIKit

class MCViewController: UIViewController, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        updateCell(collectionView, cellForItemAt: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myColCell", for: indexPath)
            cell.backgroundColor = UIColor(patternImage: items[indexPath.row].image)
//            cell.cell_label.text = items[indexPath.row].itemName
            return cell
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let compass = Item(image: UIImage(named: "black_garden_compass_1")!, itemName: "compass" )
    let crown = Item(image: UIImage(named: "black_garden_crown_1")!, itemName: "crown")
    let shotgun = Item(image: UIImage(named: "black_garden_shotgun_1")!, itemName: "shotgun")
    let sword = Item(image: UIImage(named: "black_garden_sword_1")!, itemName: "sword")
    
    var items: [Item] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
       }
       
//       func updateCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> ItemCollectionViewCell {
//
//        let cell: ItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myColCell", for: indexPath) as! ItemCollectionViewCell
//           cell.backgroundColor = UIColor(patternImage: items[indexPath.row].image)
//
//
//
//        cell.cell_label.text = items[indexPath.row].itemName
//
//
//           return cell
//       }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        items = [compass, crown, shotgun, sword]
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
