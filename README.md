
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


### Inputs
- dwmri.nii.gz (from dtiQA – PREPROCESSED)
- dwmri.bval (from dtiQA – PREPROCESSED)
- dwmri.bvec (from dtiQA – PREPROCESSED)
- t1.nii.gz (from DICOM conversion)

### Parameters
- sh_order: 8
- dti_shells: "0 1000"
- fodf_shells: "0 1000"
- pft_seed: 10
- pft_mask_type: wm
- local_seed: 10
- local_mask_type: wm
- algo: prob

### Outputs
**Reporting**
- readme.txt
- report.html
- report.pdf

**DWI**
- dwi.bval
- dwi.bvec
- dwi_resampled.nii.gz
- b0_mask_resampled.nii.gz
- b0_resampled.nii.gz

**DTI_mtrics**
- fa.nii.gz
- md.nii.gz
- rd.nii.gz
- ad.nii.gz
- rgb.nii.gz
- tensor.nii.gz
- evals_e1.nii.gz
- evecs_v1.nii.gz

**FODF_metrics**
- fodf.nii.gz
- peaks.nii.gz
- nufo.nii.gz
- afd_max.nii.gz
- afd_sum.nii.gz
- afd_total.nii.gz

**Register T1w**
- t1_mask_warped.nii.gz
- t1_warped.nii.gz
- output0GenericAffine.mat
- output1InverseWarp.nii.gz
- output1Warp.nii.gz

**Tissue segmentation**
- mask_csf.nii.gz
- mask_gm.nii.gz
- mask_wm.nii.gz
- map_csf.nii.gz
- map_gm.nii.gz
- map_wm.nii.gz

**Tractography masks**
- map_exclude.nii.gz
- map_include.nii.gz
- interface.nii.gz
- local_seeding_mask.nii.gz
- local_tracking_mask.nii.gz
- pft_seeding_mask.nii.gz

**Tracking**
- local.trk
- pft.trk

### Input assumptions and parameters choice

 1. The diffusion has been preprocessed using the dtiQA_v7 pipeline.
 2. The parameters *dti_shells* and *fodf_shells* must be chosen according to each project's sequence. It can be single-shell or multi-shell. 
 3. The acquisition is adequate for tensor reconstruction, 800 < BVAL < 1200, with at least 12 directions.
 4. The acquistion is adequate for fODF reconstruction, 800 < BVAL < 3000, with at least 32 directions.
 5. The parameters *sh_order* (default: 8) is the order of spherical harmonics used for fODF. If your fodf_shells has less than 45 directions, used 6.
 6. *pft_mask_type* and *local_mask_type* (default: wm) defines the initialization "tissue" for tractography. If there is a chance for lesions and tissue segmentation is likely to fail, we recommand switching to fa.
 7. *pft_seed* and *local_seed* (default: 10) define the number of streamlines to initialize per voxel of white matter (or fa).
 8. If tracking is not desired or will be performed outside of the spider, use the smallest values possible (1). 
 9. The *algo* parameter is the choice of tractography algorithm (probabilistic). It is recommanded for most situation, if you want deterministic tractography switch to det.
