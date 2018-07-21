//
//  GregoriusViewController.swift
//  Slagman
//
//  Created by Greg M. Thompson on 5/28/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import Foundation

public struct SlagProducts {
  static let removeAdsProductID = "com.gregoriust.removeads"
  static let chroniclesSlagmanProductID = "com.gregoriust.chroniclesslagman"
  static let slagPhysicsProductID = "com.gregoriust.slagphysics"
  static let slagRecipesProductID = "com.gregoriust.slagrecipes"
  
  private static let productIdentifiers: Set<ProductIdentifier> = [removeAdsProductID, chroniclesSlagmanProductID, slagPhysicsProductID, slagRecipesProductID]
  
  public static let productDescriptions = [removeAdsProductID : "Slag them annoying ads!",
                                           chroniclesSlagmanProductID : "The Chronicles of Slagman!  A collection of carefully handcrafted challenges that will test your slagging abilities to the limits!  Introducing a new theme, new obstacles, new music, and other slagging goodness.",
                                           slagPhysicsProductID : "Slag Physics!  A collection of carefully handcrafted challenges that will warp your mind!  Is Slagman here, or is he there? Purchase this collection, and find out!  Introducing a new theme, new obstacles, new music, and other slagging goodness.",
                                           slagRecipesProductID : "Slag Recipes!  A collection of carefully handcrafted challenges that will wet your tongue!  Introducing a new theme, new obstacles, new music, and other slagging tastiness."]
  
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
