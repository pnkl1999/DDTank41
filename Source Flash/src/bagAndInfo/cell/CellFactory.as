package bagAndInfo.cell
{
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.interfaces.ICell;
   import ddt.interfaces.ICellFactory;
   import ddt.manager.ItemManager;
   import ddt.manager.ShopManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import shop.view.ShopItemCell;
   import shop.view.ShopPlayerCell;
   
   public class CellFactory implements ICellFactory
   {
      
      private static var _instance:CellFactory;
       
      
      public function CellFactory()
      {
         super();
      }
      
      public static function get instance() : CellFactory
      {
         if(_instance == null)
         {
            _instance = new CellFactory();
         }
         return _instance;
      }
      
      public function createBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true) : ICell
      {
         var _loc4_:BagCell = new BagCell(param1,param2,param3);
         this.fillTipProp(_loc4_);
         return _loc4_;
      }
      
      public function createPersonalInfoCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true) : ICell
      {
         var _loc4_:BagCell = new PersonalInfoCell(param1,param2,param3);
         this.fillTipProp(_loc4_);
         return _loc4_;
      }
      
      public function createShopPlayerItemCell() : ICell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,45,45);
         _loc1_.graphics.endFill();
         var _loc2_:ShopPlayerCell = new ShopPlayerCell(_loc1_);
         this.fillTipProp(_loc2_);
         return _loc2_;
      }
      
      public function createShopCartItemCell() : ICell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,50,50);
         _loc1_.graphics.endFill();
         var _loc2_:ShopPlayerCell = new ShopPlayerCell(_loc1_);
         this.fillTipProp(_loc2_);
         return _loc2_;
      }
      
      public function createShopColorItemCell() : ICell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,90,90);
         _loc1_.graphics.endFill();
         var _loc2_:ShopPlayerCell = new ShopPlayerCell(_loc1_);
         this.fillTipProp(_loc2_);
         return _loc2_;
      }
      
      public function createShopItemCell(param1:DisplayObject, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Boolean = true) : ICell
      {
         var _loc5_:ShopItemCell = new ShopItemCell(param1,param2,param3,param4);
         this.fillTipProp(_loc5_);
         return _loc5_;
      }
      
      private function fillTipProp(param1:ICell) : void
      {
         param1.tipDirctions = "7,6,2,1,5,4,0,3,6";
         param1.tipGapV = 10;
         param1.tipGapH = 10;
         param1.tipStyle = "core.GoodsTip";
      }
      
      public function createWeeklyItemCell(param1:DisplayObject, param2:int) : ICell
      {
         var _loc5_:ShopCarItemInfo = null;
         var _loc3_:* = ShopManager.Instance.getShopItemByGoodsID(param2);
         if(!_loc3_)
         {
            _loc3_ = ItemManager.Instance.getTemplateById(param2);
         }
         var _loc4_:ShopPlayerCell = new ShopPlayerCell(param1);
         if(_loc3_ is ItemTemplateInfo)
         {
            _loc4_.info = _loc3_;
         }
         if(_loc3_ is ShopItemInfo)
         {
            _loc5_ = new ShopCarItemInfo(_loc3_.GoodsID,_loc3_.TemplateID);
            ObjectUtils.copyProperties(_loc5_,_loc3_);
            _loc4_.shopItemInfo = _loc5_;
         }
         ShowTipManager.Instance.removeTip(_loc4_);
         return _loc4_;
      }
	  
	  public function creteLockableBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null) : ICell
	  {
		  var _loc5_:LockableBagCell = new LockableBagCell(param1,param2,param3,param4);
		  this.fillTipProp(_loc5_);
		  return _loc5_;
	  }
   }
}
