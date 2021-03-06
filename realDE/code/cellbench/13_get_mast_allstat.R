mtd = commandArgs(trailingOnly = T)[1]
suppressMessages(library(MAST))
dir.create(paste0('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/realDE/result/cellbench/diff/mast/', mtd,'/res_allstat/'), showWarnings = F, recursive = T)
imp = readRDS(paste0('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/result/procimpute/cellbench/',mtd,'/sc_10x_5cl.rds'))
raw = readRDS('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/data/processed/cellbench/sc_10x_5cl/genebycell.rds')
raw = raw[,colnames(imp)]
ct = sub('.*:','',colnames(raw))
allf = sub('_diffgene.rds','',list.files('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/realDE/result/cellbench/bulkdiff/'))
Res <- sapply(allf, function(f)){
  ct1 = sub('_.*','',f)
  ct2 = sub('.*_','',f)
  count = cbind(raw[,grepl(ct1, ct)], raw[,grepl(ct2, ct)])
  expr = cbind(imp[, grepl(ct1,ct)], imp[, grepl(ct2,ct)])
  g = intersect(rownames(expr), rownames(count)) ##
  expr = expr[g,] ##
  count = count[g,] ##
  cdr <- scale(colMeans(count > 0))
  cluster <- rep('clu1',ncol(expr)) ## length #cells
  cluster[(sum(grepl(ct1, ct))+1):ncol(expr)] <- 'clu2' ###
  sca <- FromMatrix(expr,data.frame(wellKey=colnames(expr),cluster=cluster,cngeneson=cdr), data.frame(primerid=row.names(expr),Gene=row.names(expr)))
  zlmCond <- zlm(~cluster+cngeneson, sca)
  summaryCond <- summary(zlmCond, doLRT="clusterclu2")
  summaryDt <- as.data.frame(summaryCond$datatable)
  pval <- summaryDt[summaryDt$component == "H" & summaryDt$contrast == "clusterclu2",c(1,4)]
  lfc <- summaryDt[summaryDt$component == "logFC" & summaryDt$contrast == "clusterclu2",c(1,7)]
  z <- summaryDt[summaryDt$component == "logFC" & summaryDt$contrast == "clusterclu2",c(1,8)]
  combine <- merge(merge(pval,lfc),z)
  colnames(combine) <- c("Gene","pvalue","Log-foldchange",'z')
  row.names(combine) <- combine[,1]
  res <- combine
  colnames(res)[colnames(res)=='Log-foldchange'] <- "stat"
  res <- res[order(res[,'pvalue'],-abs(res[,'stat'])),]
  saveRDS(res, paste0('/home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/realDE/result/cellbench/diff/mast/', mtd,'/res_allstat/',f,'.rds'))  
}
