install.packages("easypackages")
library(easypackages)
libraries("lidR", "here", "gstat", "terra", "tools")

# get las
lasPath <- here("data\\raw_data\\LAS")
lasPath

#Define folder containing las files and output folder
lasPath <- here("data\\raw_data\\LAS")
outPath <- here("outputs\\DTM")

## Kriging Interpolation
dfm_krig_ctg <- function(lasPath, outPath, r=0.25, neighbors=20, chunk_size=250, buffer_size=25){
  # This function uses lidR catalog methods to convert a .las or .laz file into a digital feature model for archaeological prospection.
  # It uses a Kriging interpolation.
  # This includes ASPRS class 2 (ground), 6 (building), 9 (water), and 19 (likely archaeological features)
  # It has two required arguments, lasPath and outPath. The first is the file path to the folder containing desired .las/.laz files.
  # The second is the folder that will receive outputs. 
  # There are three optional arguments. r is the resolution in meters. It defaults to 0.25m resolution.
  # neighbors is the k-means neighbor value used in kriging interpolation. It defaults to 20.
  # chunk_size sets the cell size for loading point-cloud data. Measured in meters. Defaults to 250m x 250m. 
  # 
  # Usage:
  # >>dfm_krig_ctg(lasPath, outPath)
  # >>dfm_krig_ctg(lasPath, outPath, r = 0.5, neighbors = 16, chunk_size = 1000)
  
  #create list of files in lasPath
  lasFiles <- list.files(path = lasPath, full.names=TRUE)
  for (lasFile in lasFiles){
    #check if file is a .las or .laz file
    if(file_ext(lasFile) == "las" || file_ext(lasFile) == "laz"){
      #get original file name++---
      filenamePath <- basename(lasFile)
      file_name <- file_path_sans_ext(filenamePath)
      #creates LAS catalog with attributes
      ctg <- readLAScatalog(lasFile)
      opt_chunk_size(ctg) <- chunk_size
      opt_chunk_buffer(ctg) <- buffer_size
      opt_merge(ctg) <- TRUE
      summary(ctg)
      plot(ctg, chunk=TRUE)
      #performs Kriging interpolation digital feature model (ground, buildings, water, archaeological features)
      #input parameters for resolution and neighborhood window customizable in initial inputs
      print(paste0("Processing ", filenamePath))
      dfm_krig <- rasterize_terrain(ctg, res = r, algorithm = kriging(k = neighbors), use_class = c(2L, 6L, 9L, 10L, 19L))
      writeRaster(dfm_krig, filename = paste0(outPath, "/", file_name, "_OrdKrig_DFM_025m.tif"), filetype = "GTiff")
      print(paste0(file_name, " DFM created."))
    }
    else{
      print(paste0(filenamePath, " is not a .las or .laz file. Cannot perform kriging DFM interpolation."))
    }
  }
}

dfm_krig_ctg(lasPath, outPath, neighbor=40) # generate DFMs

