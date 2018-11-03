//
//  FilterDataSource.swift
//  Instagram
//
//  Created by Zhou Ti on 22/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit

class FilterDataSource: NSObject, UICollectionViewDataSource {

    var filters: [[String: Any]] = []
    var image: UIImage?
    let filterEffects = ImageHelper.filterEffects
    var ciContext = CIContext(options: nil)
    var filteredImage: [UIImage] = []

    func fill(image: UIImage, selectedIndex: Int) {
        if (self.image != image){
            self.image = image
            renderFilteredImages()
        }
        updateFilterLabelColor(selected: selectedIndex)
        Util.triggerNotification(name: "updateFilterImage", withData: ["image": filteredImage[selectedIndex]])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
        let filter = self.filters[indexPath.item]
        cell.fill(with: filter)
        return cell
    }

    func filterImage() -> [UIImage] {
        var newImageArray: [UIImage] = []
        for effect in self.filterEffects{
            let image = applyFilter(applier: effect.applier, image: self.image!)
            newImageArray.append(image)
        }
        self.filteredImage = newImageArray
        return newImageArray
    }

    func renderFilteredImages(){
        let newImageArray = filterImage()
        self.filters.removeAll()
        for (index, image) in newImageArray.enumerated(){
            filters.append(["filterName": self.filterEffects[index].name, "image": image, "selected": false])
        }
    }

    func updateFilterLabelColor(selected: Int){
        for index in 0...filters.count-1 {
            if (index == selected){
                filters[index]["selected"] = true
            }else{
                filters[index]["selected"] = false
            }
        }
    }


    func applyFilter(
        applier: FilterApplierType?, image: UIImage) -> UIImage {
        if (applier == nil){
            return image
        }
        let ciImage: CIImage? = CIImage(image: image)
        let outputImage: CIImage? = applier!(ciImage!)
        let outputCGImage = self.ciContext.createCGImage(
            (outputImage)!,
            from: (outputImage?.extent)!)
        return UIImage(cgImage: outputCGImage!)
    }

    func applyFilter(
        applier: FilterApplierType?, ciImage: CIImage) -> UIImage {
        let outputImage: CIImage? = applier!(ciImage)

        let outputCGImage = self.ciContext.createCGImage(
            (outputImage)!,
            from: (outputImage?.extent)!)
        return UIImage(cgImage: outputCGImage!)
    }

}
