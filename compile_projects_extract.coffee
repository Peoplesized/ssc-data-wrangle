# Iterates all projects, extracting the following attributes:
#   - project_descr
#   - project_title
#   - project_id
# 
# Create new file
#   

fs = require 'fs'
_ = require 'underscore'

suffix = '_test'
suffix = ''

class Process
  constructor: ->
    output = _.map fs.readdirSync(__dirname + "/projects#{suffix}"), (file) ->
      process.stdout.write '.'
      project = JSON.parse(fs.readFileSync(__dirname + '/projects/' + file))
      _.pick project, 'project_id', 'project_descr', 'project_title', 'document_name'

    fs.writeFileSync(__dirname + "/titles_from_open#{suffix}.json", JSON.stringify(output))

    console.log "\nWritten #{output.length} projects"
      
module.export = Process
s = new Process
