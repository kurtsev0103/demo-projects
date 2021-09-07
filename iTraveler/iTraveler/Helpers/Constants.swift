//
//  Constants.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 14/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

// MARK: - Helpers Structs
struct Colors {
    static let tropicBlue   = UIColor(red: 96/255, green: 175/255, blue: 207/255, alpha: 1)
    static let tropicRed    = UIColor(red: 178/255, green: 51/255, blue: 51/255, alpha: 1)
    static let tropicYellow = UIColor(red: 255/255, green: 242/255, blue: 177/255, alpha: 1)
    static let tropicOrange = UIColor(red: 253/255, green: 201/255, blue: 118/255, alpha: 1)
}

struct Fonts {
    static let avenir = "AvenirNextCondensed-DemiBold"
}

// MARK: - API

let apiKey    = "7102c46b9amshdcbc49f650a47c1p1f3d42jsnac61983b0e7f"
let apiOCRKey = "d30c014ee888957"

// MARK: - Alert Keys
let kAlertOk                    = "Ok"
let kAlertSuccess               = "Success"
let kAlertError                 = "Error"
let kYouAreRegistered           = "You are registered"
let kYouAreAuthorized           = "You are authorized"
let kFillInAllTheInputFields    = "Fill in all the input fields"
let kEmailFormatIsNotValid      = "Email format is not valid"
let kPasswordsNotMatched        = "Passwords not matched"
let kServerError                = "Server error"
let kUnknownError               = "Unknown error"
let kRecoveryPassword           = "Password recovery link sent to your email"
let kPhotoNotExist              = "Photo not exist"
let kPleaseWait                 = "Please wait. Account creation"
let kWrongPhoneNumber           = "Wrong phone number"
let kNoNetwork                  = "No network"
let kFailedNetwork              = "Failed to get a response"
let kCanceledNetwork            = "Server request canceled"
let kActionSheetCamera          = "Camera"
let kActionSheetPhoto           = "Gallery"
let kActionSheetCancel          = "Cancel"
let kActionSheetLogout          = "Log out"

let kDeniedLocationTitle        = "Your Location is not Availeble"
let kDeniedLocationMessage      = "To give permission Go to: Settings -> iTraveler -> Location"
let kCheckLocationTitle         = "Location Services are Disabled"
let kCheckLocationMessage       = "To enable it go: Settings -> Privacy -> Location Services and turn On"
let kRestrictedLocationMessage  = "Application is not authorized for location services"

// MARK: - APP Files Name Key
let kNameBackgroundImage        = "background"
let kNameAccountImage           = "account"
let kNamePhotoImage             = "photo"
let kNamePhotoDefaultImage      = "imageDefault"
let kCancelImage                = "cancel"
let kMapImage                   = "mapImage"
let kPinImage                   = "mapPin"

// MARK: - View Name Key
let kTimeZoneLabel              = "TimeZone:"
let kButtonSaveTitle            = "Save address"
let kButtonLoginTitle           = "Login"
let kButtonNextTitle            = "Next"
let kButtonCancelTitle          = "Cancel"
let kButtonBackTitle            = "Back"
let kButtonRestoreTitle         = "Restore password"
let kButtonRegistrationTitle    = "Registration"
let kButtonSendEmailTitle       = "Send Email"
let kButtonItemBack             = "< Countries"

let kMainVCTitle                = "Countries"
let kLoginTFPlaceholder         = "your_email@gmail.com"
let kPassTFPlaceholder          = "Password"
let kPassTwoTFPlaceholder       = "Confirm password"
let kFirstNameTFPlaceholder     = "Enter First Name"
let kLastNameTFPlaceholder      = "Enter Last Name"
let kBornDateTFPlaceholder      = "Enter Born Date"
let kAddressTFPlaceholder       = "Enter your address"
let kPhonePlaceholder           = "66 777 8888"
let kSearchPlaceholder          = "Search Contry"

let kSegmentedControlNameFirst  = "Man"
let kSegmentedControlNameSecond = "Woman"
let kSegmentedControlNameThird  = "Other"

