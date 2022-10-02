package store.data
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import flash.utils.getTimer;
   
   public class PreviewInfoII
   {
       
      
      private var _info:InventoryItemInfo;
      
      private var _rate:int;
      
      public function PreviewInfoII()
      {
         super();
         this._info = new InventoryItemInfo();
      }
      
      public function data(param1:int, param2:Number = 7) : void
      {
         this._info.TemplateID = param1;
         ItemManager.fill(this._info);
         this._info.BeginDate = String(getTimer());
         this._info.ValidDate = param2;
         this._info.IsJudge = true;
      }
      
      public function setComposeProperty(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._info.AgilityCompose = param1;
         this._info.AttackCompose = param2;
         this._info.DefendCompose = param3;
         this._info.LuckCompose = param4;
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._info;
      }
      
      public function set rate(param1:int) : void
      {
         this._rate = param1;
      }
      
      public function get rate() : int
      {
         return this._rate;
      }
   }
}
