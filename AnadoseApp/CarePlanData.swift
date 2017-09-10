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

enum ActivityIdentifier: String {
  case cardio
  case limberUp = "Limber Up"
  case targetPractice = "Target Practice"
  case pulse
  case temperature
  case camera
  case hotdog
}

class CarePlanData: NSObject {
  let carePlanStore: OCKCarePlanStore
  let contacts =
    [OCKContact(contactType: .personal,
                name: "Bob Riley",
                relation: "Friend",
                tintColor: nil,
                phoneNumber: CNPhoneNumber(stringValue: "888-555-5512"),
                messageNumber: CNPhoneNumber(stringValue: "888-555-5512"),
                emailAddress: "boby@example.com",
                monogram: "SR",
                image: UIImage(named: "friend-avatar")),
     OCKContact(contactType: .careTeam,
                name: "Walter White",
                relation: "Pharmacist",
                tintColor: nil,
                phoneNumber: CNPhoneNumber(stringValue: "888-555-5235"),
                messageNumber: CNPhoneNumber(stringValue: "888-555-5235"),
                emailAddress: "mrwhite@breakingbad.com",
                monogram: "WW",
                image: UIImage(named: "walter-avatar")),
     OCKContact(contactType: .careTeam,
                name: "Dr Emilia Clarke",
                relation: "Cardiologist",
                tintColor: nil,
                phoneNumber: CNPhoneNumber(stringValue: "888-555-2351"),
                messageNumber: CNPhoneNumber(stringValue: "888-555-2351"),
                emailAddress: "denyrstargarian@got.com",
                monogram: "HG",
                image: UIImage(named: "clarke-avatar")),

    
    ]

  class func dailyScheduleRepeating(occurencesPerDay: UInt) -> OCKCareSchedule {
    return OCKCareSchedule.dailySchedule(withStartDate: DateComponents.firstDateOfCurrentWeek,
                                         occurrencesPerDay: occurencesPerDay)
  }

  init(carePlanStore: OCKCarePlanStore) {
    self.carePlanStore = carePlanStore
    
    let cardioActivity = OCKCarePlanActivity(
      identifier: ActivityIdentifier.cardio.rawValue,
      groupIdentifier: nil,
      type: .intervention,
      title: "Ibuprofen",
      text: "2-mg",
      tintColor: UIColor.darkOrange(),
      instructions: "Take 1 pill of Ibuprofen with food every morning and afternoon",
      imageURL: nil,
      schedule:CarePlanData.dailyScheduleRepeating(occurencesPerDay: 2),
      resultResettable: true,
      userInfo: nil)
    
    let limberUpActivity = OCKCarePlanActivity(
      identifier: ActivityIdentifier.limberUp.rawValue,
      groupIdentifier: nil,
      type: .intervention,
      title: "Limber Up",
      text: "Stretch Regularly",
      tintColor: UIColor.darkOrange(),
      instructions: "Stretch and warm up muscles in your arms, legs and back before any expected burst of activity. This is especially important if, for example, you're heading down a hill to inspect a Hostess truck.",
      imageURL: nil,
      schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 6),
      resultResettable: true,
      userInfo: nil)
    
    
    let pulseActivity = OCKCarePlanActivity
      .assessment(withIdentifier: ActivityIdentifier.pulse.rawValue,
                  groupIdentifier: nil,
                  title: "Rating Ibuprofen",
                  text: "Rate the effectiveness of your perscription",
                  tintColor: UIColor.darkGreen(),
                  resultResettable: true,
                  schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1),
                  userInfo: ["ORKTask": AssessmentTaskFactory.makePulseAssessmentTask()])
    
    let temperatureActivity = OCKCarePlanActivity
      .assessment(withIdentifier: ActivityIdentifier.temperature.rawValue,
                  groupIdentifier: nil,
                  title: "Temperature Task",
                  text: "Please take your temperature",
                  tintColor: UIColor.darkYellow(),
                  resultResettable: true,
                  schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1),
                  userInfo: ["ORKTask": AssessmentTaskFactory.makeTemperatureAssessmentTask()])

    
    let cameraActivity = OCKCarePlanActivity
        .assessment(withIdentifier: ActivityIdentifier.camera.rawValue,
                    groupIdentifier: nil,
                    title: "Cognative Task",
                    text: "Please draw a clock ten minutes past eleven.",
                    tintColor: UIColor.darkYellow(),
                    resultResettable: true,
                    schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1),
                    userInfo: ["ORKTask": AssessmentTaskFactory.makeCameraTask()])

    
    
    let hotdogActivity = OCKCarePlanActivity
        .assessment(withIdentifier: ActivityIdentifier.hotdog.rawValue,
                    groupIdentifier: nil,
                    title: "Hotdog",
                    text: "Take a picture of food",
                    tintColor: UIColor.darkYellow(),
                    resultResettable: true,
                    schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1),
                    userInfo: ["ORKTask": AssessmentTaskFactory.makeHotdogTask()])
    
    
    
    

    super.init()
    
    for activity in [cardioActivity, limberUpActivity,
                     pulseActivity, temperatureActivity, cameraActivity, hotdogActivity] {
                      add(activity: activity)
    }
  }
  
  func add(activity: OCKCarePlanActivity) {
    carePlanStore.activity(forIdentifier: activity.identifier) {
      [weak self] (success, fetchedActivity, error) in
      guard success else { return }
      guard let strongSelf = self else { return }

      if let _ = fetchedActivity { return }
      
      strongSelf.carePlanStore.add(activity, completion: { _ in })
    }
  }
}

extension CarePlanData {
  func generateDocumentWith(chart: OCKChart?) -> OCKDocument {
    let intro = OCKDocumentElementParagraph(content: "Hi my health team, here is my weekly progress taking my medication prescription")
    
    var documentElements: [OCKDocumentElement] = [intro]
    if let chart = chart {
      documentElements.append(OCKDocumentElementChart(chart: chart))
    }
    
    let document = OCKDocument(title: "Re: My Report", elements: documentElements)
    document.pageHeader = "Connor McGregor: Weekly Report"
    
    return document
  }
}
