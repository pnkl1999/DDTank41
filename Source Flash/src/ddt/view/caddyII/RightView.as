package ddt.view.caddyII
{
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Sprite;
   
   public class RightView extends Sprite implements Disposeable
   {
      
      public static const START_TURN:String = "caddy_start_turn";
      
      public static const START_MOVE_AFTER_TURN:String = "start_move_after_turn";
       
      
      protected var _item:ItemTemplateInfo;
      
      protected var _type:int = 0;
      
      protected var _autoCheck:SelectedCheckButton;
      
      public function RightView()
      {
         super();
      }
      
      public function again() : void
      {
      }
      
      public function setSelectGoodsInfo(param1:InventoryItemInfo) : void
      {
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._autoCheck);
         this._autoCheck = null;
      }
      
      public function get item() : ItemTemplateInfo
      {
         return this._item;
      }
      
      public function set item(param1:ItemTemplateInfo) : void
      {
         this._item = param1;
      }
      
      public function setType(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get openBtnEnable() : Boolean
      {
         return false;
      }
   }
}
