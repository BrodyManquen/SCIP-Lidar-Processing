This repo contains the following scripts used for the Small Cycladic Islands Project (SCIP) 2023 and 2024 lidar analysis:

- dfm_ctg.R: interpolation of Digital Feature Models using lidR package in RStudio.
- FeatureAccuracyTable.R: analysis of feature classification accuracy & table creation in RStudio.
- ManquenEtAl_RVTfunctions.ipynb: JupyterNotebook workspace that creates custom visualization creation functions using the Relief Visualization Toolbox.
- ManquenEtAl_RVTworkspace.ipynb: JupyterNotebook workspace that implements the visualization creation functions.

The FeatureAccuracyTable.R requires an .csv input exported from the GIS feature vector. The .csv has the following format, in order:
- OID_: feature object ID (numeric)
- UUID: unique feature identifier (UUID code)
- IslandCode: unique island identifier of survey islet (string)
- SUs: survey unit(s) in which the featuure is located (string)
- 500mGrid: 500m grid unit of feature (string)
- Lidar_Date: timestamp of lidar feature analysis (time)
- Lidar_Anal: initials of lidar analyst conducting feature survey (string)
- Lidar_Note: notes descripting the appearance of a feature in the lidar, justifying classification (string)
- Pos_Neg: whether the feature is Positive or Negative (string)
- Type: feature class type (string)
- Function: feature function (string)
- Gen_Chrono: general chronological period of the feature (string)
- Documentat: Description of documentation process with four options (Lidar only, Lidar > Ground, Ground > Lidar, Ground only) (string).
- GrndTrth_D: Timestamp of ground-truthing (time)
- GrndTrth_T: Initials of members of the ground-truthing team (string)
- GrndTrth_N: Notes from ground-truthing team (string)
- Success_Er: Accuracy classification (True Positive, False Positive, False Negative)
