//
//  SubscriptionCustomisationTests.swift
//  PurchasePackageTests
//
//  Created by Josh Robbins on 2/8/24.
//

@testable import PurchasePackage
import XCTest

class SubscriptionCustomisationTests: XCTestCase {
  func testSubscriptionCustomisationInitialization() {
    let headerNames = SubscriptionTypeHeaderNames(
      annual: "Yearly Subscription",
      custom: "Bespoke Plan",
      lifetime: "Lifetime Access",
      monthly: "Monthly Plan",
      sixMonth: "Half-Yearly",
      threeMonth: "Quarterly",
      twoMonth: "Every Two Months",
      unknown: "Unknown Plan",
      weekly: "Weekly Subscription"
    )

    let priceSuffixes = SubscriptionTypeSuffixes(
      annual: " annually",
      custom: " - Custom Price",
      lifetime: " - One Time",
      monthly: " per month",
      sixMonth: " every six months",
      threeMonth: " quarterly",
      twoMonth: " bimonthly",
      unknown: " - ",
      weekly: " every week"
    )

    let customisation = SubscriptionCustomisation(
      headerNames: headerNames,
      priceSuffixes: priceSuffixes,
      termsAndConditions: TermsAndConditions()
    )

    XCTAssertEqual(customisation.headerNames.annual, "Yearly Subscription")
    XCTAssertEqual(customisation.priceSuffixes.annual, " annually")

    let termsAndConditions = customisation.termsAndConditions.termsAndConditionsURL
    let privacy = customisation.termsAndConditions.privacyPolicy

    XCTAssertEqual(
      termsAndConditions,
      URL(string: "https://www.twinkl.com/legal#terms-and-conditions")
    )
    XCTAssertEqual(
      privacy,
      URL(string: "https://www.twinkl.co.uk/legal#privacy-policy")
    )
  }

  func testEquatableConformanceOfSubscriptionCustomisation() {

    let customisationOne = SubscriptionCustomisation(
      headerNames: SubscriptionTypeHeaderNames(),
      priceSuffixes: SubscriptionTypeSuffixes(),
      termsAndConditions: TermsAndConditions()
    )

    let customisationTwo = SubscriptionCustomisation(
      headerNames: SubscriptionTypeHeaderNames(),
      priceSuffixes: SubscriptionTypeSuffixes(),
      termsAndConditions: TermsAndConditions()
    )

    var customHeaderNames = SubscriptionTypeHeaderNames()
    customHeaderNames.annual = "Custom Annual"

    let customTermsAndConditions = TermsAndConditions(termsAndConditionsURL: "https://www.foo", privacyPolicy: "https://www.bar")

    let customisationThree = SubscriptionCustomisation(
      headerNames: customHeaderNames,
      priceSuffixes: SubscriptionTypeSuffixes(),
      termsAndConditions: customTermsAndConditions
    )

    XCTAssertEqual(
      customisationOne,
      customisationTwo,
      "Customisation instances with identical values should be equal"
    )
    XCTAssertNotEqual(
      customisationOne,
      customisationThree,
      "Customisation instances with different values should not be equal"
    )
  }

  func testIndividualPropertyCustomization() {
    var customHeaderNames = SubscriptionTypeHeaderNames()
    customHeaderNames.monthly = "Monthly Access"

    var customPriceSuffixes = SubscriptionTypeSuffixes()
    customPriceSuffixes.monthly = " per 30 days"

    let customisation = SubscriptionCustomisation(
      headerNames: customHeaderNames,
      priceSuffixes: customPriceSuffixes,
      termsAndConditions: TermsAndConditions()
    )

    XCTAssertEqual(
      customisation.headerNames.monthly,
      "Monthly Access",
      "Monthly header name should be customized correctly."
    )
    XCTAssertEqual(
      customisation.priceSuffixes.monthly,
      " per 30 days",
      "Monthly price suffix should be customized correctly."
    )

    XCTAssertEqual(customisation.headerNames.annual, "Annual Subscription", "Annual header name should remain default.")
    XCTAssertEqual(customisation.priceSuffixes.annual, " per year", "Annual price suffix should remain default.")
  }

  func testModificationAfterInitialization() {
    var headerNames = SubscriptionTypeHeaderNames()
    let priceSuffixes = SubscriptionTypeSuffixes()

    var customisation = SubscriptionCustomisation(
      headerNames: headerNames,
      priceSuffixes: priceSuffixes,
      termsAndConditions: TermsAndConditions()
    )

    XCTAssertEqual(customisation.headerNames.annual, "Annual Subscription", "Initial value should be the default.")

    headerNames.annual = "Yearly Plan"
    customisation.headerNames = headerNames

    XCTAssertEqual(customisation.headerNames.annual, "Yearly Plan", "Header name should be updated to new value.")
  }

  func testEquatableWithPartialCustomization() {
    let defaultCustomisation = SubscriptionCustomisation(
      headerNames: SubscriptionTypeHeaderNames(),
      priceSuffixes: SubscriptionTypeSuffixes(),
      termsAndConditions: TermsAndConditions()
    )

    var customHeaderNames = SubscriptionTypeHeaderNames()
    customHeaderNames.weekly = "Weekly Special"

    let partiallyCustomised = SubscriptionCustomisation(
      headerNames: customHeaderNames,
      priceSuffixes: SubscriptionTypeSuffixes(),
      termsAndConditions: TermsAndConditions()
    )

    XCTAssertNotEqual(
      defaultCustomisation,
      partiallyCustomised,
      "Partially customized instance should not be equal to the default instance."
    )
  }

  func testEdgeCasesInCustomization() {
    let customHeaderNames = SubscriptionTypeHeaderNames(custom: "👻 Special", monthly: "")
    let customPriceSuffixes = SubscriptionTypeSuffixes(custom: "", monthly: "per 4 weeks")

    let edgeCaseCustomisation = SubscriptionCustomisation(
      headerNames: customHeaderNames,
      priceSuffixes: customPriceSuffixes,
      termsAndConditions: TermsAndConditions()
    )

    XCTAssertEqual(edgeCaseCustomisation.headerNames.monthly, "", "Monthly header name should accept empty string.")
    XCTAssertEqual(
      edgeCaseCustomisation.headerNames.custom,
      "👻 Special",
      "Custom header name should accept emojis."
    )
    XCTAssertEqual(
      edgeCaseCustomisation.priceSuffixes.monthly,
      "per 4 weeks",
      "Monthly price suffix should be customized correctly."
    )
    XCTAssertEqual(
      edgeCaseCustomisation.priceSuffixes.custom,
      "",
      "Custom price suffix should accept empty string."
    )
  }
}
