package auctionHouse.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   
   public class AuctionAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<AuctionGoodsInfo>;
      
      public var total:int;
      
      public function AuctionAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:int = 0;
         var _loc5_:AuctionGoodsInfo = null;
         var _loc6_:XMLList = null;
         var _loc7_:InventoryItemInfo = null;
         this.list = new Vector.<AuctionGoodsInfo>();
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_.Item;
         this.total = _loc2_.@total;
         if(_loc2_.@value == "true")
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new AuctionGoodsInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc6_ = _loc3_[_loc4_].Item;
               if(_loc6_.length() > 0)
               {
                  _loc7_ = new InventoryItemInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc7_,_loc6_[0]);
                  ItemManager.fill(_loc7_);
                  _loc5_.BagItemInfo = _loc7_;
                  this.list.push(_loc5_);
               }
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
