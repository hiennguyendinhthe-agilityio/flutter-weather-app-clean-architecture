import 'package:flutter/material.dart';

class PortfolioPoint {
  final String label;
  final double value;
  PortfolioPoint(this.label, this.value);
}

class Asset {
  final String id;
  final String symbol;
  final String name;
  final String category;
  final double price;
  final double change;
  final double changeAmount;
  final double holdings;
  final Color color;
  final IconData icon;
  final List<PortfolioPoint> chartData;
  final String description;

  const Asset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.category,
    required this.price,
    required this.change,
    required this.changeAmount,
    required this.holdings,
    required this.color,
    required this.icon,
    required this.chartData,
    required this.description,
  });

  double get totalValue => price * holdings;

  bool get isPositive => change >= 0;
}

List<PortfolioPoint> portfolioHistory = [
  PortfolioPoint('Jan', 42500),
  PortfolioPoint('Feb', 38200),
  PortfolioPoint('Mar', 45800),
  PortfolioPoint('Apr', 52300),
  PortfolioPoint('May', 49100),
  PortfolioPoint('Jun', 58700),
  PortfolioPoint('Jul', 55200),
  PortfolioPoint('Aug', 63400),
];
final List<Asset> allAssets = [
  // ── Stocks ─────────────────────────────────
  Asset(
    id: 'aapl',
    symbol: 'AAPL',
    name: 'Apple Inc.',
    category: 'Stocks',
    price: 189.84,
    change: 2.34,
    changeAmount: 4.33,
    holdings: 15,
    color: const Color(0xFF6C63FF),
    icon: Icons.phone_iphone,
    description:
        'Apple Inc. designs, manufactures, and markets smartphones, '
        'personal computers, tablets, wearables, and accessories. '
        'One of the most valuable companies in the world.',
    chartData: [
      PortfolioPoint('Mon', 182.5),
      PortfolioPoint('Tue', 185.2),
      PortfolioPoint('Wed', 183.8),
      PortfolioPoint('Thu', 187.1),
      PortfolioPoint('Fri', 189.84),
    ],
  ),
  Asset(
    id: 'tsla',
    symbol: 'TSLA',
    name: 'Tesla Inc.',
    category: 'Stocks',
    price: 248.50,
    change: -1.82,
    changeAmount: -4.60,
    holdings: 8,
    color: const Color(0xFFFF6B6B),
    icon: Icons.electric_car,
    description:
        'Tesla, Inc. designs, develops, manufactures, leases, and sells '
        'electric vehicles, energy generation and storage systems. '
        'Pioneer in EV technology and renewable energy.',
    chartData: [
      PortfolioPoint('Mon', 255.3),
      PortfolioPoint('Tue', 251.8),
      PortfolioPoint('Wed', 253.1),
      PortfolioPoint('Thu', 250.4),
      PortfolioPoint('Fri', 248.5),
    ],
  ),
  Asset(
    id: 'googl',
    symbol: 'GOOGL',
    name: 'Alphabet Inc.',
    category: 'Stocks',
    price: 141.80,
    change: 0.95,
    changeAmount: 1.34,
    holdings: 20,
    color: Color(0xFF00BFA5),
    icon: Icons.search,
    description:
        'Alphabet Inc. is the parent company of Google and several '
        'other businesses. Google Search, YouTube, Android, and '
        'Google Cloud are among its key products.',
    chartData: [
      PortfolioPoint('Mon', 138.2),
      PortfolioPoint('Tue', 139.5),
      PortfolioPoint('Wed', 140.1),
      PortfolioPoint('Thu', 141.0),
      PortfolioPoint('Fri', 141.80),
    ],
  ),
  // ── Crypto ─────────────────────────────────
  Asset(
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    category: 'Crypto',
    price: 67842.30,
    change: 3.21,
    changeAmount: 2113.5,
    holdings: 0.5,
    color: Color(0xFFFFB300),
    icon: Icons.currency_bitcoin,
    description:
        'Bitcoin is the first and most well-known cryptocurrency. '
        'A decentralized digital currency that operates on a '
        'peer-to-peer network without a central authority.',
    chartData: [
      PortfolioPoint('Mon', 64200),
      PortfolioPoint('Tue', 65800),
      PortfolioPoint('Wed', 63500),
      PortfolioPoint('Thu', 66100),
      PortfolioPoint('Fri', 67842),
    ],
  ),
  Asset(
    id: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    category: 'Crypto',
    price: 3542.10,
    change: 4.15,
    changeAmount: 141.2,
    holdings: 2.5,
    color: Color(0xFF26C6DA),
    icon: Icons.diamond_outlined,
    description:
        'Ethereum is a decentralized, open-source blockchain platform '
        'that enables smart contracts and decentralized applications. '
        'The second-largest cryptocurrency by market cap.',
    chartData: [
      PortfolioPoint('Mon', 3380),
      PortfolioPoint('Tue', 3410),
      PortfolioPoint('Wed', 3390),
      PortfolioPoint('Thu', 3480),
      PortfolioPoint('Fri', 3542),
    ],
  ),
  // ── ETFs ───────────────────────────────────
  Asset(
    id: 'spy',
    symbol: 'SPY',
    name: 'S&P 500 ETF',
    category: 'ETFs',
    price: 512.44,
    change: 0.68,
    changeAmount: 3.47,
    holdings: 10,
    color: Color(0xFF66BB6A),
    icon: Icons.bar_chart,
    description:
        'SPDR S&P 500 ETF Trust tracks the S&P 500 Index, '
        'providing broad exposure to large-cap U.S. equities. '
        'One of the most heavily traded ETFs in the world.',
    chartData: [
      PortfolioPoint('Mon', 508.1),
      PortfolioPoint('Tue', 509.5),
      PortfolioPoint('Wed', 510.8),
      PortfolioPoint('Thu', 511.9),
      PortfolioPoint('Fri', 512.44),
    ],
  ),
  Asset(
    id: 'qqq',
    symbol: 'QQQ',
    name: 'Nasdaq-100 ETF',
    category: 'ETFs',
    price: 438.92,
    change: 1.24,
    changeAmount: 5.38,
    holdings: 7,
    color: Color(0xFFAB47BC),
    icon: Icons.trending_up,
    description:
        'Invesco QQQ Trust tracks the Nasdaq-100 Index, '
        'providing exposure to 100 of the largest non-financial '
        'companies listed on the Nasdaq stock exchange.',
    chartData: [
      PortfolioPoint('Mon', 432.5),
      PortfolioPoint('Tue', 434.2),
      PortfolioPoint('Wed', 435.8),
      PortfolioPoint('Thu', 437.5),
      PortfolioPoint('Fri', 438.92),
    ],
  ),
  // ── Bonds ──────────────────────────────────
  Asset(
    id: 'tlt',
    symbol: 'TLT',
    name: 'US Treasury Bond',
    category: 'Bonds',
    price: 96.28,
    change: -0.42,
    changeAmount: -0.41,
    holdings: 25,
    color: Color(0xFF8D6E63),
    icon: Icons.account_balance,
    description:
        'iShares 20+ Year Treasury Bond ETF tracks U.S. Treasury bonds '
        'with remaining maturities greater than 20 years. '
        'Used for portfolio diversification and income.',
    chartData: [
      PortfolioPoint('Mon', 96.8),
      PortfolioPoint('Tue', 96.5),
      PortfolioPoint('Wed', 96.7),
      PortfolioPoint('Thu', 96.4),
      PortfolioPoint('Fri', 96.28),
    ],
  ),
];
// Categories
const List<String> categories = ['All', 'Stocks', 'Crypto', 'ETFs', 'Bonds'];

// Category colors
const Map<String, Color> categoryColors = {
  'All': Color(0xFF6C63FF),
  'Stocks': Color(0xFF6C63FF),
  'Crypto': Color(0xFFFFB300),
  'ETFs': Color(0xFF66BB6A),
  'Bonds': Color(0xFF8D6E63),
};
