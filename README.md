[![Build](https://github.com/abin0992/CryptoLivePrice/actions/workflows/ci.yml/badge.svg)](https://github.com/abin0992/CryptoLivePrice/actions/workflows/ci.yml) 

# Crypto prices

The app loads latest crypto currency prices [from Coin Gecko API](https://www.coingecko.com/en/api)


## Features

For now only list screen is covered by tests 
The view model, the networking layer and models and business logic for this screen is completedly covered by unit tests
- The home page loads list of crypto currency prices in USD, lists in order of market capitilisation
- Pull to refresh the list
- Error handling with retry
- While selecting a crypto currency, the detail screeen is displayed
- Continuous Integration using github actions



## Tech Stack

- SwiftUI
- Combine
- Coordinator pattern for Navigation
- Clean Architecture


## Dependencies

#### The following 3rd party are added using Swift Package Manager
- Swinject - For dependency injection
  
## To do

- Add tests for detail screen
- Better error handling by adding custom error types and pass corresponding error title and message 
- Use better loading view for home 


## To tets the project
    1. Unzip the folder
    2. Wait till project loads swift packages
    3. Run the project


![Simulator Screen Recording - iPhone 15 Pro - 2024-02-11 at 19 02 29](https://github.com/abin0992/CryptoLivePrice/assets/10430402/ece63a6f-a98f-4d2e-ab69-e8eb4c76a33a)

