
module.exports = (utils) ->
  { ls, cat, env, path, exist, sh  } =
  { dirExist, fileExist, linkExist } =
  { saveDir } = utils

  env or= process.env
  env.USER or= sh "whoami"
  env.HOME or= "/home/#{env.USER}"
  env.VIM or= "#{env.HOME}/.vim"

  bundleDir = path.join env.VIM, 'bundle'

  examineLocal: ->
    new Promise (resolve, reject) ->
      found = {}

      ls bundleDir
        .pipe (dir) ->
          found.dir = true

          dirExist path.join dir, '.git'
            .then ->
              sh "git remote -v", cwd: dir
                .pipe (line) ->
                  [name, url, mode] = line.split /\s+/

                  if name is 'origin' and mode is 'fetch'
                    found.dir = replace: -> sh "git clone " + url


  saveLocal: (found) ->
    for bundle, info in found
      if info is true
        saveDir path.join env.vim.home, 'bundle', bundle

  installRemote: ->
    
      
