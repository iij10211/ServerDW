object DataModuleServidorRestFull: TDataModuleServidorRestFull
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  Height = 242
  Width = 377
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
      'CharacterSet=UTF8'
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
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'usuario'
        OnReplyEvent = DWServerEvents1EventsusuarioReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'cliente'
        OnReplyEventByType = DWServerEvents1EventsclienteReplyEventByType
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'idtabela'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'categoria'
        OnReplyEventByType = DWServerEvents1EventscategoriaReplyEventByType
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'mesas'
        OnReplyEventByType = DWServerEvents1EventsmesasReplyEventByType
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'idcategoria_restaurant'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'categoria_restaurante'
        OnReplyEventByType = DWServerEvents1Eventscategoria_restauranteReplyEventByType
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'comanda_produtoid'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'comanda_produtos'
        OnReplyEventByType = DWServerEvents1Eventscomanda_produtosReplyEventByType
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'pedidos'
        OnReplyEventByType = DWServerEvents1EventspedidosReplyEventByType
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'itens_pedidos'
        OnReplyEventByType = DWServerEvents1Eventsitens_pedidosReplyEventByType
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
