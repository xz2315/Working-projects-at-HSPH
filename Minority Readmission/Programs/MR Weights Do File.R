######################################################################
# MINORITY READMISSIONS - DO FILE FOR CREATING WEIGHTS FOR FREQUENCY #
######################################################################

# LOAD DATA FRAME
# Note that response variable is current as of 7-25-14.
h = read.csv("denominator file.csv")
names(h)
head(h)

# SAMPLING WEIGHT
h$sample.weight = 0
# We surveyed 899 of 900 MSH hospitals
h$sample.weight[h$Designation=="MSH"] = 1.001112 
# 2197 non-MSH hospitals
h$sample.weight[h$Designation=="Non-MSH Q1"] = 439/200
h$sample.weight[h$Designation=="Non-MSH Q2-4"] = 1319/201
h$sample.weight[h$Designation=="Non-MSH Q5"] = 439/200
h$sample.weight[h$Designation=="Q1"] = 439/200
h$sample.weight[h$Designation=="Q2-4"] = 1319/201
h$sample.weight[h$Designation=="Q5"] = 439/200
# check sampling weights worked
table(h$sample.weight)

# NON-RESPONSE WEIGHT
# Attach data frame because to ease variable typage
attach(h)
ps.model = glm(response ~ Urban + profit2 + teaching + hospsize + hosp.reg4 + cicu + mhsmemb, family = "binomial")
# Create propensity scores for each Hospital based off logistic non-response model
h$propensity.score = ps.model$fitted.values
# Inverse ps to get non-response weight
h$nr.weight = 1/h$propensity.score

# FINAL WEIGHT
h$weight = h$nr.weight * h$sample.weight
# Check that it worked 
head(h$weight)

# The code for creating frequency tables on weights looks like:
prop.table(xtabs(h$weight~Q1.1))
# Note you need to move the weights over to the survey response file
# I think this is actually easiestdone with the excel command vlookup
