# Iterates all projects, extracting the following attributes:
#   - project_descr
#   - project_title
#   - project_id
#   - document_name
# 
# Create new file
# 

fs = require 'fs'
_ = require 'underscore'

class Process
  constructor: ->
    projectFilesList = fs.readdirSync(__dirname + "/../projects")
    @_write(@_processAll(projectFilesList))

  _processAll: (filesList) ->
    _.map(filesList, (file) ->
      process.stdout.write '.'
      project = JSON.parse(fs.readFileSync(__dirname + '/../projects/' + file))
      return _.pick project, 'project_id', 'project_descr', 'project_title', 'document_name'
    )

  _write: (output) ->
    fs.writeFileSync(__dirname + "/../temp_files/extract_from_open.json", JSON.stringify(output))
    console.log "\nWritten #{output.length} projects"

module.export = Process
new Process