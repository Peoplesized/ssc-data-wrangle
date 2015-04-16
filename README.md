# Scripts to wrangle SSC data

### Especially the 469 new projects

## 1. Compile project extract

Take every project from the `07d84a2151a9f32e4341ad6fb4bae4a47f04f2e9` commit on open.undp.org, an extract the following attributes: 
  - project_id
  - project_descr
  - project_title
  - document_name

Combine into a single file.

## 2. Search each of the 469 projects

Using [string_score](https://github.com/joshaven/string_score), check each of the 469 against each of the ~9500 projects from #1. Keep any matches over 0.6.



