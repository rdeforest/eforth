#!coffee

# Update symlinks in ~ to point to $project_root/home
# Linking functions all have same arg order as ln -s, ie ln -s existingObject linkName

if not process.env.HOME
  throw new Error "No HOME environment var? What were you hoping would happen?!"

fs = require 'fs'
path = require 'path'

config =
  debug: true
  verbose: 1
  dryRun: true

main = ->
  projectRoot = path.resolve path.dirname script, '..'

  [
    interpreter, script
    from = projectRoot
    to = process.env.HOME
  ] = process.argv

  (new TheTool verbosity: config.verbose)
    .relinkItem from, to

class TheTool
  constructor: ({@verbosity = 1, @actions = this.defaultActions}) ->

  defaultActions:
    ln: (from, to) ->
      

  vLog: (level, message...) ->
    console.log.apply console, message unless level > @verbosity

  log: (message...) ->
    @vLog 1, message...

  relinkDir: (from, to) ->
    vLog "Updating #{to} from #{from}"

    if not fs.existsSync to
      # .. make link
      return

    toStat = fs.lstatSync to
    if toStat.isDirectory()
    if toStat.isSymbolicLink()
      target = fs.readlinkSync to
    
    throw 

  relinkLink: (from, to) ->

  relinkItem: (item, link) ->
    if (path.basename item) in '..'
      return @log "Skipping . or ..: #{item}"

    @vLog 2, "relinkItem #{item}, #{link}"

    itemStat = fs.lstatSync item

    if itemStat.isSymbolicLink()
      return @relinkLink item, link

    if itemStat.isDirectory()
      return @relinkDir item, link

    if itemStat.isFile()
      return @relinkFile item, link

    @warn "Not prepared for file type of #{item}, not processed"

  relinkFile: (file, link) ->
    linkStat = fs.lstatSync link

    if linkStat and not linkStat.isSymbolicLink()
      @warn "Not replacing #{link}: it exists and is not a symlink"
      return

    fs.unlinkSync link
    fs.linkSync file, link

  relinkDir: (dir, link) ->
    log "Updating #{link} from #{dir}"

    dirStat = fs.lstatSync dir
    linkStat = fs.lstatSync link

    if dirStat.isSymbolicLink()
      if linkStat and not linkStat.isSymbolicLink()
        log "Skipping link #{dir}: destination is not also a symlink"


main()
