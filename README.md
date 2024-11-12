This repo contains the following scripts used for the Small Cycladic Islands Project (SCIP) 2023 and 2024 lidar analysis:

- <b>dfm_ctg.R</b>: interpolation of Digital Feature Models using lidR package in RStudio.
- <b>FeatureAccuracyTable.R</b>: analysis of feature classification accuracy & table creation in RStudio.
- <b>ManquenEtAl_RVTfunctions.ipynb</b>: JupyterNotebook workspace that creates custom visualization creation functions using the Relief Visualization Toolbox.
- <b>ManquenEtAl_RVTworkspace.ipynb</b>: JupyterNotebook workspace that implements the visualization creation functions.

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

<b>Data Availability Statement</b>

Research involving LAS data, derivative products, and vectors generated for this article is ongoing as part of the Small Cycladic Islands Project and a US National Science Foundation Senior Archaeological Research Grant (Award ID 2150873). The use of these data is regulated by the Principal Investigator, Alex Knodell (Carleton College), and the Ephorate of Antiquities of the Cyclades of the Hellenic Ministry of Culture. Eventually, these datasets will be made accessible to other researchers in a digital repository.  Researchers with particular interests in these datasets may write to the corresponding author (manquen@utexas.edu) and to Alex Knodell (aknodell@carleton.edu), in order to inquire about access and permissions.  Additionally, you may follow the Small Cycladic Islands Project (https://smallcycladicislandsproject.org/) for future publications and data releases.
