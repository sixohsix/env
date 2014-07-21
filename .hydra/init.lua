-- refers to grid.lua in this directory, taken from the Hydra wiki: https://github.com/sdegutis/hydra/wiki/Useful-Hydra-libraries
require "grid"
mike = require "mike"

-- Donate via Bitcoin: 18LEhURYNgkC9PPdtdXShDoyaHXGaLENe7

pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()

local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "ctrl", "shift"}

-- save the time when updates are checked
function checkforupdates()
  updates.check()
  settings.set('lastcheckedupdates', os.time())
end

-- show a helpful menu
menu.show(function()
    local updatetitles = {[true] = "Install Update", [false] = "Check for Update..."}
    local updatefns = {[true] = updates.install, [false] = checkforupdates}
    local hasupdate = (updates.newversion ~= nil)

    return {
      {title = "Reload Config", fn = hydra.reload},
      {title = "-"},
      {title = "About", fn = hydra.showabout},
      {title = updatetitles[hasupdate], fn = updatefns[hasupdate]},
      {title = "Open API Documentation", fn = showapi},
      {title = "Quit Hydra", fn = os.exit},
    }
end)

function showapi()
  os.execute('open http://sdegutis.github.io/hydra/')
end

-- show available updates
local function showupdate()
  os.execute('open https://github.com/sdegutis/Hydra/releases')
end

-- what to do when an udpate is checked
function updates.available(available)
  if available then
    notify.show("Hydra update available", "", "Click here to see the changelog and maybe even install it", "showupdate")
  else
    hydra.alert("No update available.")
  end
end

-- Uncomment this if you want Hydra to make sure it launches at login
autolaunch.set(true)

-- check for updates every week
timer.new(timer.weeks(1), checkforupdates):start()
notify.register("showupdate", showupdate)

-- if this is your first time running Hydra, you're launching it more than a week later, check now
local lastcheckedupdates = settings.get('lastcheckedupdates')
if lastcheckedupdates == nil or lastcheckedupdates <= os.time() - timer.days(7) then
  checkforupdates()
end

-- hotkey.bind({"cmd", "alt", "ctrl"}, "D", donate)

hotkey.bind(mash, 'D', function() mike.runoractivateorshoworhidebytitle("Dictionary") end)

hotkey.bind(mash, ';', function() ext.grid.snap(window.focusedwindow()) end)
hotkey.bind(mash, "'", function() fnutils.map(window.visiblewindows(), ext.grid.snap) end)

hotkey.bind(mash, '=', function() ext.grid.adjustwidth( 1) end)
hotkey.bind(mash, '-', function() ext.grid.adjustwidth(-1) end)
hotkey.bind(mashshift, '=', function() ext.grid.adjustheight( 1) end)
hotkey.bind(mashshift, '-', function() ext.grid.adjustheight(-1) end)

hotkey.bind(mashshift, 'H', function() window.focusedwindow():focuswindow_west() end)
hotkey.bind(mashshift, 'L', function() window.focusedwindow():focuswindow_east() end)
hotkey.bind(mashshift, 'K', function() window.focusedwindow():focuswindow_north() end)
hotkey.bind(mashshift, 'J', function() window.focusedwindow():focuswindow_south() end)

hotkey.bind(mash, 'M', ext.grid.maximize_window)

hotkey.bind(mash, 'N', ext.grid.pushwindow_nextscreen)
hotkey.bind(mash, 'P', ext.grid.pushwindow_prevscreen)

hotkey.bind(mash, 'J', ext.grid.pushwindow_down)
hotkey.bind(mash, 'K', ext.grid.pushwindow_up)
hotkey.bind(mash, 'H', ext.grid.pushwindow_left)
hotkey.bind(mash, 'L', ext.grid.pushwindow_right)

hotkey.bind(mash, 'Y', ext.grid.resizewindow_taller)
hotkey.bind(mash, 'U', ext.grid.resizewindow_wider)
hotkey.bind(mash, 'I', ext.grid.resizewindow_thinner)
hotkey.bind(mash, 'O', ext.grid.resizewindow_shorter)

hotkey.bind(mash, 'X', logger.show)
hotkey.bind(mash, "R", repl.open)

hotkey.bind(mash, 'T', function() mike.runoractivateorshoworhidebytitle("Twitter") end)
