SerialPort = Meteor.npmRequire('serialport')
serialPort = new SerialPort.SerialPort "/dev/ttyACM2",
  baudrate: 9600
  parser: SerialPort.parsers.readline('\r\n')
serialPort.on 'open', ->
  console.log 'Port open'

serialPort.on 'data', Meteor.bindEnvironment (data) ->
  unless data is 'init'
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
