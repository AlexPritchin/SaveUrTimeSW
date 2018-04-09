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
        var dirURL : URL
        do {
            dirURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dirURL = dirURL.appendingPathComponent(NEWS_IMAGES_DIR_NAME)
        }
        catch {
            return
        }
        if !manager.fileExists(atPath: dirURL.path){
            do {
                try manager.createDirectory(at: dirURL, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                return
            }
        }
        else {
            let imgDirectoryEnumerator = manager.enumerator(atPath: dirURL.path)
            var filePath : URL?
            let minImageCreationDate = Date().addingTimeInterval(-2*24*60*60)
            while let fileName = imgDirectoryEnumerator?.nextObject() as? String {
                filePath = dirURL.appendingPathComponent("/" + fileName)
                if let pathOfFile = filePath {
                let fileCreationDate : Date
                do {
                    fileCreationDate = try manager.attributesOfItem(atPath: pathOfFile.path)[FileAttributeKey.creationDate] as! Date
                }
                catch {
                    return
                }
                if (fileCreationDate.compare(minImageCreationDate) == .orderedAscending){
                    do {
                        try manager.removeItem(atPath: pathOfFile.path)
                    }
                    catch {
                        return
                    }
                }
                }
                else {
                    continue
                }
            }
        }
    }
    
    static func getImageForUrl(webURL : URL) -> Data{
        let imageName = webURL.lastPathComponent
        let manager = FileManager()
        var imagePathURL : URL
        do {
            imagePathURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            imagePathURL = imagePathURL.appendingPathComponent(NEWS_IMAGES_DIR_NAME + "/" + imageName)
        }
        catch {
            return Data()
        }
        var imageData : Data
        if (!manager.fileExists(atPath: imagePathURL.path)){
            do {
                imageData = try Data.init(contentsOf: webURL)
                try imageData.write(to: imagePathURL)
                return imageData
            }
            catch {
                return Data()
            }
        }
        do {
            imageData = try Data.init(contentsOf: imagePathURL)
        }
        catch {
            return Data()
        }
        return imageData
    }

}
