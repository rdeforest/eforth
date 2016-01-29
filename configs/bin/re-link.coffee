#!coffee

# Update symlinks in ~ to point to $project_root/home
# Linking functions all have same arg order as ln -s, ie ln -s existingObject linkName

if not process.env.HOME
  throw new Error "No HOME environment var? What were you hoping would happen?!"

fs = require 'fs'
path = require 'path'

[interpreter, script, args...] = process.argv
[from, to] = args
from or= path.resolve path.dirname script, '..'
to or= process.env.HOME

class TheTool
  constructor: -> @verbosity = 1

  relinkDir: (from, to) ->

  vLog: (level, message...) ->
    console.log.apply console, message unless level > @verbosity

  log: (message...) ->
    @vLog 1, message...

  relinkItem: (item, link) ->
    if item.endsWith '.'
      return @log "Skipping item ending in a dot: #{item}"

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



(new TheTool).relinkDir from, to


###

    if (-l $dir) {
        if (-e $link && !-l $link) {
          warn "Skipped $link: expected symlink.\n";
          return;
        }

        unlink $link;
        symlink $dir, $link;
        return;
    }

    if (!-e $link) {
        mkdir $link;
    }

    if (!-d $link) {
        warn "Skipped $link: expected directory.\n";
        return;
    }

    opendir(my $dh, $dir);
    while(my $item = readdir($dh)) {
        next if $item eq "." or $item eq "..";
        relinkItem("$dir/$item", "$link/$item");
    }
}
