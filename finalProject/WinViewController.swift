//
//  WinViewController.swift
//  finalProject
//
//  Created by Marissa Kalkar on 12/11/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {

    //help from https://stackoverflow.com/questions/27153181/how-do-you-make-a-background-image-scale-to-screen-size-in-swift  
    override func viewDidLoad() {
        print("In win view controller")
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"black_garden_launch_image.png")!)

        self.view.addBackground()
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

extension UIView {
func addBackground() {
    // screen width and height:
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height

    let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    imageViewBackground.image = UIImage(named: "black_garden_launch_image.png")

    // you can change the content mode:
    imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

    self.addSubview(imageViewBackground)
    self.sendSubviewToBack(imageViewBackground)
}}
