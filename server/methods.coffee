Meteor.methods
  chooseSerialPort: (port, baud=9600) =>
    #
    # (1) Configure serial port parameters.
    #
    serial_config =
      baudrate: baud
      parser: SerialPort.parsers.readline('\r\n')
    #
    # (2) Create serial port object, but do *not* open immediately.
    #
    @serialPort = new SerialPort.SerialPort port, serial_config#, false
    #
    # (3) Define data handling pipeline.
    #
    serialPort.on 'open', Meteor.bindEnvironment ->
      console.log 'Port open'
      serialPort.on 'data', Meteor.bindEnvironment (data) ->
        unless data is 'init'
          #console.log data
          dataParts = data.split '\t'
          _t = parseInt dataParts[1]
          _order = parseInt dataParts[2]
          if isNaN(_t) or isNaN(_order)
            return
          newMsg_q =
            label: dataParts[0]
          newMsg_update =
            $set:
              t: _t
              order: _order
          BenchmarkMsgs.upsert newMsg_q, newMsg_update
  openSerialPort: =>
    serialPort.open()
  closeSerialPort: =>
    serialPort.close (err) ->
      console.log "Port closed"
  listSerialPorts: ->
    fut = new Future()
    SerialPort.list (err, ports) ->
      fut.return ports
    fut.wait()
  checkIfPortIsOpen: ->
    try
      serialPort.isOpen()
    catch error
      #
  clearAllData: ->
    BenchmarkMsgs.remove({})
