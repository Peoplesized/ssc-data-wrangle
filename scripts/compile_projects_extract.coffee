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

projects = fs.readdirSync(__dirname + "/../projects")

output = _.map(projects, (file) ->
  process.stdout.write '.'
  project = JSON.parse(fs.readFileSync(__dirname + '/../projects/' + file))
  _.pick project, 'project_id', 'project_descr', 'project_title', 'document_name'
)

fs.writeFileSync(__dirname + "/../temp_files/titles_from_open.json", JSON.stringify(output))

console.log "\nWritten #{output.length} projects"
