library(tidyverse)
library(googlesheets4)
library(janitor)
library(arrow)

gs4_deauth()

raw_data <-
  read_sheet("1VxJlKvspazb8LPyuCvd8PqBZ8jS23rgA8LeCG9_02Fk",
             sheet = 2,
             .name_repair = make_clean_names)

clean_data <- 
  raw_data |>
  remove_empty(which = "rows") |>
  remove_empty(which = "cols") |>
  select(-timestamp, -comments) |>
  mutate(trials = str_split(nct_id, pattern = "[,&;]|( and )")) |>
  unnest(trials) |>
  mutate(trials = str_trim(trials)) |>
  select(-nct_id) |>
  rename(nct_id = trials)


clean_data |>
  write_feather("data/targets.feather")