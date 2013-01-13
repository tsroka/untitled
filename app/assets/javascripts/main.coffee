class WsConnection
  socket: null
  autoReconnect: false

  connect: (url) ->
    @socket = new WebSocket(url)
    @socket.onmessage = @onMessage
    @socket.onerror = @onError
    @socket.onclose = @onClose
    @socket.onopen = @onOpen


  onMessage: (event) ->



  onError: (event) ->
    console.log("Error occurred during connection: #{event}")

  onClose: (code, reason, clean) ->
    console.log("Connection to #{@url} closed. Code: #{code}, reason: #{reason}, wasClean: #{clean}")

  onOpen: (event) ->
    console.log "Connection to #{@url} established. #{event}"

  close: ->
    @autoReconnect = false
    @socket.close()