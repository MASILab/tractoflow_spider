# tractoflow_spider
Tractoflow Spider from XNAT

TractoFlow [1] pipeline is developed by the Sherbrooke Connectivity Imaging Lab (SCIL) in order to process
diffusion MRI dataset from the raw data to the tractography. The pipeline is based on Nextflow [2].
This pipeline is optimized for healthy human adults.

TractoFlow pipeline consist of 23 different steps : 14 steps for the diffusion weighted image (DWI) processing and 8
steps for the T1 weighted image processing.
See https://tractoflow-documentation.readthedocs.io/en/latest/index.html and [1] for more details.

[1] Theaud, G., Houde, J.-C., Boré, A., Rheault, F., Morency, F., Descoteaux, M.,
    "TractoFlow: A robust, efficient and reproducible diffusion MRI pipeline leveraging Nextflow & Singularity",
    NeuroImage (2020).
[2] Paolo Di Tommaso, et al. "Nextflow enables reproducible computational workflows.", Nature Biotechnology 35, 316-319
    (2017)
[3] Garyfallidis, E., Brett, M., Amirbekian, B., Rokem, A., Van Der Walt, S., Descoteaux, M., Nimmo-Smith, I.,
    "Dipy, a library for the analysis of diffusion mri data.", Frontiers in neuroinformatics (2014) 8, 8.
[4] Tournier, J. D., Smith, R. E., Raffelt, D. A., Tabbara, R., Dhollander, T., Pietsch, M., & Connelly, A.,
    "MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation.",
    Neuroimage (2020).
[5] Avants, B.B., Tustison, N., Song, G., "Advanced normalization tools (ants)." Insight J (2009) 2, 1-35.
[6] Jenkinson, M., Beckmann, C.F., Behrens, T.E., Woolrich, M.W., Smith, S.M., "Fsl." Neuroimage 62 (2012), 782-790.