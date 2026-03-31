import Foundation

struct VerifyIAPRequest: Encodable {
    let productId: String
    let transactionId: String
    let receiptData: String
}

struct VerifyIAPResponse: Decodable {
    let orderId: String
    let status: String
    let creditsGranted: Int
    let balanceAfter: Int
}

struct CreditBalance: Decodable {
    let availableCredits: Int
    let frozenCredits: Int
    let currency: String
}