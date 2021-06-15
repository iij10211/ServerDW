object DataModuleServidorRestFull: TDataModuleServidorRestFull
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  OnDestroy = ServerMethodDataModuleDestroy
  Encoding = esUtf8
  Height = 265
  Width = 487
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 360
    Top = 16
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 40
    Top = 88
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\MaxSystem Test\BD\MAXSYSTEM.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'CharacterSet=UTF8'
      'DriverID=FB')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 48
    Top = 8
  end
  object DWServerEvents1: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
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
        EventName = 'somar'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWServerEvents1EventssomarReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'subtrair'
        EventName = 'subtrair'
        OnlyPreDefinedParams = False
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
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
        EventName = 'busca'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWServerEvents1EventsbuscaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
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
        EventName = 'usuario'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWServerEvents1EventsusuarioReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'cliente'
        EventName = 'cliente'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventsclienteReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
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
        EventName = 'categoria'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventscategoriaReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'mesas'
        EventName = 'mesas'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventsmesasReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
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
        EventName = 'categoria_restaurante'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1Eventscategoria_restauranteReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
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
        EventName = 'comanda_produtos'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1Eventscomanda_produtosReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'pedidos'
        EventName = 'pedidos'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventspedidosReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'itens_pedidos'
        EventName = 'itens_pedidos'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1Eventsitens_pedidosReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'complementos'
        EventName = 'complementos'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventscomplementosReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'vendas'
        EventName = 'vendas'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventsvendasReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'idmesas'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'status_mesa'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'itens_mesa'
        EventName = 'itens_mesa'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1Eventsitens_mesaReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'idmesas'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'itens_mesa_complementos'
        EventName = 'itens_mesa_complementos'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1Eventsitens_mesa_complementosReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'idmesa'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'fechar_caixa'
        EventName = 'fechar_caixa'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1Eventsfechar_caixaReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'pedido_cozinha'
        EventName = 'pedido_cozinha'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1Eventspedido_cozinhaReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmDataware
        Name = 'dwevent18'
        EventName = 'dwevent18'
        OnlyPreDefinedParams = False
      end>
    Left = 48
    Top = 160
  end
  object qrGeral: TFDQuery
    Connection = FDConnection1
    Left = 168
    Top = 16
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 208
    Top = 152
  end
  object VQuery: TFDQuery
    Connection = FDConnection1
    Left = 248
    Top = 16
  end
  object VQueryComplemento: TFDQuery
    Connection = FDConnection1
    Left = 200
    Top = 80
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 344
    Top = 88
  end
  object VqueryVendas: TFDQuery
    Connection = FDConnection1
    Left = 432
    Top = 184
  end
  object ClientDataSet1: TClientDataSet
    PersistDataPacket.Data = {
      290000009619E0BD01000000180000000100000000000300000029000669646D
      65736104000100000000000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 160
    object ClientDataSet1idmesa: TIntegerField
      FieldName = 'idmesa'
    end
  end
  object Timer1: TTimer
    Interval = 5000
    Left = 328
    Top = 208
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
    Left = 192
    Top = 200
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    Connection = FDConnection1
    Left = 48
    Top = 216
  end
end
