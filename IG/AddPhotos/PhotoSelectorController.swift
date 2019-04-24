//
//  PhotoSelectorController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/26/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setupNavigationBarItems()
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(PhotosSelectorCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchPhotos()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true 
    }
    
    var header:PhotoSelectorHeader?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        header.photoImageView.image = selectedImage
        if let selectedImage = selectedImage {
            if let index = self.images.index(of: selectedImage){ // vị trí của selectedImage trong images
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: { (image, info) in
                    header.photoImageView.image = image
                    self.header = header
                })
            }
        }
        return header
    }
    
    var selectedImage: UIImage?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView.reloadData()
        let indexPath:IndexPath = [0, 0]
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotosSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3)/4
        return CGSize(width: width, height: width)
    }
    
    func setupNavigationBarItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleNext(){
        let sharephotoController = SharePhotoController()
        sharephotoController.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharephotoController, animated: true)
    }
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    func assetsFetchOptions()-> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        // fetchOptions.fetchLimit = 10
        let sortDescriptors = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptors]
        return fetchOptions
    }
    
    func fetchPhotos(){
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.fetchLimit = 10
//        let sortDescriptors = NSSortDescriptor(key: "creationDate", ascending: false)
//        fetchOptions.sortDescriptors = [sortDescriptors]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                //  print(asset) : thông tin ảnh
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotos.count-1{
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
}
