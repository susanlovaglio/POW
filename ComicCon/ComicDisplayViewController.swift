//
//  ComicDisplayViewController.swift
//  ComicCon
//
//  Created by susan lovaglio on 12/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ComicDisplayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var comicCollectionView: UICollectionView!
    let store = DataStore.sharedInstance
    var imageView = UIImageView()
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addImage()
        self.addSearchBar()
        self.setUpCollectionView()
        
        store.getCharacters { (success) in
            if success{
                OperationQueue.main.addOperation( {
                    self.comicCollectionView.reloadData()
                })
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CharacterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! CharacterCell
        
        cell.setCharacter(character: store.characters[indexPath.item])

        return cell
    }
    
    func addImage(){
        
        let image =  UIImage(named: "powPic")
        imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(imageView)
        
        imageView.backgroundColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height * 0.25).isActive = true
        //        imageView.bottomAnchor.constraint(equalTo: self.searchBar.topAnchor).isActive = true
    }
    
    func addSearchBar(){
        
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: self.view.frame.size.height * 0.06).isActive = true
        searchBar.placeholder = "Search"
        
    }
    
    func setUpCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: self.view.bounds.width * 0.45, height: self.view.bounds.height * 0.25)
        
        self.comicCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        self.view.addSubview(self.comicCollectionView)
        self.comicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.comicCollectionView.delegate = self
        self.comicCollectionView.dataSource = self
        self.comicCollectionView.backgroundColor = UIColor.clear
        
        self.comicCollectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "comicCell")
        
        self.comicCollectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.comicCollectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 1.40).isActive = true
        self.comicCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        self.comicCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.comicCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            
            if searchBar.text!.isEmpty {
             
                store.getCharacters { (success) in
                    
                    if success{
                        OperationQueue.main.addOperation( {
                            
                            self.comicCollectionView.reloadData()
                        })
                    }
                }
            }else {
                
                let query = searchBar.text!
                
                store.getCharacters(with: query, with: { (success) in
                    
                    if success{
                        
                        OperationQueue.main.addOperation {
                            
                            self.comicCollectionView.reloadData()
                        }
                    }
                    
                })
            }
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //
    //        let characterCell = cell as! CharacterCell
    //        characterCell.characterNameLabel.text = nil
    //        characterCell.characterImageView.image = nil
    //    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        store.characters.removeAll()
        store.pageNumber = nil
        
        store.getCharacters(with: searchText) { (success) in
            
            OperationQueue.main.addOperation {
                self.comicCollectionView.reloadData()
            }
        }
    }
    
    //    override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}