package LRG::Pipeline::Align::CreateAlign;

use strict;
use warnings;

use base ('Bio::EnsEMBL::Hive::Process');

sub run {
  my $self = shift;
  
  my $run_dir        = $self->param('run_dir');
  my $align_dir      = $self->param('align_dir');
  my $gene           = $self->param('gene');
  my $data_files_dir = $self->param('data_files_dir');
  my $havana_file    = $self->param('havana_file');
  my $hgmd_file      = $self->param('hgmd_file');
  #my $uniprot_file   = $self->param('uniprot_file');
  my $lrg_id         = $self->param('lrg_id');
  
  # Creater letter directory
  my $gene_first_letter =  uc(substr($gene, 0, 1));
  my $sub_dir = "$align_dir/$gene_first_letter";
  if (! -d $sub_dir) {
    `mkdir $sub_dir`;
  }
  
  
  
  if ($lrg_id && $lrg_id ne '') {
    #`perl $run_dir/lrg-code/tools/align/transcript_alignment_tool.pl -g $gene -o $sub_dir/$gene.html -df $data_files_dir -hf $havana_file -no_dl -hgmd $hgmd_file -uniprot_file $uniprot_file -lrg $lrg_id`;
    `perl $run_dir/lrg-code/tools/align/transcript_alignment_tool.pl -g $gene -o $sub_dir/$gene.html -df $data_files_dir -hf $havana_file -no_dl -hgmd $hgmd_file -lrg $lrg_id`;
  }
  else {
     #`perl $run_dir/lrg-code/tools/align/transcript_alignment_tool.pl -g $gene -o $sub_dir/$gene.html -df $data_files_dir -hf $havana_file -no_dl -hgmd $hgmd_file -uniprot_file $uniprot_file`;
    `perl $run_dir/lrg-code/tools/align/transcript_alignment_tool.pl -g $gene -o $sub_dir/$gene.html -df $data_files_dir -hf $havana_file -no_dl -hgmd $hgmd_file`;
  }
}
1;
