//
//  StripeAPI.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import APIKit
import Result

class StripeAPI {
}

extension StripeAPI {
    struct Customer {
        typealias RetrieveResponse = StripeAPI.Entity.Customer
        /// https://stripe.com/docs/api#retrieve_customer
        /// Retrieves the details of an existing customer. You need only supply the unique customer identifier that was returned upon customer creation.
        @discardableResult
        static func retrieve(customerID: String, handler: @escaping (Result<RetrieveResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = RetrieveRequest(customerID: customerID)
            return Session.shared.send(request, handler: handler)
        }

        private struct RetrieveRequest: StripeAPIRequest {
            typealias Response = RetrieveResponse

            let customerID: String

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                return "customers/\(customerID)"
            }
        }

        typealias CreateResponse = StripeAPI.Entity.Customer
        /// https://stripe.com/docs/api#create_customer
        /// Creates a new customer object.
        @discardableResult
        static func create(email: String? = nil,
                           description: String? = nil,
                           handler: @escaping (Result<CreateResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = CreateRequest(email: email, description: description)
            return Session.shared.send(request, handler: handler)
        }

        private struct CreateRequest: StripeAPIRequest {
            typealias Response = CreateResponse

            let email: String?
            let description: String?

            var method: HTTPMethod {
                return .post
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [:]
                if let email = email {
                    parameters["email"] = email
                }
                if let description = description {
                    parameters["description"] = description
                }
                return parameters
            }

            var path: String {
                return "customers"
            }
        }
    }

    struct Product {
        typealias AllResponse = StripeAPI.Entity.ListResponse<StripeAPI.Entity.Product>
        /// https://stripe.com/docs/api#list_products
        /// Returns a list of your products. The products are returned sorted by creation date, with the most recently created products appearing first.
        @discardableResult
        static func all(handler: @escaping (Result<AllResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = AllRequest()
            return Session.shared.send(request, handler: handler)
        }

        private struct AllRequest: StripeAPIRequest {
            typealias Response = AllResponse

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                return "products"
            }
        }
    }
}


extension StripeAPI {
    struct Connect { }
}

extension StripeAPI.Connect {
    struct Account {
        typealias CreateResponse = StripeAPI.Entity.Connect.Account
        typealias RetrieveResponse = StripeAPI.Entity.Connect.Account

        private struct CreateRequest: StripeAPIRequest {
            typealias Response = CreateResponse

            let email: String
            let country: String?
            let type: String

            var method: HTTPMethod {
                return .post
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [:]
                parameters["email"] = email
                if let country = country {
                    parameters["country"] = country
                }
                parameters["type"] = type
                return parameters
            }

            var path: String {
                return "accounts"
            }
        }

        private struct RetrieveRequest: StripeAPIRequest {
            typealias Response = RetrieveResponse

            let accountID: String?

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                if let accountID = accountID {
                    return "accounts/\(accountID)"
                } else {
                    return "accounts"
                }

            }
        }

        /// https://stripe.com/docs/api#create_account
        /// Creates a new account object.
        @discardableResult
        static func create(email: String,
                           country: String? = nil,
                           type: String = "custom",
                           handler: @escaping (Result<CreateResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = CreateRequest(email: email, country: country, type: type)
            return Session.shared.send(request, handler: handler)
        }

        /// https://stripe.com/docs/api#retrieve_account
        /// Retrieves the details of an existing account. If accountID is nil, default to the account of the API key.
        @discardableResult
        static func retrieve(accountID: String?, handler: @escaping (Result<RetrieveResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = RetrieveRequest(accountID: accountID)
            return Session.shared.send(request, handler: handler)
        }
    }

    struct FeeRefund {
        typealias CreateResponse = StripeAPI.Entity.Connect.FeeRefund
        typealias RetrieveResponse = StripeAPI.Entity.Connect.FeeRefund
        typealias AllResponse = StripeAPI.Entity.ListResponse<StripeAPI.Entity.Connect.FeeRefund>

        private struct CreateRequest: StripeAPIRequest {
            typealias Response = CreateResponse

            let feeID: String
            let amount: Int?
            let metadata: [AnyHashable: Any]?

            var method: HTTPMethod {
                return .post
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [:]
                if let amount = amount {
                    parameters["amount"] = amount
                }
                if let metadata = metadata {
                    parameters["metadata"] = metadata
                }
                return parameters
            }

            var path: String {
                return "application_fees/\(feeID)/refunds"
            }
        }

        private struct RetrieveRequest: StripeAPIRequest {
            typealias Response = RetrieveResponse

            let feeID: String
            let refundID: String

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                return "application_fees/\(feeID)/refunds/\(refundID)"
            }
        }

        private struct AllRequest: StripeAPIRequest {
            typealias Response = AllResponse

            let feeID: String

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                return "application_fees/\(feeID)/refunds"
            }
        }

