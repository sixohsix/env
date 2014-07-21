-- mike.lua v2014.07.14

local mike = {}

function mike.runningbytitle(t)
    return fnutils.filter(
        application.runningapplications(),
        function (app)
            return app:title() == t
        end)
end

function mike.activateorshoworhide(app)
    local focusedapp = window.focusedwindow():application()
    if app:ishidden() then
        app:unhide()
        app:activate()
    elseif focusedapp == app then
        app:hide()
    else
        app:activate()
    end
end

function mike.activateorshoworhidebytitle(title)
    fnutils.each(mike.runningbytitle(title), mike.activateorshoworhide)
end

return mike
