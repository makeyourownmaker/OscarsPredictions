

library(rstan)
library(ggplot2)
library(data.table)


# map (-infinity, infinty) -> (0, 1)
inv_logit <- function(u) 1 / (1 + exp(-u))

# map vector to vector with sum of zero
center <- function(u) u - sum(u) / length(u)


oscars <- read.table("oscars.csv", header = TRUE, sep = ",")


years <- seq(2006, 1987)
pvars   <- c('DGA', 'DN', 'DP', 'DPrN', 'Gd')  # "player" variables
pvars.c <- paste0(pvars, '.c')
Y <- length(years) # years
J <- length(pvars) # players per team
p <- 5             # teams per year
T <- Y * p         # teams
K <- T * J         # players
m <- p * (p - 1)   # matches per year - team vs team within each year but no self-play
N <- Y * m         # matches


# DD Best Director
min.year <- min(years) - 1
oscars.my <- oscars[oscars$Year > min.year & 
                    oscars$DD == 1 & 
                    oscars$Ch != 0, c("Year", "Name", "Movie", pvars, "Ch")]
oscars.my <- data.table(oscars.my)
oscars.my.orig <- oscars.my
oscars.my[, y:=ifelse(oscars.my$Ch == 2, 0, 1)]
lapply(seq_along(pvars), function(x) oscars.my[, pvars.c[x]:=center(get(pvars[x]))])

sigma <- 1  # scale of player ability variation
alpha <- c(t(oscars.my[, pvars.c, with=FALSE])) # player abilities for comparison plot


########################################################################################################
# Y = 10 years, m = 20 matches per year, J = 4 players per team, p = 5 teams per year, K = 200 players

players <- t(matrix(1:K, J, T))   # player IDs matrix for team0 & team1

team0.my <- array(NA, c(Y, m, J))        # players on team 0
team1.my <- array(NA, c(Y, m, J))        # players on team 1
alpha_team0.my <- array(NA, c(Y, m, J))  # ability of players on team 0
alpha_team1.my <- array(NA, c(Y, m, J))  # ability of players on team 1

for ( y in 1:Y ) {
  team0 <- matrix(NA, m, J)              # players on team 0
  team1 <- matrix(NA, m, J)              # players on team 1
  alpha_team0 <- matrix(NA, m, J)        # ability of players on team 0
  alpha_team1 <- matrix(NA, m, J)        # ability of players on team 1
  n <- 1
  for ( i in 1:p ) {
    for ( j in 1:p ) {
      if ( i != j ) {
        k = i + p * (y - 1)
        l = j + p * (y - 1)
        team0[n, 1:J] <- as.matrix(players[k,])
        team1[n, 1:J] <- as.matrix(players[l,])
        alpha_team0[n, 1:J] <- as.matrix(oscars.my[Year %in% years[y]][i, pvars.c, with=FALSE])
        alpha_team1[n, 1:J] <- as.matrix(oscars.my[Year %in% years[y]][j, pvars.c, with=FALSE])
        n <- n + 1
      }
    }
  }
  team0.my[y,,] <- team0
  team1.my[y,,] <- team1
  alpha_team0.my[y,,] <- alpha_team0
  alpha_team1.my[y,,] <- alpha_team1
}

y <- matrix(NA, Y, m)

for ( year in 1:Y ) {
  for (n in 1:m) {
    sum_alpha_team0 = sum(alpha_team0.my[year, n, 1:J])
    sum_alpha_team1 = sum(alpha_team1.my[year, n, 1:J])
    y[year, n] <- rbinom(1, 1, inv_logit(sum_alpha_team1 - sum_alpha_team0))
  }
}

########################################################################################################


team_data <- list(K = K, J = J, N = m, Y = Y, team0 = team0.my, team1 = team1.my, y = y)

# approx 4 min to sample
team_model <- stan_model("oscars-bradley-terry-teams-multiyear.stan")
system.time( team_posterior <- sampling(team_model, data = team_data, init=0.5) )

print(team_posterior, c("sigma", "alpha"), probs=c(0.05, 0.5, 0.95))


alpha_hat <- rep(NA, K)

for (k in 1:K)
  alpha_hat[k] <- mean(extract(team_posterior)$alpha[ , k])

team_bayes_fit_plot <-
  ggplot(data.frame(alpha = alpha, alpha_hat = alpha_hat),
         aes(x = alpha, y = alpha_hat)) +
      geom_abline(slope = 1, intercept = 0, color="green", size = 2) +
      geom_point(size = 2)
team_bayes_fit_plot
# R^2 correlation does not look great 
# but it's clearly a y = x line of best fit

