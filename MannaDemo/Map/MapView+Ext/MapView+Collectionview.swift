//
//  MapView+Collectionview.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/06.
//

import UIKit
import NMapsMap

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userListForCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MannaCollectionViewCell.identifier, for: indexPath) as! MannaCollectionViewCell
        let user = userListForCollectionView[indexPath.row]
        let userListCount =  userListForCollectionView.filter { $0.state == true }.count
        
        if indexPath.row == 0 {
            cell.ranking.image = #imageLiteral(resourceName: "🥇")
        } else if indexPath.row ==  userListCount - 1 && indexPath.row != 0 {
            cell.ranking.image = #imageLiteral(resourceName: "☠️")
        } else if userListCount > 2 {
            if indexPath.row == 1 {
                cell.ranking.image = #imageLiteral(resourceName: "🥈")
            } else if indexPath.row == 2 {
                cell.ranking.image = #imageLiteral(resourceName: "🥉")
            } else {
                cell.ranking.image = UIImage()
            }
        } else {
            cell.ranking.image = UIImage()
        }
        
        if user.state {
            if imageToNameFlag {
                if user.networkValidTime > 60 {
                    cell.profileImage.image = user.disconnectProfileImage
                } else {
                    cell.profileImage.image = user.nicknameImage
                    cell.backgroundColor = nil
                    cell.isUserInteractionEnabled = true
                }
            } else {
                if user.networkValidTime > 60 {
                    cell.profileImage.image = user.disconnectProfileImage
                } else {
                    cell.profileImage.image = user.profileImage
                    cell.backgroundColor = nil
                    cell.isUserInteractionEnabled = true
                }
            }
        } else {
            cell.profileImage.image = #imageLiteral(resourceName: "Image-6")
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if userListForCollectionView[indexPath.row].latitude != 0 && userListForCollectionView[indexPath.row].longitude != 0 {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userListForCollectionView[indexPath.row].latitude,
                          lng: userListForCollectionView[indexPath.row].longitude),zoomTo: 16)
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 1.2
            mapView.moveCamera(cameraUpdate)
            MannaAPI.getPath(lat: userListForCollectionView[indexPath.row].latitude, lng: userListForCollectionView[indexPath.row].longitude) { result in
                self.multipartPath.lineParts = [
                    NMGLineString(points: result.path!)
                ]
                self.multipartPath.colorParts = [
                    NMFPathColor(color: UIColor(named: "keyColor")!, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.lightGray)
                ]
                self.multipartPath.mapView = self.mapView
            }
        }
    }
}
