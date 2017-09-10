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

import ResearchKit

struct AssessmentTaskFactory {
  static func makePulseAssessmentTask() -> ORKTask {
    
    let feelingAnswer = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 0, defaultValue: 5, step: 1, vertical: true, maximumValueDescription: "Most effective", minimumValueDescription: "Doesn't work at all")
    
    
    // Create a question.
    let title = "Ibuprofen"
    let text = "How do you rate the effectiveness of Ibuprofen today."
    let questionStep = ORKQuestionStep(identifier: "PulseStep", title: title, text: text, answer: feelingAnswer)
    questionStep.isOptional = false
    
    // Create an ordered task with a single question
    return ORKOrderedTask(identifier: "PulseTask", steps: [questionStep])
  }
  
  static func makeTemperatureAssessmentTask() -> ORKTask {
    
    // open up photo
    
    
    let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!
    let unit = HKUnit(from: "degF")
    let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .decimal)
    
    // Create a question.
    let title = "Take temperature orally."
    let text = "Temperatures in the range of 99-103°F are an early sign of possible infection. Temperatures over 103°F generally indicate early stages of transformation. Temperatures below 90°F indicate you have died and are currently a zombie."
    let questionStep = ORKQuestionStep(identifier: "TemperatureStep", title: title, text: text, answer: answerFormat)
    questionStep.isOptional = false
    
    // Create an ordered task with a single question
    return ORKOrderedTask(identifier: "TemperatureTask", steps: [questionStep])

  }
    
    

    
    static func makeCameraTask() -> ORKTask {
    
        let imageCaptureStep = ORKImageCaptureStep(identifier: "imageTask")
        imageCaptureStep.isOptional = false
        imageCaptureStep.accessibilityInstructions = "Please draw an analog clock as shown below with the time showing TEN PAST ELEVEN"
        
        imageCaptureStep.accessibilityHint = "test hint"

        
    //    imageCaptureStep.templateImage = #imageLiteral(resourceName: "columbus-avatar")
        

        imageCaptureStep.templateImageInsets = UIEdgeInsets(top: 0.05, left: 0.05, bottom: 0.05, right: 0.05)
        

        
        return ORKOrderedTask(identifier: "CameraTask", steps: [imageCaptureStep])
        
    }
    
    
    static func makeHotdogTask() -> ORKTask {
        let hotCaptureStep = ORKImageCaptureStep(identifier: "hotTask")
        hotCaptureStep.isOptional = false
        hotCaptureStep.accessibilityInstructions = "Please take a picture of a hotdog"
        hotCaptureStep.accessibilityHint = "test hint"

        hotCaptureStep.templateImageInsets = UIEdgeInsets(top: 0.05, left: 0.05, bottom: 0.05, right: 0.05)
        
        return ORKOrderedTask(identifier: "hotCameraTask", steps: [hotCaptureStep])
    }
    
    
    
    
    
    
    
    static func makeOutdoorTask() -> ORKTask{
        
        
        
        let walkStep = ORKTimedWalkStep(identifier: "walkStep")
        walkStep.isOptional = false
        walkStep.accessibilityHint = "test"
        
        
        
          return ORKOrderedTask(identifier: "OutdoorTask", steps: [walkStep])
    }

    
    
    
    
    
}
