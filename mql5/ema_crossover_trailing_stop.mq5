// EMA 10 / EMA 50 Crossover with Trailing Stop
// Simple MT5 Expert Advisor
// Author: Vineet Kumar

#property strict

input int FastEMA = 10;
input int SlowEMA = 50;
input double LotSize = 0.1;
input int TrailingStopPoints = 300;

double fastEMA_prev, fastEMA_curr;
double slowEMA_prev, slowEMA_curr;

int OnInit()
{
   return(INIT_SUCCEEDED);
}

void OnTick()
{
   fastEMA_curr = iMA(_Symbol, _Period, FastEMA, 0, MODE_EMA, PRICE_CLOSE, 0);
   fastEMA_prev = iMA(_Symbol, _Period, FastEMA, 0, MODE_EMA, PRICE_CLOSE, 1);

   slowEMA_curr = iMA(_Symbol, _Period, SlowEMA, 0, MODE_EMA, PRICE_CLOSE, 0);
   slowEMA_prev = iMA(_Symbol, _Period, SlowEMA, 0, MODE_EMA, PRICE_CLOSE, 1);

   // BUY: EMA 10 crosses above EMA 50
   if (fastEMA_prev < slowEMA_prev && fastEMA_curr > slowEMA_curr)
   {
      ClosePositions(POSITION_TYPE_SELL);
      OpenPosition(ORDER_TYPE_BUY);
   }

   // SELL: EMA 10 crosses below EMA 50
   if (fastEMA_prev > slowEMA_prev && fastEMA_curr < slowEMA_curr)
   {
      ClosePositions(POSITION_TYPE_BUY);
      OpenPosition(ORDER_TYPE_SELL);
   }

   ApplyTrailingStop();
}

void OpenPosition(int orderType)
{
   MqlTradeRequest request;
   MqlTradeResult result;
   ZeroMemory(request);

   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = LotSize;
   request.type = orderType;
   request.price = (orderType == ORDER_TYPE_BUY)
                   ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                   : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   request.deviation = 10;
   request.magic = 202501;

   OrderSend(request, result);
}

void ClosePositions(int positionType)
{
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if (PositionGetSymbol(i) == _Symbol &&
          PositionGetInteger(POSITION_TYPE) == positionType)
      {
         MqlTradeRequest request;
         MqlTradeResult result;
         ZeroMemory(request);

         request.action = TRADE_ACTION_CLOSE_POSITION;
         request.position = PositionGetInteger(POSITION_TICKET);
         OrderSend(request, result);
      }
   }
}

void ApplyTrailingStop()
{
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if (PositionGetSymbol(i) != _Symbol)
         continue;

      ulong ticket = PositionGetInteger(POSITION_TICKET);
      int type = PositionGetInteger(POSITION_TYPE);

      double price = (type == POSITION_TYPE_BUY)
                     ? SymbolInfoDouble(_Symbol, SYMBOL_BID)
                     : SymbolInfoDouble(_Symbol, SYMBOL_ASK);

      double newSL;

      if (type == POSITION_TYPE_BUY)
         newSL = price - TrailingStopPoints * _Point;
      else
         newSL = price + TrailingStopPoints * _Point;

      MqlTradeRequest request;
      MqlTradeResult result;
      ZeroMemory(request);

      request.action = TRADE_ACTION_SLTP;
      request.position = ticket;
      request.sl = newSL;

      OrderSend(request, result);
   }
}
