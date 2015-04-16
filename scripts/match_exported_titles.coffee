# Takes export from OpenRefine of additional 469 projects
# Compares each title to the `output.json` from `compile_project_titles.coffee`
# 

fs = require 'fs'
_ = require 'underscore'
score = require 'string_score'

class Process
  constructor: ->
    # Load exported projects from OpenRefine
    projects_to_match = JSON.parse(fs.readFileSync(__dirname + "/../temp_files/new_projects_to_match.json", 'utf8'))

    # Load project extract from open.undp.org
    @open_titles_to_search = JSON.parse(fs.readFileSync(__dirname + "/../temp_files/titles_from_open.json", 'utf8'))

    output = _.chain(projects_to_match)
      .map (project) =>
        name = project['1_Name of initiative']
        
        allMatches = @_getDescrScoresFor(name)
        matches = _.chain(allMatches)
          .filter (match) -> match.score > 0.6
          .sortBy (match) -> -match.score
          .value()
        topMatch = matches[0]
        return {
          searched_for: name
          top_match_project_id: topMatch?.project_id
          top_match_project_title: topMatch?.project_title
          top_match_project_descr: topMatch?.project_descr
          top_match_confidence: topMatch?.score
          top_match_document_link: topMatch?.document_name[1]?.join('; ')
        }
      .filter (project) -> project.top_match_project_id?
      .value()

    fs.writeFileSync(__dirname + "/../output/matched_projects.json", JSON.stringify(output))
    console.log "\nWritten #{output.length} projects"

  _getDescrScoresFor: (term) ->
    process.stdout.write '.'
    _.map @open_titles_to_search, (open_project) ->
      descr = open_project['project_descr']
      score = Math.ceil(descr.score(term) * 100) / 100
      return _.extend(score: score, open_project)

  
module.export = Process
s = new Process
