#!/usr/bin/env nextflow

// Copyright (C) 2022 IRB Barcelona

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

params.help = null
params.input_folder = null
params.output_folder = "FASTQC"
params.fastqc_path = "fastqc"

log.info ""
log.info "-----------------------------------------------------------------------"
log.info "fastqc-nf: runninf fastqc on a folder of fastq files   "
log.info "-----------------------------------------------------------------------"
log.info "Copyright (C) 2022 IRB Barcelona"
log.info "This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE"
log.info "This is free software, and you are welcome to redistribute it"
log.info "under certain conditions; see LICENSE for details."
log.info "--------------------------------------------------------"
if (params.help) {
    log.info "--------------------------------------------------------"
    log.info "                     USAGE                              "
    log.info "--------------------------------------------------------"
    log.info ""
    log.info "nextflow run main.nf [OPTIONS]"
    log.info ""
    log.info "Mandatory arguments:"
    log.info "--input_folder         FOLDER                 Folder containing the fastq file to process"
    log.info ""
    log.info "Optional arguments:"
    log.info ""
    log.info "Flags:"
    log.info "--output_folder         FOLDER                Output folder"
    log.info "--fastqc_path           FILE                  Complete path to fastqc exectutable file"
    log.info "--help                                        Display tis message"
    log.info ""
    exit 1
}

assert (params.input_folder != null) : "please provide the --input_folder option"
log.info "Input folder: ${params.input_folder}"
log.info "Output folder: ${params.output_folder}"

fastq = Channel.fromPath(params.input_folder + '/*fastq.gz' )

process fastqc {

  tag {filename}

  publishDir params.output_folder, mode: 'copy'

  input:
  file f from fastq

  output:
  file '*html' into output1

  shell:
  filename=f.baseName
  '''
  !{params.fastqc_path} -o !{params.output_folder} !{f}
  '''
}
