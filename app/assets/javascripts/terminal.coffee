class Terminal
  commands: []
  constructor: (element_id, @name) ->
    @term = $(element_id).terminal(@parser,
      {
      history: true,
      prompt: @prompt,
      greetings: "Welcome",
      exit: false,
      keydown: @keydown
      }
    )
    @term.disable()
    $(element_id).focusout @onBlur


  _findCommand: (name) ->
    for cmd in @commands
      if cmd.name is name
        return cmd
    null

  _validateCommand: (cmd, args) ->
    if(cmd.arguments.length  isnt args.length-1)
      return null

    pargs = (for argSpec,index in cmd.arguments
          obj = {}
          obj[argSpec[0]]=args[index+1]
          obj)
    pargs

  _showUsage: (cmd) ->
    info = ("[#{argSpec[0]}]" for argSpec in cmd.arguments)
    usage = "usage: #{cmd.name} #{info.join(' ')}"
    @term.error(usage)

  prompt: (cb) =>
    cb("[[g;#10CF50;#000000]#{@name}][[bg;#FFFFFF;#000000] -> ]")

  parser: (command, term) =>
    args = (arg.trim() for arg in command.trim().split(/\s\s*/) when arg.trim().length > 0 )
    if(args.length < 1)
      return

    commandToExecute = @_findCommand(args[0])

    if(!commandToExecute?)
      term.error("Unknown command name #{cmdName}!")
      return

    pargs = @_validateCommand(commandToExecute, args)
    if(!pargs?)
      @_showUsage(commandToExecute)
      return

    commandToExecute.execute(pargs, @term)
    term.echo("You just typped '#{args.join(',')}'")

  keydown: (event, term) ->
    true

  onBlur: =>
    @term.disable()


class Command
  arguments: [
    ['wsUrl', 'url of the websocket', 'r']
  ]
  name: 'wsconn'

  execute: (args, term) ->
    term.echo("Connecting to #{args.wsUrl}...")


$ ->
  window.terminal = new Terminal("#terminal", "skynet")
  window.terminal.commands.push(new Command())

