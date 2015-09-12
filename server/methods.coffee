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
          #
          # (1) Process non-initialization data by splitting it
          #     by tabs.  Make sure ints are valid numbers!
          #
          dataParts = data.split '\t'
          _t = parseInt dataParts[1]
          _order = parseInt dataParts[2]
          if isNaN(_t) or isNaN(_order)
            return
          Streamy.broadcast 'benchmarkMsg',
            label: dataParts[0]
            order: _order
            t: _t
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
