import Foundation

// MARK: - BitcoinModel
class BitcoinModel: Codable {
    let time, assetIDBase, assetIDQuote: String
    let rate: Double

    enum CodingKeys: String, CodingKey {
        case time
        case assetIDBase = "asset_id_base"
        case assetIDQuote = "asset_id_quote"
        case rate
    }

    init(time: String, assetIDBase: String, assetIDQuote: String, rate: Double) {
        self.time = time
        self.assetIDBase = assetIDBase
        self.assetIDQuote = assetIDQuote
        self.rate = rate
    }
}

