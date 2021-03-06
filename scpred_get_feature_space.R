#!/usr/bin/env Rscript 

suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(require(workflowscriptscommon))
suppressPackageStartupMessages(require(scPred))
suppressPackageStartupMessages(require(Seurat))

# Select principal components that will be used as features for training the model
option_list = list(
    make_option(
        c("-i", "--input-object"), 
        action = "store",
        default = NA,
        type = 'character',
        help = 'Path to the input object of Seurat class in .rds format'
  ),
    make_option(
        c("-p", "--prediction-column"), 
        action = "store",
        default = "cell_type",
        type = 'character',
        help = 'Name of the metadata column that contains cell labels'
  ),
     make_option(
        c("-c", "--correction-method"), 
        action = "store",
        default = 'fdr',
        type = 'character',
        help = 'Multiple testing correction method. Default: fdr'
  ),
     make_option(
        c("-s", "--significance-threshold"), 
        action = "store",
        default = 1,
        type = 'numeric',
        help = 'Significance threshold for principal components explaining class identity'
  ),
     make_option(
        c("-r", "--reduction-parameter"), 
        action = "store",
        default = "pca",
        type = 'character',
        help = 'Name of reduction in Seurat objet to be used to determine the feature space. Default: "pca"'
  ),
      make_option(
        c("-o", "--output-path"), 
        action = "store",
        default = NA,
        type = 'character',
        help = 'Path for the modified scPred object in .rds format'
  ) 
)

opt = wsc_parse_args(option_list, mandatory = c("input_object",
                                                "prediction_column",
                                                "output_path"))
data_seurat = readRDS(opt$input_object)
data_seurat = getFeatureSpace(data_seurat, 
                      pvar = opt$prediction_column, 
                      correction = opt$correction_method, 
                      sig = opt$significance_threshold,
                      reduction = opt$reduction)

saveRDS(data_seurat, opt$output_path)
