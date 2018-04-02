//
//  ImageWorker.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

class ImageWorker: NSObject {
    
    static func checkNewsImages(){
        let manager = FileManager()
        var dirURL = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        dirURL = dirURL?.appendingPathComponent(NEWS_IMAGES_DIR_NAME)
        //NSLog(@"%@", fileURL.path);
        if !manager.fileExists(atPath: dirURL!.path){
            try? manager.createDirectory(at: dirURL!, withIntermediateDirectories: false, attributes: nil)
        }
        else {
            let imgDirectoryEnumerator = manager.enumerator(atPath: dirURL!.path)
            var filePath : URL?
            let minImageCreationDate = Date().addingTimeInterval(-2*24*60*60)
            while let fileName = imgDirectoryEnumerator?.nextObject() as? String {
                filePath = dirURL?.appendingPathComponent("/" + fileName)
                let fileCreationDate : Date? = try? manager.attributesOfItem(atPath: filePath!.path)[FileAttributeKey.creationDate] as! Date
                if (fileCreationDate!.compare(minImageCreationDate) == .orderedAscending){
                    try? manager.removeItem(atPath: filePath!.path)
                }
            }
        }
    }
    
    static func getImageForUrl(webURL : URL) -> Data{
        let imageName = webURL.lastPathComponent
        let manager = FileManager()
        var imagePathURL = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        imagePathURL = imagePathURL!.appendingPathComponent(NEWS_IMAGES_DIR_NAME + "/" + imageName)
        //NSLog(@"%@", fileURL.path);
        var imageData : Data?
        if (!manager.fileExists(atPath: imagePathURL!.path)){
            imageData = try? Data.init(contentsOf: webURL)
            try? imageData!.write(to: imagePathURL!)
            return imageData!
        }
        imageData = try? Data.init(contentsOf: imagePathURL!)
        return imageData!
    }

}
