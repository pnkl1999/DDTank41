package lanternriddles.view
{
   import bagAndInfo.cell.BagCell;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   import lanternriddles.data.LanternAwardInfo;
   
   public class LanternRankItemAward extends Sprite
   {
      
      private static var AWARD_NUM:int = 3;
       
      
      private var _awardVec:Vector.<BagCell>;
      
      public function LanternRankItemAward()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:BagCell = null;
         this._awardVec = new Vector.<BagCell>();
         var _loc2_:int = 0;
         while(_loc2_ < AWARD_NUM)
         {
            _loc1_ = new BagCell(_loc2_,null,true,null,false);
            _loc1_.BGVisible = false;
            _loc1_.setContentSize(28,28);
            _loc1_.x = _loc2_ * 35;
            _loc1_.y = 3;
            addChild(_loc1_);
            this._awardVec.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function set info(param1:Vector.<LanternAwardInfo>) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new InventoryItemInfo();
            _loc3_.TemplateID = param1[_loc2_].TempId;
            _loc3_.IsBinds = param1[_loc2_].IsBind;
            _loc3_.ValidDate = param1[_loc2_].ValidDate;
            this._awardVec[_loc2_].info = ItemManager.fill(_loc3_);
            this._awardVec[_loc2_].setCount(param1[_loc2_].AwardNum);
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this._awardVec)
         {
            _loc1_ = 0;
            while(_loc1_ < AWARD_NUM)
            {
               this._awardVec[_loc1_].dispose();
               this._awardVec[_loc1_] = null;
               _loc1_++;
            }
            this._awardVec.length = 0;
            this._awardVec = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
