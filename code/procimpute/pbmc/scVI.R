library(data.table)
allf <- sub('.csv','',list.files('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/result/impute/pbmc/scVI'))
res <- lapply(allf,function(f) {
  print(f)
d <- readRDS(paste0('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/data/processed/pbmc/',f,'/genebycell.rds'))  
sexpr <- t(as.matrix(fread(paste0('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/result/impute/pbmc/scVI/',f,'.csv'),data.table = F))) 
  sexpr <- log2(sexpr + 1)
  row.names(sexpr) <- row.names(d)
  colnames(sexpr) <- colnames(d)
  saveRDS(sexpr,file=paste0("/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/result/procimpute/pbmc/scVI/",f,'.rds'))
})

