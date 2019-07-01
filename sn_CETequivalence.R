# sn_CETequivalence
library(readxl)

DATA_FILE <- #enter here#
  
## LOAD DATA
tDCSCET = read_excel(DATA_FILE)
tDCSCET = as.data.frame(tDCSCET)

SESOI <- 0.3

## EQUIVALENCE TESTING
# PSD measures
TOSTpaired(n=20, m1=mean(tDCSCET$FAAPSD_pre), m2=mean(tDCSCET$FAAPSD_pst), 
           sd1=sd(tDCSCET$FAAPSD_pre), sd2=sd(tDCSCET$FAAPSD_pst), 
           r12=cor(tDCSCET$FAAPSD_pre,tDCSCET$FAAPSD_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)

TOSTpaired(n=20, m1=mean(tDCSCET$ThetaPSD_pre), m2=mean(tDCSCET$ThetaPSD_pst), 
           sd1=sd(tDCSCET$ThetaPSD_pre), sd2=sd(tDCSCET$ThetaPSD_pst), 
           r12=cor(tDCSCET$ThetaPSD_pre,tDCSCET$ThetaPSD_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)

# ERP measures
TOSTpaired(n=20, m1=mean(tDCSCET$P2_pre), m2=mean(tDCSCET$P2_pst), 
           sd1=sd(tDCSCET$P2_pre), sd2=sd(tDCSCET$P2_pst), 
           r12=cor(tDCSCET$P2_pre,tDCSCET$P2_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)

TOSTpaired(n=20, m1=mean(tDCSCET$P3_pre), m2=mean(tDCSCET$P3_pst), 
           sd1=sd(tDCSCET$P3_pre), sd2=sd(tDCSCET$P3_pst), 
           r12=cor(tDCSCET$P3_pre,tDCSCET$P3_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)

# TFR measures
TOSTpaired(n=20, m1=mean(tDCSCET$AlphaERD_pre), m2=mean(tDCSCET$AlphaERD_pst), 
           sd1=sd(tDCSCET$AlphaERD_pre), sd2=sd(tDCSCET$AlphaERD_pst), 
           r12=cor(tDCSCET$AlphaERD_pre,tDCSCET$AlphaERD_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)

TOSTpaired(n=20, m1=mean(tDCSCET$ThetaERS_pre), m2=mean(tDCSCET$ThetaERS_pst), 
           sd1=sd(tDCSCET$ThetaERS_pre), sd2=sd(tDCSCET$ThetaERS_pst), 
           r12=cor(tDCSCET$ThetaERS_pre,tDCSCET$ThetaERS_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)

# MADRS
TOSTpaired(n=20, m1=mean(tDCSCET$MADRS_pre), m2=mean(tDCSCET$MADRS_pst), 
           sd1=sd(tDCSCET$MADRS_pre), sd2=sd(tDCSCET$MADRS_pst), 
           r12=cor(tDCSCET$MADRS_pre,tDCSCET$MADRS_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)

# WORKING MEMORY: d-prime
TOSTpaired(n=20, m1=mean(tDCSCET$dprime_pre), m2=mean(tDCSCET$dprime_pst), 
           sd1=sd(tDCSCET$dprime_pre), sd2=sd(tDCSCET$dprime_pst), 
           r12=cor(tDCSCET$dprime_pre,tDCSCET$dprime_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)

# WORKING MEMORY: response time
TOSTpaired(n=20, m1=mean(tDCSCET$rt_pre), m2=mean(tDCSCET$rt_pst), 
           sd1=sd(tDCSCET$rt_pre), sd2=sd(tDCSCET$rt_pst), 
           r12=cor(tDCSCET$rt_pre,tDCSCET$rt_pst,method="pearson"),
           low_eqbound_dz=-SESOI, high_eqbound_dz=SESOI, 
           alpha=0.05,
           plot = TRUE, verbose = TRUE)
