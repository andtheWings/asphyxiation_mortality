Welcome to the repository for my project on Sudden Unexpected Infant Death (SUID) in Cook County, IL, USA from 2015-2019.
I am currently writing a manuscript on the following aspects of this project:
- Use of an automated, analytical pipeline of SUID data drawn from the Cook County Medical Examiner's Office and the U.S. Census' American Community Survey
- Demographics of the SUID population
- Comparative characteristics of census tracts that have or have not experienced a case of SUID
- Mapping the incidence of SUID in census tracts
- Predictive modeling of the number of SUID cases in each census tract

Here is a walkthrough of the repo contents:
- 00-abstract.rmd is the Abstract
- 10-intro.rmd is the Introduction section
- 20-methods.rmd is the Methods section
- 30-results.rmd is the Results section
- 40-discussion is the Discussion section
- 5X-[text] are chunks to be incorporated into a Supplements section that outlines code used for the analysis
- 6X-[text] are deprecated code chunks that have not yet been incorporated in the data pipeline
- _targets.R contains the script for running the data pipeline
- cook_county_sids_mortality.Rproj contains configuration instructions for the Rstudio project
- sandbox.rmd is for experimenting with new code that has not yet been incorporated into the manuscript
- The "R" folder contains user-defined functions for the [Targets](https://docs.ropensci.org/targets/) data pipeline
- The "R_archive" folder contains deprecated functions
- The "tables_and_figures" folder contains the self-described media
