
### API used: ### 
CoinMarketCap (free tier)

https://coinmarketcap.com/api/documentation/v1

### Suggested improvements: ### 
- The overview should preferably show data for each crypto currency (e.g. percentage stats for the last hour or past 24 hours). 
This, however, requires a lot of extra API calls if using the free plan, so data is only shown in the details view.

### Good to know: ###
- The app supports USD and SEK. Due to API plan limitations, a new API call is made when switching between USD and SEK in the details view.
- The overview has a segmented controller for switching between USD and SEK, but this is currently only for selecting what currency a crypto currency’s details view is initially loaded with.
- The “More info” that is accessible through the crypto details view doesn’t work for all currencies due to some API responses containing different types than represented in the response Swift models.
  So if the "More info" view loads forever, it's because networking errors aren't handled (which they preferably should be in a production app, but was cut in this MVP case 🙂).

To test the happy flow of the app, Bitcoin should work!
