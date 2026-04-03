# get the date difference for each row in the cross-joined data set
new_subset10 <- new_subset10 %>% 
  mutate(dif_date = abs(as.numeric(as.Date(date)-as.Date(Date))))

# get the smallest dif_date for each (group, date) combination
new_subset11 <- new_subset10 %>% 
  group_by(groups, date) %>% 
  slice_min(order_by = dif_date) 

# extract columns that will be used to join the data set with smallest dif_date back to the primary data set into a new data set 
new_t <- new_subset11 %>% 
  select(date, MemberCount, Date, dif_date, kmp.id, groups, St.Time) |> 
  unique()

# join the data set with smallest dif_date back to the primary data set by "kmp.id", "date", "St.Time", and "groups" and remove duplicates
# i.e. affixing the MemberCount with least dif_date for each row
new_subset13 <- merge(x = new_subset9, y = new_t, by=c("kmp.id", "date", "St.Time", "groups"), all.x = TRUE) |> unique()
new_subset14 <- new_subset13 %>% 
  distinct(kmp.id, date, St.Time, groups, observer, date_dif, .keep_all = TRUE)