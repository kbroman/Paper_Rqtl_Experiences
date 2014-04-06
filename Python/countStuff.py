#!/usr/bin/env python

# count stuff: 

# x- no. software releases
# x- currently: no. lines C, R and doc code
# x- amount of R vs C, rounded to tens
# - scantwo R function: no. lines, as proportion of R code
# - C code no. lines, as proportion of C code
#   and "more than x%"

import re

lines_file = "Data/lines_code_by_version.csv"
lines = open(lines_file).readlines()
isversion = [len(re.findall("^\d", line))>0 for line in lines]
n_versions = sum(isversion)

print 'n_versions =', n_versions

nlines = lines[1].split(',')
print 'lines_R =', nlines[2]
print 'lines_C =', nlines[3]
print 'lines_man =', nlines[4]


scantwo_file = 'qtl/R/scantwo.R'
import os.path

if os.path.isfile(scantwo_file):
  delete_qtl = False
else:
  delete_qtl = True
  from subprocess import call
  tar_file = '/Users/kbroman/Code/Rqtl/Backup/qtl_' + lines[1].split(',')[0] + '.tar.gz'
  call(['tar', 'xzf', tar_file])

# The following is an overly complicated method for counting lines in scantwo function
lines = open(scantwo_file).readlines()
firstline = 0
n_scantwo_lines = 0
n_brace = 0
for line in range(0, len(lines)):
  if len(re.findall("^scantwo ", lines[line])) > 0:
    firstline = line
  if firstline > 0:
    n_scantwo_lines += 1
    n_forward = len(re.findall("{", lines[line]))
    n_backward = len(re.findall("}", lines[line]))
    n_brace += (n_forward - n_backward)
  if n_brace == 0 and firstline > 0 and line > firstline + 15:
    break

print 'n_scantwo_lines =', n_scantwo_lines

def countlines (file): 
  import os
  n_lines = os.popen('wc -l ' + file).read().strip().split(' ')[0]
  return int(n_lines)

# determine no. lines in scantwo C functions
dir = 'qtl/src/'
scantwo_c_files = [dir + file for file in os.listdir(dir) if len(re.findall("^scantwo.*\.c$", file))>0]

n_scantwo_c_lines = sum( [countlines(file) for file in scantwo_c_files] )
print "n_scantwo_c_lines =", n_scantwo_c_lines

# delete the qtl directory
if delete_qtl:
  call(['rm', '-rf', 'qtl'])


