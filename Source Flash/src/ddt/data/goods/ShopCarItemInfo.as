package ddt.data.goods
{
   import flash.events.Event;
   
   public class ShopCarItemInfo extends ShopItemInfo
   {
       
      
      private var _currentBuyType:int = 1;
      
      private var _color:String = "";
      
      public var dressing:Boolean;
      
      public var ModelSex:Boolean;
      
      public var colorValue:String = "";
      
      public var place:int;
      
      public var skin:String = "";
      
      public function ShopCarItemInfo(param1:int, param2:int, param3:int = 0)
      {
         super(param1,param2);
         this.currentBuyType = 1;
         if(param3 == 14)
         {
            this.currentBuyType = 2;
         }
         this.dressing = false;
      }
      
      public function set Property8(param1:String) : void
      {
         super.TemplateInfo.Property8 = param1;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length - 1)
         {
            this._color += "|";
            _loc2_++;
         }
      }
      
      public function get Property8() : String
      {
         return super.TemplateInfo.Property8;
      }
      
      public function get CategoryID() : int
      {
         return TemplateInfo.CategoryID;
      }
      
      public function get Color() : String
      {
         return this._color;
      }
      
      public function set Color(param1:String) : void
      {
         if(this._color != param1)
         {
            this._color = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function set currentBuyType(param1:int) : void
      {
         this._currentBuyType = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get currentBuyType() : int
      {
         return this._currentBuyType;
      }
      
      public function getCurrentPrice() : ItemPrice
      {
         return getItemPrice(this._currentBuyType);
      }
   }
}
