# sn_CETpairedstats
library(lsr)
library(readxl)

DATA_FILE <- #enter here#

## LOAD DATA
statstDCSCET = read_excel(DATA_FILE)
statstDCSCET = as.data.frame(statstDCSCET)
statstDCSCET$Time <- factor(statstDCSCET$Time,levels=c("Post","Baseline"),labels=c("Post","Baseline"))

## PAIRED T-TESTS
t.test(MOOD ~ Time,
       data   = statstDCSCET,
       paired = TRUE)
cohensD(statstDCSCET$MOOD ~ statstDCSCET$Time, method = "paired")

t.test(DPRIME ~ Time,
       data   = statstDCSCET,
       paired = TRUE)
cohensD(statstDCSCET$DPRIME ~ statstDCSCET$Time, method = "paired")

t.test(RT ~ Time,
       data   = statstDCSCET,
       paired = TRUE)
cohensD(statstDCSCET$RT ~ statstDCSCET$Time, method = "paired")

t.test(FAAPSD ~ Time,
       data   = statstDCSCET,
       paired = TRUE)
cohensD(statstDCSCET$FAAPSD ~ statstDCSCET$Time, method = "paired")

t.test(ThetaPSD ~ Time,
         data   = statstDCSCET,
         paired = TRUE)
  cohensD(statstDCSCET$ThetaPSD ~ statstDCSCET$Time, method = "paired")

t.test(P2 ~ Time,
       data   = statstDCSCET,
       paired = TRUE)
cohensD(statstDCSCET$P2 ~ statstDCSCET$Time, method = "paired")

t.test(P3 ~ Time,
       data   = statstDCSCET,
       paired = TRUE)
cohensD(statstDCSCET$P3 ~ statstDCSCET$Time, method = "paired")

t.test(AlphaERD ~ Time,
       data   = statstDCSCET,
       paired = TRUE)
cohensD(statstDCSCET$AlphaERD ~ statstDCSCET$Time, method = "paired")

t.test(ThetaERS ~ Time,
       data   = statstDCSCET,
       paired = TRUE)
cohensD(statstDCSCET$ThetaERS ~ statstDCSCET$Time, method = "paired")

## NONPARAMETRIC T-TEST - Wilcox signed rank tests
# Used to check if there is any substantive diff in parametric/nonparametric testing (nil)
wilcox.test(MOOD ~ Time,
       data   = statstDCSCET,
       paired = TRUE)

wilcox.test(DPRIME ~ Time,
       data   = statstDCSCET,
       paired = TRUE)

wilcox.test(RT ~ Time,
       data   = statstDCSCET,
       paired = TRUE)

wilcox.test(FAAPSD ~ Time,
       data   = statstDCSCET,
       paired = TRUE)

wilcox.test(ThetaPSD ~ Time,
       data   = statstDCSCET,
       paired = TRUE)

wilcox.test(P2 ~ Time,
       data   = statstDCSCET,
       paired = TRUE)

wilcox.test(P3 ~ Time,
       data   = statstDCSCET,
       paired = TRUE)

wilcox.test(AlphaERD ~ Time,
            data   = statstDCSCET,
            paired = TRUE)

wilcox.test(ThetaERS ~ Time,
            data   = statstDCSCET,
            paired = TRUE)
