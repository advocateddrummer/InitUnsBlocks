# Pointwise V18.3 Journal file - Mon Dec 30 15:15:26 2019

package require PWI_Glyph 3.18.3

puts "Running $argv0 with: [pw::Application getVersion]"

set pwFile [lindex $argv 0]
if { [string match "*.pw" $pwFile] } {
  puts "Opening Pointwise project file $pwFile"
} else {
  puts "ERROR: the first argument must be a Pointwise project file (ending in .pw)"
  exit
}

pw::Application reset
pw::Application load "$pwFile"

set blocks [pw::Grid getAll -type pw::Block]
puts "blocks: $blocks"

foreach block $blocks {
  puts "Initializing block $block..."
  set unsSolver [pw::Application begin UnstructuredSolver $block]
    if [catch { $unsSolver run Initialize } msg] {
      puts "Error initializing $block..."
      puts $msg
      catch { $unsSolver abort }
      exit -1
    }
  $unsSolver end
  unset unsSolver
  puts "$block initialized"
}

pw::Application save $pwFile