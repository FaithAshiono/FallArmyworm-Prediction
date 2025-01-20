#load libraries
install.packages("terra")
library(terra)

#setup file paths
input_folder <- "C:\\Work\\MSC\\2_1\\Variables\\1.Raw"
clip_folder <- "C:\\Work\\MSC\\2_1\\Variables\\2.Clipped"
resampled_folder <- "C:\\Work\\MSC\\2_1\\Variables\\3.Resampled"
shapefile_path <- "C:\\Work\\MSC\\2_1\\Variables\\4.Cape coast\\CAPECOAST.shp" 

# Load the shapefile as the clipping extent
clip_extent <- vect(shapefile_path)
shapefile_crs<- crs(clip_extent)
# Step 1: Load, Clip, and Save
# List all .tif files in the input folder
tif_files <- list.files(input_folder, pattern = "\\.tif$", full.names = TRUE)

# Loop through each .tif file
for (file in tif_files) {
  # Load the raster
  raster <- rast(file)
  
  #reproject rasters to shapefile crs
  reprojected_raster <- project(raster, shapefile_crs)
  
  # Clip the  raster using the shapefile extent
  clipped <- crop(reprojected_raster, clip_extent)
  clipped1 <- mask(clipped, clip_extent) # Ensure the shape masks the raster
  
  # Save the clipped raster
  clip_output_name <- gsub("\\.tif$", "_clip.tif", basename(file)) 
  clip_output_path <- file.path(clip_folder, clip_output_name)
  writeRaster(clipped1, clip_output_path, overwrite = TRUE)
}



clip_folder <- "C:\\Work\\MSC\\2_1\\Variables\\2.Clipped"
resampled_10_folder <- "C:\\Work\\MSC\\2_1\\Variables\\3.Resampled"
sentinel<-rast("C:\\Work\\MSC\\2_1\\Variables\\4.Cape coast\\capecoast_sentinel.tif")
#whe using terra package ensure to load all rasters usig the terra package
#e.g rast(file) is for terra
#while raster(file) is forloadig as raster layer

clippedfiles <- list.files(clip_folder, pattern = "\\.tif$", full.names = TRUE)

# Loop through each .tif file
for (file in clippedfiles) {
  # Load the raster
  raster <- rast(file)
  
  # Resample the raster to match the reference raster
  resampled_raster <- resample(raster, sentinel)#, method = "bilinear")  # Use bilinear for continuous data
  
  #specify output path
  output_name <- gsub("\\.tif$", "_re.tif", basename(file)) 
  res_output_path <- file.path(resampled_10_folder, output_name)
  
  # Save the resampled raster
  writeRaster(resampled_raster, res_output_path, overwrite = TRUE)
  
  # Print progress
  cat("Resampled and saved:", output_file, "\n")
}

cat("All rasters have been resampled to 10m and saved in the 'resampled' folder.\n")



