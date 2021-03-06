allf = sub('.csv', '',list.files('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/result/impute/cellbench/pblr'))
getf = sub('.rds','',list.files('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/simu/result/procimpute/pblr'))
runf <- setdiff(allf,getf)
res <- lapply(runf, function(f){
  #if (!f%in%getf){
    sexpr <- read.csv(paste0('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/result/impute/cellbench/pblr/',f,'.csv'),as.is=T, header=F)
    sexpr = as.matrix(sexpr)
    sexpr = log2(sexpr + 1)
    d <- readRDS(paste0('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/data/processed/cellbench/',f, '/genebycell.rds'))
    row.names(sexpr) <- row.names(d)
    colnames(sexpr) <- colnames(d)
    saveRDS(sexpr,file=paste0('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/result/procimpute/cellbench/pblr/',f,'.rds'))    
  #}
})

