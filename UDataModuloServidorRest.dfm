object DataModuleServidorRestFull: TDataModuleServidorRestFull
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  Height = 240
  Width = 376
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 168
    Top = 8
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 168
    Top = 80
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\BD\MAXSYSTEM.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 48
    Top = 8
  end
  object DWServerEvents1: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovInteger
            ParamName = 'valor1'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovInteger
            ParamName = 'valor2'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'somar'
        OnReplyEvent = DWServerEvents1EventssomarReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'subtrair'
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'tabela'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'busca'
        OnReplyEvent = DWServerEvents1EventsbuscaReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'user'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'password'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'usuario'
        OnReplyEvent = DWServerEvents1EventsusuarioReplyEvent
      end>
    Left = 168
    Top = 168
  end
  object VQuery: TFDQuery
    Connection = FDConnection1
    Left = 296
    Top = 168
  end
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverFD1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 48
    Top = 88
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    Connection = FDConnection1
    Left = 48
    Top = 168
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 296
    Top = 80
  end
end