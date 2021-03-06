//+------------------------------------------------------------------+
//|                                                 DbConnection.mqh |
//|                                             Copyright GF1D, 2010 |
//|                                             garf1eldhome@mail.ru |
//+------------------------------------------------------------------+
#property copyright "GF1D, 2010"
#property link      "garf1eldhome@mail.ru"

#include "ClrObject.mqh"
#include "DbTransaction.mqh"

//--------------------------------------------------------------------
#import "AdoSuite.dll"
void OpenDbConnection(const long,string&,string&);
void CloseDbConnection(const long,string&,string&);
int GetDbConnectionState(const long,string&,string&);
string GetDbConnectionString(const long,string&,string&);
void SetDbConnectionString(const long,const string,string&,string&);
int GetDbConnectionTimeout(const long,string&,string&);
long DbConnectionTransaction(const long,string&,string&);
long DbConnectionTransactionLevel(const long,const int,string&,string&);
#import
//--------------------------------------------------------------------
/// \brief  \~russian Ïåðå÷èñëåíèå, ïðåäñòàâëÿþùåå ñîñòîÿíèå ïîäêëþ÷åíèÿ ê áàçå äàííûõ
///         \~english Describes the current state of the connection to a data source
enum ENUM_CONNECTION_STATE
  {
   CONSTATE_BROKEN = 0x10,
   CONSTATE_CLOSED = 0,
   CONSTATE_CONNECTING= 2,
   CONSTATE_EXECUTING = 4,
   CONSTATE_FETCHING=8,
   CONSTATE_OPEN=1
  };
//--------------------------------------------------------------------
/// \brief  \~russian Êëàññ, ïîçâîëÿþùèé óñòàíàâëèâàòü ïîäêëþ÷åíèå ê èñòî÷íèêó äàííûõ
///         \~english Represents a connection to a database
class CDbConnection : public CClrObject
  {
protected:
   // methods

   /// \brief  \~russian Ñîçäàåò îáúåêò òðàíçàêöèè. Âèðòóàëüíûé ìåòîä. Äîëæåí áûòü ïåðåîïðåäåëåí â íàñëåäíèêàõ
   ///         \~english Creates transaction. Virtual. Must be overriden
   virtual CDbTransaction *CreateTransaction() { return NULL; }

public:
   /// \brief  \~russian êîíñòðóêòîð êëàññà
   ///         \~english constructor
                     CDbConnection() { MqlTypeName("CDbConnection"); }

   // properties

   /// \brief  \~russian Âîçâðàùàåò ñòðîêó ïîäêëþ÷åíèÿ
   ///         \~english Gets connection string
   string            ConnectionString();
   /// \brief  \~russian Çàäàåò ñòðîêó ïîäêëþ÷åíèÿ
   ///         \~english Sets connection string
   void              ConnectionString(string value);

   /// \brief  \~russian Âîçâðàùàåò ìàêñèìàëüíîå êîëè÷åñòâî ñåêóíä, â òå÷åíèè êîòîðûõ ïûòàåìñÿ ïîäêëþ÷èòüñÿ ê áä
   ///         \~english Gets connection timeout
   int               ConnectionTimeout();
   /// \brief  \~russian Âîçâðàùàåò òåêóùåå ñîñòîÿíèå ñîåäèíåíèÿ
   ///         \~english Gets current connection state
   ENUM_CONNECTION_STATE State();

   // methods

   /// \brief  \~russian Îòêðûâàåò ñîåäèíåíèå
   ///         \~english Opens the connection
   void              Open();
   /// \brief  \~russian Çàêðûâàåò ñîåäèíåíèå
   ///         \~english Closes the connection
   void              Close();

   /// \brief  \~russian Íà÷èíàåò òðàíçàêöèþ
   ///         \~english Begins a transaction
   virtual CDbTransaction *BeginTransaction();
   /// \brief  \~russian Íà÷èíàåò òðàíçàêöèþ ñ óêàçàííûì óðîâíåì èçîëÿöèè
   ///         \~english Begins a transaction with specified isolation level
   /// \~russian \param level Îäèí èç âîçìîæíûõ óðîâíåé èçîëÿöèè òðàíçàêöèè 
   /// \~english \param level \~russian Transaction isolation level
   CDbTransaction   *BeginTransaction(ENUM_DBTRAN_ISOLATION_LEVEL level);
  };
//--------------------------------------------------------------------
void CDbConnection::Open(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   OpenDbConnection(ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("Open",exType,exMsg);
  }
//--------------------------------------------------------------------
void CDbConnection::Close(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   CloseDbConnection(ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("Close",exType,exMsg);
  }
//--------------------------------------------------------------------
ENUM_CONNECTION_STATE CDbConnection::State(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   ENUM_CONNECTION_STATE state=(ENUM_CONNECTION_STATE)GetDbConnectionState(ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("State(get)",exType,exMsg);

   return state;
  }
//--------------------------------------------------------------------
string CDbConnection::ConnectionString(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   string conStr=GetDbConnectionString(ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("ConnectionString(get)",exType,exMsg);

   return conStr;
  }
//--------------------------------------------------------------------
void CDbConnection::ConnectionString(string value)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   SetDbConnectionString(ClrHandle(),value,exType,exMsg);

   if(exType!="")
      OnClrException("ConnectionString(set)",exType,exMsg);
  }
//--------------------------------------------------------------------
int CDbConnection::ConnectionTimeout(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   int value=GetDbConnectionTimeout(ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("ConnectionTimeout(get)",exType,exMsg);

   return value;
  }
//--------------------------------------------------------------------
CDbTransaction *CDbConnection::BeginTransaction()
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   long hTransaction=DbConnectionTransaction(ClrHandle(),exType,exMsg);

   if(exType!="")
     {
      OnClrException("BeginTransaction",exType,exMsg);
      return NULL;
     }

   CDbTransaction *tran=CreateTransaction();
   tran.Assign(hTransaction,true);

   return tran;
  }
//--------------------------------------------------------------------
CDbTransaction *CDbConnection::BeginTransaction(ENUM_DBTRAN_ISOLATION_LEVEL level)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   long hTransaction=DbConnectionTransactionLevel(ClrHandle(),level,exType,exMsg);

   if(exType!="")
     {
      OnClrException("BeginTransaction",exType,exMsg);
      return NULL;
     }

   CDbTransaction *tran=CreateTransaction();
   tran.Assign(hTransaction,true);

   return tran;
  }
//+------------------------------------------------------------------+
