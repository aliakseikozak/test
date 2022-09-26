object Service2: TService2
  OldCreateOrder = False
  DisplayName = 'Service2'
  OnExecute = ServiceExecute
  Height = 258
  Width = 406
  object TessttConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=tesstt')
    Connected = True
    LoginPrompt = False
    Left = 65
    Top = 69
  end
  object FDQuery1: TFDQuery
    Connection = TessttConnection
    SQL.Strings = (
      
        'INSERT INTO CURS_XML (currency_code, WELL, AMOUNT_CURRENCY, DOWL' +
        ')'
      
        'SELECT :currecy, :well, :amaunt, CAST('#39'TODAY'#39' AS DATE) FROM rdb$' +
        'database')
    Left = 64
    Top = 120
    ParamData = <
      item
        Name = 'CURRECY'
        ParamType = ptInput
      end
      item
        Name = 'WELL'
        ParamType = ptInput
      end
      item
        Name = 'AMAUNT'
        ParamType = ptInput
      end>
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 128
    Top = 120
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 216
    Top = 128
  end
  object XMLDocument1: TXMLDocument
    Left = 216
    Top = 72
  end
  object FDQuery2: TFDQuery
    Connection = TessttConnection
    SQL.Strings = (
      
        'INSERT INTO CURS_API (currency_code, WELL, AMOUNT_CURRENCY, DOWL' +
        ')'
      
        'SELECT :currecy, :well, :amaunt, CAST('#39'TODAY'#39' AS DATE) FROM rdb$' +
        'database')
    Left = 64
    Top = 176
    ParamData = <
      item
        Name = 'CURRECY'
        ParamType = ptInput
      end
      item
        Name = 'WELL'
        ParamType = ptInput
      end
      item
        Name = 'AMAUNT'
        ParamType = ptInput
      end>
  end
  object DataSource2: TDataSource
    DataSet = FDQuery2
    Left = 128
    Top = 176
  end
end
