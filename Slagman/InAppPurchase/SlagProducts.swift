//
//  GregoriusViewController.swift
//  Jetpack McFlax
//
//  Created by Greg M. Thompson on 5/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import Foundation

public struct SlagProducts {
  private static let productIdentifiers: Set<ProductIdentifier> = ["slagphysicschallenges", "com.gregoriust.removeads"]
  
  public static let productDescriptions = ["slagphysicschallenges" : "Slag Physics! The next chapter in the travels of Slagman! These 10 challenges will test your slagging abilities to the limits! Introducing a new teleportation obstacle! It will slag your mind!",
                                           "com.gregoriust.removeads" : "Slag them annoying ads!"]
  
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
