#! /bin/bash
. ~/.bashrc
. ~/.lrgpaths

xmldir=''
if [[ -n $1 && $1 != " " ]]; then
  xmldir=" -xml_dir $1"
fi

tmpdir="-tmp_dir ${LRGROOTDIR}"
if [[ -n $2 ]]; then
  tmpdir="-tmp_dir $2"
fi

report_dir="${LRGROOTDIR}/tmp"
if [[ -n $3 ]]; then
  report_dir="$3s"
fi

script_dir=${LRGROOTDIR}/lrg-code/scripts

script_lrg_list=${script_dir}/get_lrg_list.pl
script_tr_list=${script_dir}/get_lrg_transcript_list.pl
script_tr_xref_list=${script_dir}/get_lrg_transcript_xrefs.pl
script_pr_list=${script_dir}/get_lrg_protein_list.pl

farm_report_file="${report_dir}/report_export_file_"

queue="-q production-rh74"

memory=1500

a_37=GRCh37
a_38=GRCh38

if [ -d $report_dir ]; then

  #### GRCh37 ####

  # LRGs list
  if [ -e "${farm_report_file}lrg_GRCh37.out" ]; then
    rm -f "${farm_report_file}lrg_GRCh37.*"
  fi
  bsub -J LRG_37 ${queue} -M${memory} -R"select[mem>${memory}] rusage[mem=${memory}]" -o ${farm_report_file}lrg_GRCh37.out -e ${farm_report_file}lrg_GRCh37.err \
  perl ${script_lrg_list} -assembly ${a_37} ${xmldir}

  # LRG transcripts list
  if [ -e "${farm_report_file}tr_GRCh37.out" ]; then
    rm -f "${farm_report_file}tr_GRCh37.*"
  fi
  bsub -J LRG_tr_37 ${queue} -M${memory} -R"select[mem>${memory}] rusage[mem=${memory}]" -o ${farm_report_file}tr_GRCh37.out -e ${farm_report_file}tr_GRCh37.err \
  perl ${script_tr_list} -assembly ${a_37} ${xmldir} ${tmpdir}

  #### GRCh38 ####

  # LRGs list
   if [ -e "${farm_report_file}lrg_GRCh38.out" ]; then
    rm -f "${farm_report_file}lrg_GRCh38.*"
  fi
  bsub -J LRG_38 ${queue} -M1500 -R"select[mem>1500] rusage[mem=1500]" -o ${farm_report_file}lrg_GRCh38.out -e ${farm_report_file}lrg_GRCh38.err \
  perl ${script_lrg_list} -assembly ${a_38} ${xmldir}

  # LRG transcripts list
  if [ -e "${farm_report_file}tr_GRCh38.out" ]; then
    rm -f "${farm_report_file}tr_GRCh38.*"
  fi
  bsub -J LRG_tr_38 ${queue} -M1500 -R"select[mem>1500] rusage[mem=1500]" -o ${farm_report_file}tr_GRCh38.out -e ${farm_report_file}tr_GRCh38.err \
  perl ${script_tr_list} -assembly ${a_38} ${xmldir} ${tmpdir}

  # LRG transcript xrefs
  if [ -e "${farm_report_file}tr_xref.out" ]; then
    rm -f "${farm_report_file}tr_xref.*"
  fi
  bsub -J LRG_tr_xref ${queue} -M1500 -R"select[mem>1500] rusage[mem=1500]" -o ${farm_report_file}tr_xref.out -e ${farm_report_file}tr_xref.err \
  perl ${script_tr_xref_list}

  # LRG proteins
  if [ -e "${farm_report_file}pr.out" ]; then
    rm -f "${farm_report_file}pr.*"
  fi
  bsub -J LRG_pr ${queue} -M1500 -R"select[mem>1500] rusage[mem=1500]" -o ${farm_report_file}pr.out -e ${farm_report_file}pr.err \
  perl ${script_pr_list}
  
else

  echo "Can't find the report directory '$report_dir' to run the list of scripts on the farm. Scripts failed!"
  
fi

