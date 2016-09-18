module.exports =
Event = ->
    cbs = {}

    defaultDoneHandler = ->
        # do nothing

    me = {
        registerEvents: (events...) ->
            cbs[e] = [] for e in events
            null

        on: (event, cb) ->
            event = cbs[event] or throw("Can't register to event '#{event}' - it doesn't exist")
            event.push cb

        trigger: (event, args, done) ->
            events = cbs[event] or throw "Can't trigger #{event}, it doesn't exist"
            done or= defaultDoneHandler

            cb(args, done) for cb in events
            return null

        getEvents: ->
            Object.keys(cbs)

        hasEvent: (event) ->
            (event in cbs)

        pipeEventsFrom: (others...) ->
            others.forEach (other) ->
                other.getEvents().forEach (event) ->
                    do (other, event) ->
                        cbs[event] or= []
                        other.on event, (args...) -> me.trigger event, args...
                        return
                    return
                return

            return
    }
