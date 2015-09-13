Meteor.methods
  chooseSerialPort: (port, baud=9600) =>
    try
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
            #
            # (2) Broadcast new data to the client!
            #
            Streamy.broadcast 'benchmarkMsg',
              label: dataParts[0]
              order: _order
              t: _t
    catch
      return {
        success: false
        msg: "An error occurred while trying to open the serial port: #{error}"
      }
  closeSerialPort: =>
    try
      fut = new Future()
      serialPort.close (err) ->
        if err?
          fut.return
            success: false
            msg: "An error occurred while trying to close the serial port: #{err}"
        else
          fut.return
            success: true
            msg: "Serial port successfully closed!"
      fut.wait()
    catch error
      return {
        success: false
        msg: "An error occurred while trying to close the serial port: #{error}"
      }
  listSerialPorts: ->
    try
      fut = new Future()
      SerialPort.list (err, ports) ->
        fut.return
          success: true
          msg: "Local serial port scan complete. (#{ports.length} found)"
          ports: ports
      fut.wait()
    catch error
      return {
        success: false
        msg: "An error occurred while trying to list local serial ports: #{error}"
      }
  pauseSerialPort: ->
    try
      serialPort.pause()
      return {
        success: true
        msg: "Serial connection is paused."
      }
    catch error
      return {
        success: false
        msg: "An error occurred while trying to pause the serial connection: #{error}"
      }
  resumeSerialPort: ->
    try
      serialPort.resume()
      return {
        success: true
        msg: "Serial connection resumed."
      }
    catch error
      return {
        success: false
        msg: "An error occurred while trying to resume the serial connection: #{error}"
      }
  checkIfPortIsOpen: ->
    if !serialPort?
      return {
        success: true
        msg: "No serial port currently active."
        connected: false
      }
    try
      if serialPort.isOpen()
        return {
          success: true
          msg: "Serial port is currently active."
          connected: true
        }
      else
        return {
          success: true
          msg: "Serial port is not currently in use."
          connected: false
        }
    catch error
      return {
        success: false
        msg: "An error occurred while checking serial port status: #{error}"

      }
