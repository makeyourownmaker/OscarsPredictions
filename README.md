# OscarsPredictions

![Lifecycle
](https://img.shields.io/badge/lifecycle-experimental-orange.svg?style=flat)
![R
%>%= 3.2.0](https://img.shields.io/badge/R->%3D3.2.0-blue.svg?style=flat)

Oscars predictions using a Bradley-Terry model and stan

If you like OscarsPredictions, give it a star, or fork it and contribute!


## Installation/Usage

Requires R version 3.2.0 and higher.

To install the required libraries in an R session:
```r
install.packages("data.table")
install.packages("ggplot2")
install.packages("rstan")
```

Clone repository:
```r
git clone https://github.com/makeyourownmaker/OscarsPredictions
cd OscarsPredictions
```

Then run file(s) in an R session:
```r
setwd("OscarsPredictions")
source("oscars-bradley-terry-teams-multiyear.R", echo = TRUE)
```


## Roadmap

* NEXT
  * More thorough diagnostic checks
  * Vecrorise stan model - should not change results
  * Make predictions for 2007
  * Check how including older data modifies prediction accuracy
  * Include additional information:
    * Such as Golden Globe genre (drama, comedy, musical etc) nominations/wins
    * See [Oscarmetrics by Ben Zauzmer](http://www.bearmanormedia.com/oscarmetrics-hardcover-edition-by-ben-zauzmer)
  * Expand to other categories: Best Picture, Best Male actor and Best Female actress
* Update data
  * The number of best picture nominations expanded from 5 to 8, 9 or 10 in 2009
* Improve documentation
* [Learning to rank](https://en.wikipedia.org/wiki/Learning_to_rank)
  models are interesting in their own right so deserve a separate repository

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Data updates are especially welcome.


## Alternatives

* [Model, peer reviewed article and data from Iain Pardoe](https://iainpardoe.com/oscars/)
  * Discrete choice multinomial model based on data going back to 1928
* Multiple models from 538
  * [Election-style Oscars predictions](https://fivethirtyeight.com/features/oscar-predictions-election-style/)
    * Aggregating guild and press awards (similar approach to his election poll work)
    * Nate Silver from 2013 to 2016
  * [Oscars Tracker](https://fivethirtyeight.com/features/how-our-oscars-tracker-works/)
    * Similar to the Nate Silver model but covering more Oscar categories
    * Walter Hickey since 2017
    * [Walter Hickey's Oscars model](https://github.com/walterhickey/oscars/) I've not checked this repository
* Models from others
  * [Sentiment models based on twiiter and google news data](https://fivethirtyeight.com/features/can-the-internet-predict-the-oscars/)
  * [Movie box office and Rotten Tomatoes ratings](https://fivethirtyeight.com/features/how-much-do-we-need-to-know-to-predict-the-oscars/)
  * [More guild and press awards and going back as far as the 1970s](https://fivethirtyeight.com/features/how-much-do-we-need-to-know-to-predict-the-oscars/)
  * [Ben Zauzmer who uses awards, critics groups, online ratings aggregations, craft guild nominations etc](https://twitter.com/BensOscarMath)


## See Also

* [Stan](https://mc-stan.org/) and [rstan](https://cran.r-project.org/web/packages/rstan/index.html)
* [Bradley-Terry models](https://en.wikipedia.org/wiki/Bradley%E2%80%93Terry_model)
* [Bradley-Terry example model with stan](https://github.com/stan-dev/example-models/tree/master/knitr/bradley-terry)
* [Oscarmetrics by Ben Zauzmer](http://www.bearmanormedia.com/oscarmetrics-hardcover-edition-by-ben-zauzmer)

## License

[GPL-2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
