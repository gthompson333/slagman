//
//  GregoriusViewController.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 5/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import Foundation

public struct SlagProducts {
  static let removeAdsProductID = "com.gregoriust.removeads"
  static let chroniclesSlagmanProductID = "com.gregoriust.chroniclesslagman"
  static let slagPhysicsProductID = "com.gregoriust.slagphysics"
  
  private static let productIdentifiers: Set<ProductIdentifier> = [removeAdsProductID, chroniclesSlagmanProductID, slagPhysicsProductID]
  
  public static let productDescriptions = [removeAdsProductID : "Slag them annoying ads!",
                                           chroniclesSlagmanProductID : "The Chronicles of Slagman!  10 brand new challenges that will test your slagging abilities to the limits!  Introducing a new theme, a new rotating gate obstacle, and other new obstacles.",
                                           slagPhysicsProductID : "Slag Physics!  10 brand new challenges that will time warp your mind!  Is Slagman here, or is he there? Purchase this collection of challenges, and find out! "]
  
  public static let inAppHelper = IAPHelper(productIds: SlagProducts.productIdentifiers)
  
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    return formatter
  }()
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
