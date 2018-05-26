//
//  MainCollectionViewCollectionViewController.swift
//  swiftconcepts
//
//  Created by new on 22/05/18.
//  Copyright © 2018 yuvraj. All rights reserved.
//

import UIKit

class Platform {
    let platformName : String
    let platformImage : String
    
    init(platformName : String, platformImage: String) {
        self.platformName = platformName
        self.platformImage = platformImage
    }
}

class MainCollectionViewController: UICollectionViewController {
    
    let reuseIdentifier = "firebase"
    
    var arrayPlatforms = [Platform]()

    override func viewDidLoad() {
        super.viewDidLoad()
        contructArray();
    }
    
    func contructArray(){
        arrayPlatforms.append(Platform(platformName: "Google", platformImage: "google.png"))
        arrayPlatforms.append(Platform(platformName: "Facebook", platformImage: "facebook.png"))
        arrayPlatforms.append(Platform(platformName: "Twitter", platformImage: "twitter.png"))
        arrayPlatforms.append(Platform(platformName: "Phone", platformImage: "phone.png"))
        arrayPlatforms.append(Platform(platformName: "Email", platformImage: "email.png"))
        arrayPlatforms.append(Platform(platformName: "Github", platformImage: "github.png"))
    }
 

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayPlatforms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell

        cell.title.text = arrayPlatforms[indexPath.row].platformName
        cell.image.image = UIImage(named:arrayPlatforms[indexPath.row].platformImage)
    
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "firebase", sender: arrayPlatforms[indexPath.row])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == reuseIdentifier){
            let firebaseViewController = segue.destination as! FirebaseViewController
            let platform = sender as! Platform
            firebaseViewController.platform = platform
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
