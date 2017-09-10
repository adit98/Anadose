/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CareKit
import ResearchKit
import CoreImage



protocol CarePlanStoreManagerDelegate: class {
  func carePlanStore(_: OCKCarePlanStore, didUpdateInsights insights: [OCKInsightItem])
}

class CarePlanStoreManager: NSObject {
  static let sharedCarePlanStoreManager = CarePlanStoreManager()
  var store: OCKCarePlanStore
  weak var delegate: CarePlanStoreManagerDelegate?

  override init() {
    let fileManager = FileManager.default
    guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
      fatalError("Failed to obtain Documents directory!")
    }
    
    let storeURL = documentDirectory.appendingPathComponent("CarePlanStore")
    
    if !fileManager.fileExists(atPath: storeURL.path) {
      try! fileManager.createDirectory(at: storeURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    store = OCKCarePlanStore(persistenceDirectoryURL: storeURL)
    super.init()
    store.delegate = self
  }
  
  func buildCarePlanResultFrom(taskResult: ORKTaskResult) -> OCKCarePlanEventResult {
    

  //  print(taskResult)

    
    
    print("")
    print("")
    print("")
    print("")
    print(taskResult.identifier)
    
    if taskResult.identifier != "walkingTask"{
    guard let firstResult = taskResult.firstResult as? ORKStepResult,
      let stepResult = firstResult.results?.first else {
        fatalError("Unexepected task results")
    }
    
    
    
    if let scaleResult = stepResult as? ORKScaleQuestionResult,
        let answer = scaleResult.scaleAnswer {
        return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: "", userInfo: nil)
    }

    
    if let numericResult = stepResult as? ORKNumericQuestionResult,
      let answer = numericResult.numericAnswer {
      return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: numericResult.unit, userInfo: nil)
    }
    
    if let fileResult = stepResult as? ORKFileResult,
        let answer = fileResult.fileURL {
        
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        
        
        print(documentsUrl)
    
        
        
        // Resize Tool
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            
            let widthRatio  = targetSize.width  / image.size.width
            let heightRatio = targetSize.height / image.size.height
            
            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }
            
            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            // Actually do the resizing to the rect using the ImageContext stuff
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
        }
        
        
        
        

        
        
        
        
        // Saving Image
        
        
       func save(image: UIImage) -> String? {
            let fileName = "preNeural"
            let fileURL = documentsUrl.appendingPathComponent(fileName)
            if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                try? imageData.write(to: fileURL, options: .atomic)
                return fileName // ----> Save fileName
            }
            print("Error saving image")
            return nil
        }

        
        // Loading Image
        
         func load(fileName: String) -> UIImage? {
            let fileURL = documentsUrl.appendingPathComponent(fileName)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
            return nil
        }
        
        
        var preCrop = UIImage()
        
          if stepResult.identifier == "imageTask" {
         preCrop = load(fileName: "imageTask.jpg")!
            //  print(preCrop)}
        }
        
        
        
        print(stepResult.identifier)
            if stepResult.identifier == "hotTask" {
            preCrop = load(fileName: "hotTask.jpg")!
                print("hit this")
                
            }
        
        
        
        func crop(image: UIImage, withWidth width: Double, andHeight height: Double) -> UIImage? {
            
            if let cgImage = image.cgImage {
                
                let contextImage: UIImage = UIImage(cgImage: cgImage)
                
                let contextSize: CGSize = contextImage.size
                
                var posX: CGFloat = 0.0
                var posY: CGFloat = 0.0
                var cgwidth: CGFloat = CGFloat(width)
                var cgheight: CGFloat = CGFloat(height)
                
                // See what size is longer and create the center off of that
                if contextSize.width > contextSize.height {
                    posX = ((contextSize.width - contextSize.height) / 2)
                    posY = 0
                    cgwidth = contextSize.height
                    cgheight = contextSize.height
                } else {
                    posX = 0
                    posY = ((contextSize.height - contextSize.width) / 2)
                    cgwidth = contextSize.width
                    cgheight = contextSize.width
                }
                
                let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
                
                // Create bitmap image from context using the rect
                var croppedContextImage: CGImage? = nil
                if let contextImage = contextImage.cgImage {
                    if let croppedImage = contextImage.cropping(to: rect) {
                        croppedContextImage = croppedImage
                    }
                }
                
                // Create a new image based on the imageRef and rotate back to the original orientation
                if let croppedImage:CGImage = croppedContextImage {
                    let image: UIImage = UIImage(cgImage: croppedImage, scale: image.scale, orientation: image.imageOrientation)
                    return image
                }
                
            }
            
            return nil
        }
        
        let postCrop = crop(image: preCrop, withWidth: 2000, andHeight: 2000)!

    //     save(image: postCrop!)
        
    
        let postResize = resizeImage(image: postCrop, targetSize:  CGSize.init(width: 224, height: 224))
    
   //     save(image: postResize)

        
        let model = MobileNet()
        
        
        func sceneLabel (forImage image:UIImage) -> String? {
            if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image.cgImage!) {
                guard var scene = try? model.prediction(image: pixelBuffer) else {fatalError("Unexpected runtime error")}
     
                print("scene label:", scene.classLabel)
                
               var outputString = "Blank"
                
                print("task:", stepResult.identifier)
                
                if stepResult.identifier == "imageTask" {
                if scene.classLabel.contains("clock"){
                    
                 outputString = "Clock"
                }
                
                else {
                    
                     outputString = "Not a clock"
                }
                }
                
                
                
                
                if stepResult.identifier == "hotTask" {
                    if scene.classLabel.contains("hotdog"){
                        
                        outputString = "Hotdog"
                    }
                        
                    else {
                        
                        outputString = "Not a Hotdog"
                    }
                }
            
                
                /*
                if stepResult.identifier != "imageTask" || stepResult.identifier != "hotTask" {
                    outputString = scene.classLabel
                }
                */

               // if (scene.class
                return outputString
               // return outputLabel
            }
            
            return "Error in Prediction"
        }
        // end of funvtion definition
        
        
        
        
     //   save(image:postResize)
        
        let scoreLabel = sceneLabel(forImage: postResize);
        
        
        print("scoreLabel:", scoreLabel)
        return OCKCarePlanEventResult(valueString: scoreLabel!, unitString: "", userInfo: nil)
        
    }
    
    }
    
    
    
    
    
    
    /*
    
    if let walkResult = stepResult as? ORKTimedWalkResult{
        return OCKCarePlanEventResult(valueString: "", unitString: "", userInfo: nil)
        }

    */
    
    
    
    
    fatalError("Unexpected task result type")
  }
  
  func updateInsights() {
    InsightsDataManager().updateInsights { (success, insightItems) in
      guard let insightItems = insightItems, success else { return }
      self.delegate?.carePlanStore(self.store, didUpdateInsights: insightItems)
    }
  }
}

// MARK: - OCKCarePlanStoreDelegate
extension CarePlanStoreManager: OCKCarePlanStoreDelegate {
  func carePlanStore(_ store: OCKCarePlanStore, didReceiveUpdateOf event: OCKCarePlanEvent) {
    updateInsights()
  }
}
