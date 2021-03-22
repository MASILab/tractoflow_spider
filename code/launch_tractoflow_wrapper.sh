#!/bin/bash

# Prepare input for Tractoflow
IN_DIR=${1}
OUT_DIR=${2}
N_SUBJ=${3}
N_SESS=${4}
IN_T1=${5}
IN_DWI=${6}
IN_BVAL=${7}
IN_BVEC=${8}

mkdir raw/${N_SUBJ}_${N_SESS} -p
cp ${IN_DIR}/${IN_T1} ${IN_DIR}/${IN_DWI} ${IN_DIR}/${IN_BVAL} ${IN_DIR}/${IN_BVEC} raw/${N_SUBJ}_${N_SESS}/

# Relevant parameters for Tractoflow
SH_ORDER=${9}
DTI_SHELLS=${10}
FODF_SHELLS=${11}
RUN_PFT=${12}
PFT_SEED=${13}
PFT_MASK_TYPE=${14}
RUN_LOCAL=${15}
LOCAL_SEED=${16}
LOCAL_MASK_TYPE=${17}
ALGO=${18}

/nextflow /tractoflow/main.nf \
	--input raw/ --dti_shells "${DTI_SHELLS}" --fodf_shells "${FODF_SHELLS}" --run_dwi_denoising false --run_topup false \
	--run_eddy false --use_slice_drop_correction false --mean_frf false --sh_order ${SH_ORDER} --run_pft_tracking ${RUN_PFT} \
	--pft_algo ${ALGO} --pft_seeding_mask_type ${PFT_MASK_TYPE} \
	--pft_seeding_mask_type interface --pft_nbr_seeds ${PFT_SEED} --run_local_tracking ${RUN_LOCAL} --local_algo ${ALGO} \
	--local_tracking_mask_type ${LOCAL_MASK_TYPE} --local_nbr_seeds ${LOCAL_SEED} --processes_denoise_dwi 1 --processes_denoise_t1 1 \
	--processes_eddy 1 --processes_fodf 1 --processes 1 --processes_brain_extraction_t1 1 --processes_registration 1 \
	-resume -with-report report.html

xvfb-run -a --server-num=$((65536+$$)) --server-args="-screen 0 1600x1280x24 -ac" \
	scil_visualize_bundles_mosaic.py results/*/DTI_Metrics/*__fa.nii.gz \
	results/*/PFT_Tracking/*.trk pft.png --resolution_of_thumbnails 600 --opacity_background 0.5 -f --zoom 1.5
xvfb-run -a --server-num=$((65536+$$)) --server-args="-screen 0 1600x1280x24 -ac" \
	scil_visualize_bundles_mosaic.py results/*/DTI_Metrics/*__fa.nii.gz \
	results/*/Local_Tracking/*.trk local.png --resolution_of_thumbnails 600 --opacity_background 0.5 -f --zoom 1.5
convert pft.png -crop 600x3600+600+0 pft.png
convert local.png -crop 600x3600+600+0 local.png

xvfb-run -a --server-num=$((65536+$$)) --server-args="-screen 0 1600x1280x24 -ac" \
	scil_visualize_fodf.py results/*/FODF_Metrics/*__fodf.nii.gz --axis_name axial --output axial.png --silent \
	--background results/*/DTI_Metrics/*__fa.nii.gz --win_dims 2560 2560
xvfb-run -a --server-num=$((65536+$$)) --server-args="-screen 0 1600x1280x24 -ac" \
	scil_visualize_fodf.py results/*/FODF_Metrics/*__fodf.nii.gz --axis_name coronal --output coronal.png --silent \
	--background results/*/DTI_Metrics/*__fa.nii.gz --win_dims 2560 2560

python3.7 /CODE/generate_tractoflow_spider_pdf.py ${N_SUBJ}_${N_SESS} 

cp report.pdf report.html results/*/readme.txt ${OUT_DIR}/
cp -L results/*/*/*__b0_resampled.nii.gz results/*/*/*__b0_mask_resampled.nii.gz results/*/*/*__dwi_resampled.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__output0GenericAffine.mat results/*/*/*__output1InverseWarp.nii.gz results/*/*/*__output1Warp.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__t1_mask_warped.nii.gz results/*/*/*__t1_warped.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__map_csf.nii.gz results/*/*/*__map_gm.nii.gz results/*/*/*__map_wm.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__mask_csf.nii.gz results/*/*/*__mask_gm.nii.gz results/*/*/*__mask_wm.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__local_seeding_mask.nii.gz results/*/*/*__local_tracking_mask.nii.gz results/*/*/*__pft_seeding_mask.nii.gz  ${OUT_DIR}/
cp -L results/*/*/*__map_exclude.nii.gz results/*/*/*__map_include.nii.gz results/*/*/*__interface.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__ad.nii.gz results/*/*/*__rd.nii.gz results/*/*/*__fa.nii.gz results/*/*/*__rgb.nii.gz results/*/*/*__md.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__tensor.nii.gz results/*/*/*__evecs_v1.nii.gz results/*/*/*__evals_e1.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__afd_max.nii.gz results/*/*/*__afd_sum.nii.gz results/*/*/*__afd_total.nii.gz results/*/*/*__nufo.nii.gz ${OUT_DIR}/
cp -L results/*/*/*__peaks.nii.gz results/*/*/*__fodf.nii.gz ${OUT_DIR}/
cp -L results/*/Local_Tracking/*.trk results/*/PFT_Tracking/*.trk ${OUT_DIR}/