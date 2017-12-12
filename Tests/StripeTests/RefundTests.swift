//
//  RefundTests.swift
//  Stripe
//
//  Created by Anthony Castelli on 5/13/17.
//
//

import XCTest
@testable import Stripe
@testable import Vapor





class RefundTests: XCTestCase {
        
    var drop: Droplet?
    var refundId: String = ""
    
    override func setUp() {
        do {
            drop = try self.makeDroplet()
            
            let cardToken = try drop?.stripe?.tokens.createCardToken(withCardNumber: "4242 4242 4242 4242",
                                                                   expirationMonth: 10,
                                                                   expirationYear: 2018,
                                                                   cvc: 123,
                                                                   name: "Test Card",
                                                                   customer: nil,
                                                                   currency: nil)
                                                                   .serializedResponse().id ?? ""
            
            let chargeId = try drop?.stripe?.charge.create(amount: 10_00,
                                                           in: .usd,
                                                           withFee: nil,
                                                           toAccount: nil,
                                                           capture: true,
                                                           description: "Vapor Stripe: Test Description",
                                                           destinationAccountId: nil,
                                                           destinationAmount: nil,
                                                           transferGroup: nil,
                                                           onBehalfOf: nil,
                                                           receiptEmail: nil,
                                                           shippingLabel: nil,
                                                           customer: nil,
                                                           statementDescriptor: nil,
                                                           source: cardToken,
                                                           metadata: nil)
                                                           .serializedResponse().id ?? ""
            
            refundId = try drop?.stripe?.refunds.createRefund(charge: chargeId,
                                                              amount: 5_00,
                                                              reason: .requestedByCustomer,
                                                              refundApplicationFee: nil,
                                                              reverseTransfer: nil,
                                                              metadata: nil)
                                                              .serializedResponse().id ?? ""
        }
        catch let error as StripeError {
            
            switch error {
            case .apiConnectionError:
                XCTFail(error.localizedDescription)
            case .apiError:
                XCTFail(error.localizedDescription)
            case .authenticationError:
                XCTFail(error.localizedDescription)
            case .cardError:
                XCTFail(error.localizedDescription)
            case .invalidRequestError:
                XCTFail(error.localizedDescription)
            case .rateLimitError:
                XCTFail(error.localizedDescription)
            case .validationError:
                XCTFail(error.localizedDescription)
            case .invalidSourceType:
                XCTFail(error.localizedDescription)
            default:
                XCTFail(error.localizedDescription)
            }
        }
        catch {
            fatalError("Setup failed: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        drop = nil
        refundId = ""
    }
    
    func testRefunding() throws {
        do {
            let cardToken = try drop?.stripe?.tokens.createCardToken(withCardNumber: "4242 4242 4242 4242",
                                                                        expirationMonth: 10,
                                                                        expirationYear: 2018,
                                                                        cvc: 123,
                                                                        name: "Test Card",
                                                                        customer: nil,
                                                                        currency: nil)
                                                                        .serializedResponse().id ?? ""
            
            let charge = try drop?.stripe?.charge.create(amount: 10_00,
                                                         in: .usd,
                                                         withFee: nil,
                                                         toAccount: nil,
                                                         capture: true,
                                                         description: "Vapor Stripe: Test Description",
                                                         destinationAccountId: nil,
                                                         destinationAmount: nil,
                                                         transferGroup: nil,
                                                         onBehalfOf: nil,
                                                         receiptEmail: nil,
                                                         shippingLabel: nil,
                                                         customer: nil,
                                                         statementDescriptor: nil,
                                                         source: cardToken,
                                                         metadata: nil)
                                                         .serializedResponse().id ?? ""
            
            let metadata = Node(["hello":"world"])
            
            let refund = try drop?.stripe?.refunds.createRefund(charge: charge,
                                                                amount: 5_00,
                                                                reason: .requestedByCustomer,
                                                                refundApplicationFee: false,
                                                                reverseTransfer: false,
                                                                metadata: metadata)
                                                                .serializedResponse()
            XCTAssertNotNil(refund)
            
            XCTAssertEqual(refund?.metadata?.object?["hello"], metadata["hello"])
            
            XCTAssertEqual(refund?.amount, 5_00)
            
            XCTAssertEqual(refund?.reason, .requestedByCustomer)
        }
        catch let error as StripeError {
            
            switch error {
            case .apiConnectionError:
                XCTFail(error.localizedDescription)
            case .apiError:
                XCTFail(error.localizedDescription)
            case .authenticationError:
                XCTFail(error.localizedDescription)
            case .cardError:
                XCTFail(error.localizedDescription)
            case .invalidRequestError:
                XCTFail(error.localizedDescription)
            case .rateLimitError:
                XCTFail(error.localizedDescription)
            case .validationError:
                XCTFail(error.localizedDescription)
            case .invalidSourceType:
                XCTFail(error.localizedDescription)
            default:
                XCTFail(error.localizedDescription)
            }
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testUpdatingRefund() throws {
        do {
            let metadata = Node(["hello":"world"])
            
            let updatedRefund = try drop?.stripe?.refunds.update(metadata: metadata,
                                                                 refund: refundId)
                                                                 .serializedResponse()
            XCTAssertNotNil(updatedRefund)
            
            XCTAssertEqual(updatedRefund?.metadata?.object?["hello"], metadata["hello"])
            
            XCTAssertEqual(updatedRefund?.amount, 5_00)
        }
        catch let error as StripeError {
            
            switch error {
            case .apiConnectionError:
                XCTFail(error.localizedDescription)
            case .apiError:
                XCTFail(error.localizedDescription)
            case .authenticationError:
                XCTFail(error.localizedDescription)
            case .cardError:
                XCTFail(error.localizedDescription)
            case .invalidRequestError:
                XCTFail(error.localizedDescription)
            case .rateLimitError:
                XCTFail(error.localizedDescription)
            case .validationError:
                XCTFail(error.localizedDescription)
            case .invalidSourceType:
                XCTFail(error.localizedDescription)
            default:
                XCTFail(error.localizedDescription)
            }
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRetrievingRefund() throws {
        do {
            let refund = try drop?.stripe?.refunds.retrieve(refund: refundId).serializedResponse()
            XCTAssertNotNil(refund)
        }
        catch let error as StripeError {
            
            switch error {
            case .apiConnectionError:
                XCTFail(error.localizedDescription)
            case .apiError:
                XCTFail(error.localizedDescription)
            case .authenticationError:
                XCTFail(error.localizedDescription)
            case .cardError:
                XCTFail(error.localizedDescription)
            case .invalidRequestError:
                XCTFail(error.localizedDescription)
            case .rateLimitError:
                XCTFail(error.localizedDescription)
            case .validationError:
                XCTFail(error.localizedDescription)
            case .invalidSourceType:
                XCTFail(error.localizedDescription)
            default:
                XCTFail(error.localizedDescription)
            }
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testListingAllRefunds() throws {
        do {
            let refunds = try drop?.stripe?.refunds.listAll(byChargeId: nil, filter: nil).serializedResponse()
            
            if let refundItems = refunds?.items {
                XCTAssertGreaterThanOrEqual(refundItems.count, 1)
            } else {
                XCTFail("Refunds are not present")
            }
        }
        catch let error as StripeError {
            
            switch error {
            case .apiConnectionError:
                XCTFail(error.localizedDescription)
            case .apiError:
                XCTFail(error.localizedDescription)
            case .authenticationError:
                XCTFail(error.localizedDescription)
            case .cardError:
                XCTFail(error.localizedDescription)
            case .invalidRequestError:
                XCTFail(error.localizedDescription)
            case .rateLimitError:
                XCTFail(error.localizedDescription)
            case .validationError:
                XCTFail(error.localizedDescription)
            case .invalidSourceType:
                XCTFail(error.localizedDescription)
            default:
                XCTFail(error.localizedDescription)
            }
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