        /// https://stripe.com/docs/api#retrieve_fee_refund
        /// Retrieves the details of an existing application refund fee.
        @discardableResult
        static func retrieve(feeID: String, refundID: String, handler: @escaping (Result<RetrieveResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = RetrieveRequest(feeID: feeID, refundID: refundID)
            return Session.shared.send(request, handler: handler)
        }

        /// https://stripe.com/docs/api#create_fee_refund
        /// Creates a new application fee refund object.
        @discardableResult
        static func create(feeID: String,
                           amount: Int? = nil,
                           metadata: [AnyHashable: Any]? = nil,
                           handler: @escaping (Result<CreateResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = CreateRequest(feeID: feeID, amount: amount, metadata: metadata)
            return Session.shared.send(request, handler: handler)
        }

        /// https://stripe.com/docs/api#list_fee_refunds
        /// Returns a list of application fee refund.
        @discardableResult
        static func all(feeID: String, handler: @escaping (Result<AllResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = AllRequest(feeID: feeID)
            return Session.shared.send(request, handler: handler)
        }
    }

    struct Fee {
        typealias RetrieveResponse = StripeAPI.Entity.Connect.Fee
        typealias AllResponse = StripeAPI.Entity.ListResponse<StripeAPI.Entity.Connect.Fee>

        private struct RetrieveRequest: StripeAPIRequest {
            typealias Response = RetrieveResponse

            let feeID: String

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                return "application_fees/\(feeID)"
            }
        }

        private struct AllRequest: StripeAPIRequest {

            typealias Response = AllResponse

            let chargeID: String?
            let created: [String: TimeInterval]?
            let endingBefore: String?
            let limit: Int?
            let startingAfter: String?

            var method: HTTPMethod {
                return .get
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [:]
                if let chargeID = chargeID {
                    parameters["charge"] = chargeID
                }
                if let created = created {
                    parameters["created"] = created
                }
                if let endingBefore = endingBefore {
                    parameters["ending_before"] = endingBefore
                }
                if let limit = limit {
                    parameters["limit"] = limit
                }
                if let startingAfter = startingAfter {
                    parameters["starting_after"] = startingAfter
                }

                return parameters
            }

            var path: String {
                return "application_fees"
            }
        }

        /// https://stripe.com/docs/api#retrieve_fee_refund
        /// Retrieves the details of an existing application fee.
        @discardableResult
        static func retrieve(feeID: String, handler: @escaping (Result<RetrieveResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = RetrieveRequest(feeID: feeID)
            return Session.shared.send(request, handler: handler)
        }

        /// https://stripe.com/docs/api#list_fee_refunds
        /// Returns a list of application fee.
        @discardableResult
        static func all(chargeID: String? = nil,
                        created: [String: TimeInterval]? = nil,
                        endingBefore: String? = nil,
                        limit: Int? = nil,
                        startingAfter: String? = nil,
                        handler: @escaping (Result<AllResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = AllRequest(chargeID: chargeID,
                                     created: created,
                                     endingBefore: endingBefore,
                                     limit: limit,
                                     startingAfter: startingAfter)
            return Session.shared.send(request, handler: handler)
        }
    }

    struct BankAccount {
        typealias CreateResponse = StripeAPI.Entity.Connect.BankAccount
        typealias RetrieveResponse = StripeAPI.Entity.Connect.BankAccount
        typealias AllResponse = StripeAPI.Entity.ListResponse<StripeAPI.Entity.Connect.BankAccount>

        private struct CreateRequest: StripeAPIRequest {
            typealias Response = CreateResponse

            let accountID: String

            let accountNumber: String
            let country: String
            let currency: String
            let accountHolderName: String?
            let accountHolderType: String?
            let routingNumber: String?
            let defaultForCurrency: Bool?
            let metadata: [AnyHashable: String]?

            var method: HTTPMethod {
                return .post
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [:]
                parameters["external_account"] = [
                    "account_number": accountNumber,
                    "country": country,
                    "currency": currency,
                ]
                if let accountHolderName = accountHolderName {
                    parameters["account_holder_name"] = accountHolderName
                }
                if let accountHolderType = accountHolderType {
                    parameters["account_holder_type"] = accountHolderType
                }
                if let routingNumber = routingNumber {
                    parameters["routing_number"] = routingNumber
                }
                if let defaultForCurrency = defaultForCurrency {
                    parameters["default_for_currency"] = defaultForCurrency
                }
                if let metadata = metadata {
                    parameters["metadata"] = metadata
                }
                return parameters
            }

            var path: String {
                return "accounts/\(accountID)/external_accounts"
            }
        }

        private struct RetrieveRequest: StripeAPIRequest {
            typealias Response = RetrieveResponse

            let accountID: String

            let bankAccountID: String

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                return "accounts/\(accountID)/external_accounts/\(bankAccountID)"
            }
        }

        private struct AllRequest: StripeAPIRequest {
            typealias Response = AllResponse

            let accountID: String

            let endingBefore: String?
            let limit: Int?
            let startingAfter: String?

            var method: HTTPMethod {
                return .get
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [:]
                if let endingBefore = endingBefore {
                    parameters["ending_before"] = endingBefore
                }
                if let limit = limit {
                    parameters["limit"] = limit
                }
                if let startingAfter = startingAfter {
                    parameters["starting_after"] = startingAfter
                }

                return parameters
            }

            var path: String {
                return "accounts/\(accountID)/external_accounts"
            }
        }

        /// https://stripe.com/docs/api#account_retrieve_bank_account
        /// Retrieves the details of an existing bank account.
        @discardableResult
        static func retrieve(accountID: String, bankAccountID: String, handler: @escaping (Result<RetrieveResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = RetrieveRequest(accountID: accountID, bankAccountID: bankAccountID)
            return Session.shared.send(request, handler: handler)
        }

        /// https://stripe.com/docs/api#account_create_bank_account
        /// Creates a new bank account object.
        @discardableResult
        static func create(accountID: String,
                           accountNumber: String,
                           country: String,
                           currency: String,
                           accountHolderName: String? = nil,
                           accountHolderType: String? = nil,
                           routingNumber: String? = nil,
                           defaultForCurrency: Bool? = nil,
                           metadata: [AnyHashable: String]? = nil,
                           handler: @escaping (Result<CreateResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = CreateRequest(accountID: accountID,
                                        accountNumber: accountNumber,
                                        country: country,
                                        currency: currency,
                                        accountHolderName: accountHolderName,
                                        accountHolderType: accountHolderType,
                                        routingNumber: routingNumber,
                                        defaultForCurrency: defaultForCurrency,
                                        metadata: metadata)
            return Session.shared.send(request, handler: handler)
        }

        /// https://stripe.com/docs/api#account_list_bank_accounts
        /// Returns a list of bank account.
        @discardableResult
        static func all(accountID: String,
                        endingBefore: String? = nil,
                        limit: Int? = nil,
                        startingAfter: String? = nil,
                        handler: @escaping (Result<AllResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = AllRequest(accountID: accountID,
                                     endingBefore: endingBefore,
                                     limit: limit,
                                     startingAfter: startingAfter)
            return Session.shared.send(request, handler: handler)
        }
    }
}
