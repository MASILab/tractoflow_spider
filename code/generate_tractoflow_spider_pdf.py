#!/usr/bin/env python

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys

from rheault_research.utils import pdf as pdf_creator

html_info = pdf_creator.parse_report('report.html')
METHODS = """TractoFlow [1] pipeline is developed by the Sherbrooke Connectivity Imaging Lab (SCIL) in order to process
diffusion MRI dataset from the raw data to the tractography. The pipeline is based on Nextflow [2].

This pipeline is optimized for healthy human adults.

TractoFlow pipeline consist of 23 different steps : 14 steps for the diffusion weighted image (DWI) processing and 8
steps for the T1 weighted image processing.
See https://tractoflow-documentation.readthedocs.io/en/latest/index.html and [1] for more details.
"""

REFERENCES = """[1] Theaud, G., Houde, J.-C., Boré, A., Rheault, F., Morency, F., Descoteaux, M.,
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
"""

pdf = pdf_creator.PDF(orientation='P', unit='mm', format='A4')
pdf.add_page()
pdf.titles('Tractoflow_V1: {}'.format(sys.argv[1]))
pdf.add_cell_left('Status:', html_info[0], size_y=5)
pdf.add_cell_left('Started on:', html_info[1], size_y=5)
pdf.add_cell_left('Completed on:', html_info[2], size_y=5)
pdf.add_cell_left('Command:', html_info[3], size_y=5)
pdf.add_cell_left('Duration:', html_info[4], size_y=5)

pdf.add_cell_left('Methods:', METHODS, size_y=5)
pdf.add_cell_left('References:', REFERENCES, size_y=5)

pdf.add_page()
pdf.titles('Tractoflow_V1: {}'.format(sys.argv[1]))
pdf.add_mosaic('Whole Brain Tractography',
               ['Local Tracking', 'PFT Tracking'],
               ['local.png', 'pft.png'],
               size_x=40, size_y=220, row=1, col=2, pos_x=10, pos_y=40)
pdf.add_image('FODF axial', 'axial.png', size_x=100, size_y=100,
              pos_x=100, pos_y=40)
pdf.add_image('FODF coronal', 'coronal.png', size_x=100, size_y=100,
              pos_x=100, pos_y=150)
pdf.output('report.pdf', 'F')
