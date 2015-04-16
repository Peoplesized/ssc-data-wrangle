# Scripts to wrangle SSC data

*Especially for the '469' projects in the second batch*

## Requirements

- [nodeJS and npm](http://nodejs.org)
- [coffeescript](http://coffeescript.org) (With npm installed, `npm install -g coffee-script`)

## Running everything

Executing `coffee scripts/app.coffee` will produce a `matched_projects.json` file in the **output** folder.

## Individual scripts

If you want to run them separately...

### 1. Compile projects extract

Take every project from the `07d84a2151a9f32e4341ad6fb4bae4a47f04f2e9` commit on http://open.undp.org, and extract the following attributes: 

  - `project_id`
  - `project_descr`
  - `project_title`
  - `document_name`

Combine into a single file - `extract_from_open.json` in **temp_files** folder.

### 2. Compare each new project to the titles on 'Open'

Using [string_score](https://github.com/joshaven/string_score), check each of the 469 against each of the ~9500 projects from #1. Keep any matches with a confidence over 0.6.

Creates a `matched_projects.json` file in the **output** folder.