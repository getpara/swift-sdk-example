# Para Swift SDK Example App

A simple example app demonstrating Para Swift SDK integration. For detailed setup instructions, see the [official Para documentation](https://docs.getpara.com/getting-started/initial-setup/swift-sdk-setup).

## Quick Start

1. Set required environment variables in Xcode (Scheme > Edit Scheme > Arguments > Environment Variables):
```
PARA_ENVIRONMENT=beta    # Options: "dev", "sandbox", "beta", "prod"
PARA_API_KEY=your_api_key_here
```

2. Open `example.xcodeproj` and run the app

## Features
- User authentication with passkeys
- Wallet management
- EVM signing (using Sepolia testnet)

## Beta Testing Credentials
When using the `beta` environment:
- Email: any address ending in `@test.getpara.com` (e.g. dev@test.getpara.com)
- Phone: US numbers (+1) in format `(area code)-555-xxxx` (e.g. (425)-555-1234)
- Any OTP code will work for verification
 