## IDW Interpolation
dfm_idw_ctg <- function(lasPath, outPath, r = 0.25, chunk_size = 250, buffer_size = 25, k = 10, p = 2, rmax = 50){
  
  # This function uses lidR catalog methods to convert a .las or .laz file into a digital feature model for archaeological prospection.
  # This includes ASPRS class 2 (ground), 6 (building), 9 (water), and 19 (likely archaeological features)
  # It has two required arguments, lasPath and outPath. The first is the file path to the folder containing desired .las/.laz files.
  # The second is the folder that will receive outputs. 
  # There are three optional arguments. r is the resolution in meters. It defaults to 0.25m resolution.
  # neighbors is the k-means neighbor value used in kriging interpolation. It defaults to 10.
  # chunk_size sets the cell size for loading point-cloud data. Measured in meters. Defaults to 250m x 250m. 
  # 
  # Usage:
  # >>dfm_idw_ctg(lasPath, outPath)
  # >>dfm_idw_ctg(lasPath, outPath, r = 0.5, chunk_size = 1000, k = 8, p=3, rmax=60)
  
  #create list of files in lasPath
  lasFiles <- list.files(path = lasPath, full.names=TRUE)
  for (lasFile in lasFiles){
    #check if file is a .las or .laz file
    if(file_ext(lasFile) == "las" || file_ext(lasFile) == "laz"){
      #get original file name
      filenamePath <- basename(lasFile)
      file_name <- file_path_sans_ext(filenamePath)
      #creates LAS catalog with attributes
      ctg <- readLAScatalog(lasFile)
      opt_chunk_size(ctg) <- chunk_size
      opt_chunk_buffer(ctg) <- buffer_size
      opt_merge(ctg) <- TRUE
      summary(ctg)
      plot(ctg, chunk=TRUE)
      #performs IDW interpolation digital feature model (ground, buildings, water, archaeological features)
      #input parameters for resolution and neighborhood window customizable in initial inputs
      print(paste0("Processing ", filenamePath))
      dfm_idw <- rasterize_terrain(ctg, res = r, algorithm = knnidw(k=k, p=p,rmax=rmax), use_class = c(2L, 6L, 9L, 19L))
      writeRaster(dfm_idw, filename = paste0(outPath, "/", file_name, "_IDW_DFM.tif"), filetype = "GTiff")
      print(paste0(file_name, " DFM created."))
    }
    else{
      print(paste0(filenamePath, " is not a .las or .laz file. Cannot perform IDW DFM interpolation."))
    }
  }
}
dfm_idw_ctg(lasPath)

## TIN Interpolation

dfm_tin_ctg <- function(lasPath, outPath, r = 0.25, chunk_size = 250, buffer_size = 25){
  
  # This function uses lidR catalog methods to convert a .las or .laz file into a digital feature model for archaeological prospection.
  # It uses a TIN interpolation formula.
  # This includes ASPRS class 2 (ground), 6 (building), 9 (water), and 19 (likely archaeological features)
  # It has two required arguments, lasPath and outPath. The first is the file path to the folder containing desired .las/.laz files.
  # The second is the folder that will receive outputs. 
  # There are three optional arguments. r is the resolution in meters. It defaults to 0.25m resolution.
  # neighbors is the k-means neighbor value used in kriging interpolation. It defaults to 10.
  # chunk_size sets the cell size for loading point-cloud data. Measured in meters. Defaults to 250m x 250m. 
  # 
  # Usage:
  # >>dfm_tin_ctg(lasPath, outPath)
  # >>dfm_tin_ctg(lasPath, outPath, r = 0.5, chunk_size = 1000)
  
  #create list of files in lasPath
  lasFiles <- list.files(path = lasPath, full.names=TRUE)
  for (lasFile in lasFiles){
    #check if file is a .las or .laz file
    if(file_ext(lasFile) == "las" || file_ext(lasFile) == "laz"){
      #get original file name
      filenamePath <- basename(lasFile)
      file_name <- file_path_sans_ext(filenamePath)
      #creates LAS catalog with attributes
      ctg <- readLAScatalog(lasFile)
      opt_chunk_size(ctg) <- chunk_size
      opt_chunk_buffer(ctg) <- buffer_size
      opt_merge(ctg) <- TRUE
      summary(ctg)
      plot(ctg, chunk=TRUE)
      #performs TIN interpolation digital feature model (ground, buildings, water, archaeological features)
      #input parameters for resolution and neighborhood window customizable in initial inputs
      print(paste0("Processing ", filenamePath))
      dfm_tin <- rasterize_terrain(ctg, res = r, algorithm = tin(), use_class = c(2L, 6L, 9L, 19L))
      writeRaster(dfm_krig, filename = paste0(outPath, "/", file_name, "_TIN_DFM.tif"), filetype = "GTiff")
      print(paste0(file_name, " DFM created."))
    }
    else{
      print(paste0(filenamePath, " is not a .las or .laz file. Cannot perform TIN DFM interpolation."))
    }
  }
}
dfm_tin_ctg(lasPath)