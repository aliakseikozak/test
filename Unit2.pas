unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls
  , Vcl.SvcMgr, Vcl.Dialogs, Xml.XMLIntf, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  System.JSON,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Xml.xmldom, Xml.XMLDoc,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TService2 = class(TService)
    TessttConnection: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    IdHTTP1: TIdHTTP;
    XMLDocument1: TXMLDocument;
    FDQuery2: TFDQuery;
    DataSource2: TDataSource;
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  Service2: TService2;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Service2.Controller(CtrlCode);
end;

function TService2.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TService2.ServiceExecute(Sender: TService);
var
  nodeinf: IXMLNode;
  nodeide: IXMLNode;
  i : integer;
  usd, rus, eur : string;
  JSONusd, JSONrus, JSONeur: TJSONObject;
begin
  //службу установить не получилось. сам код по получению курсы валют и записи в БД рабочий, проверил на обчном приложение
  XMLDocument1.LoadFromFile('https://www.nbrb.by/Services/XmlExRates.aspx?ondate=');
  nodeinf :=  XMLDocument1.ChildNodes[1];
  for i := 0 to nodeinf.ChildNodes.Count - 1 do
  begin
    nodeide := nodeinf.ChildNodes[i];
    if ((nodeide.ChildValues['NumCode'] = '840') or (nodeide.ChildValues['NumCode'] = '643') or (nodeide.ChildValues['NumCode'] = '978')) then
    begin
      FDQuery1.ParamByName('currecy').AsString := nodeide.ChildValues['NumCode'];
      FDQuery1.ParamByName('well').AsFloat := StrToFloat(StringReplace(nodeide.ChildValues['Rate'], '.',',',[rfReplaceAll]));
      FDQuery1.ParamByName('amaunt').Asinteger := nodeide.ChildValues['Scale'];
      FDQuery1.ExecSQL;
    end;
  end;

  try
    IdHTTP1.Create;
    usd := IdHTTP1.get('https://www.nbrb.by/api/exrates/rates/840?parammode=1');
    rus := IdHTTP1.get('https://www.nbrb.by/api/exrates/rates/643?parammode=1');
    eur := IdHTTP1.get('https://www.nbrb.by/api/exrates/rates/978?parammode=1');
    JSONusd := TJSONObject.ParseJSONValue(usd) as TJSONObject;
    JSONrus := TJSONObject.ParseJSONValue(rus) as TJSONObject;
    JSONeur := TJSONObject.ParseJSONValue(eur) as TJSONObject;

    FDQuery2.ParamByName('currecy').AsString := '840';
    FDQuery2.ParamByName('well').AsFloat := StrToFloat(StringReplace(JSONusd.Get('Cur_OfficialRate').JsonValue.Value, '.',',',[rfReplaceAll]));
    FDQuery2.ParamByName('amaunt').Asinteger := StrToInt(JSONusd.Get('Cur_Scale').JsonValue.Value);
    FDQuery2.ExecSQL;

    FDQuery2.ParamByName('currecy').AsString := '643';
    FDQuery2.ParamByName('well').AsFloat := StrToFloat(StringReplace(JSONrus.Get('Cur_OfficialRate').JsonValue.Value, '.',',',[rfReplaceAll]));
    FDQuery2.ParamByName('amaunt').Asinteger := StrToInt(JSONrus.Get('Cur_Scale').JsonValue.Value);
    FDQuery2.ExecSQL;

    FDQuery2.ParamByName('currecy').AsString := '978';
    FDQuery2.ParamByName('well').AsFloat := StrToFloat(StringReplace(JSONeur.Get('Cur_OfficialRate').JsonValue.Value, '.',',',[rfReplaceAll]));
    FDQuery2.ParamByName('amaunt').Asinteger := StrToInt(JSONeur.Get('Cur_Scale').JsonValue.Value);
    FDQuery2.ExecSQL;

   finally
     IdHTTP1.Free;
     JSONusd.Free;
     JSONrus.Free;
     JSONeur.Free;
  end;
end;

end.
