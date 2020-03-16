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


## Details

### Oscars

The Oscars are difficult to predict.  It's an annual event with a changing
electorate and frequent rule changes which do not apply uniformly to all
award categories.  For most of the history of the Oscars there have been
five nominations in each category.  Starting in 2009 the Academy of
Motion Picture Arts and Sciences expanded the nominations for best picture
to more than 5 films (but so far less than 10).  The best picture prize
uses [instant runoff voting](https://en.wikipedia.org/wiki/Instant-runoff_voting)
instead of
[first past the post](https://en.wikipedia.org/wiki/First-past-the-post_voting)
which is used for the other categories.

I'm not aware of anybody polling the greater than 5,000 academy members
eligible to vote; or anyone investigating the amounts studios spend on
lobbying for their nominees.  We can however look at current and past
Oscar nominations plus press and guild award winners.  There is likely
to be considerable overlap between the academy membership and the more
carrer-specific guilds such as Screen Actors Guild, Directors Guild,
Producers Guild etc.

### Model

Bradley-Terry (BT) models rank pairs of competitors.  They give the
probability that a competition will lead to a win or loss for either
competitor.
The BT model can be expanded by pairing the likelihood with a prior
to produce a Bayesian model which allows inference for future competitions.

One potential disadvantage of BT models is they do not permit draws.
This does not affect Oscar rankings where do not want, and should
not have, draws.

Here I present a BT model for "team"-based competitions where teams consist of
multiple "players", where teams are nominees and players are variables.  Each
player has an ability and the team's ability is
assumed to be additive on the log odds scale.  Interaction effects are
ignored for now.  Both player and team rankings can be estimated using
[stan](https://mc-stan.org/).

The BT model(s) in this repository are in the early stages of development
and will initially include the Best Director category.  They are based on
the
[stan Bradley-Terry example models](https://github.com/stan-dev/example-models/tree/master/knitr/bradley-terry).

A number of alternative models are briefly summarised in the
[Alternatives section](#Alternatives).

### Data

Data used come from [Iain Pardoe](https://iainpardoe.com/oscars/)
who is using a [discrete choice](https://en.wikipedia.org/wiki/Discrete_choice)
multinomial model to predict Oscar winners for the 4 main categories.

Immediately relevant variables for the Best director category include:

| Variable | Description                          |
|----------|--------------------------------------|
| DPrN     | Total previous directing nominations |
| DP       | Picture Oscar nomination             |
| Gd       | Golden globe director winer          |
| DGA      | Directors guild award winner         |

These variables are centered and scaled to mean 0 and standard deviation 1.

Initially only 10 years of data were considered.  Runtime is short, but
not negligible, so the number of years of data included will be increased
presently.

## Roadmap

* NEXT
  * More thorough diagnostic checks
  * Vectorise stan model - should decrease run time but not change results
  * Make predictions for 2007
  * Check how including older data modifies prediction accuracy
  * Include additional information:
    * Such as Golden Globe genre (drama, comedy, musical etc) nominations/wins
    * Consider interactions between variables
    * See [Oscarmetrics by Ben Zauzmer](http://www.bearmanormedia.com/oscarmetrics-hardcover-edition-by-ben-zauzmer)
  * Expand to other categories: Best Picture, Best Male actor and Best Female actress
* Update data
  * The number of best picture nominations expanded from 5 to 8, 9 or 10 in 2009
* Improve documentation
  * Expand the model description
    * Describe prior on player abilities
    * Describe hierarchal nature of model
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
