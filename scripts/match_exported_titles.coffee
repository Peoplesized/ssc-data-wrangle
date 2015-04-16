# Takes export from OpenRefine of additional 469 projects
# Compares each title to the `output.json` from `compile_project_titles.coffee`
# 

fs = require 'fs'
_ = require 'underscore'
score = require 'string_score'

MATCH_CONFIDENCE        = 0.6
SOURCE_MATCH_FIELD      = '1_Name of initiative'
DESTINATION_MATCH_FIELD = 'project_descr'

class Process
  constructor: ->
    @_loadData()
    @_write(@_processAll(@projects_to_match))
    
  _loadData: ->
    # Exported projects from OpenRefine
    @projects_to_match = JSON.parse(fs.readFileSync(__dirname + "/../temp_files/new_projects_to_match.json", 'utf8'))
    # Projects extract from open.undp.org
    @open_titles_to_search = JSON.parse(fs.readFileSync(__dirname + "/../temp_files/extract_from_open.json", 'utf8'))

  _processAll: (projects) ->
    _.chain(projects)
      .map (project) => @_processProject(project)
      .filter (project) -> project.top_match_project_id?
      .value()

  _processProject: (project) ->
    name = project[SOURCE_MATCH_FIELD]
    matches = @_getScoresFor(name)
    topMatch = matches[0]

    return {
      searched_for            : name
      top_match_project_id    : topMatch?.project_id
      top_match_project_title : topMatch?.project_title
      top_match_project_descr : topMatch?.project_descr
      top_match_confidence    : topMatch?.score
      top_match_document_link : topMatch?.document_name[1]?.join('; ')
    }

  _write: (output) ->
    fs.writeFileSync(__dirname + "/../output/matched_projects.json", JSON.stringify(output))
    console.log "\nWritten #{output.length} projects"

  # 
  # Scoring
  # 
  _getScoresFor: (name) ->
    _.chain(@_matchTerm(name))
      .filter (match) -> match.score > MATCH_CONFIDENCE
      .sortBy (match) -> -match.score
      .value()

  _matchTerm: (term) ->
    process.stdout.write '.'
    
    _.map @open_titles_to_search, (open_project) ->
      descr = open_project[DESTINATION_MATCH_FIELD]
      score = Math.ceil(descr.score(term) * 100) / 100
      return _.extend(score: score, open_project)

module.export = Process
new Process