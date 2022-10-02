package store.view.strength
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import store.StoreCell;
   
   public class StreangthItemCell extends StoreCell
   {
       
      
      protected var _stoneType:String = "";
      
      protected var _actionState:Boolean;
      
      public function StreangthItemCell(param1:int)
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.EquipCellBG");
         _loc2_.addChild(_loc3_);
         super(_loc2_,param1);
      }
      
      public function set stoneType(param1:String) : void
      {
         this._stoneType = param1;
      }
      
      public function set actionState(param1:Boolean) : void
      {
         this._actionState = param1;
      }
      
      public function get actionState() : Boolean
      {
         return this._actionState;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
            }
            else if(_loc2_.CanStrengthen && this.isAdaptToStone(_loc2_))
            {
               if(_loc2_.StrengthenLevel >= PathManager.solveStrengthMax())
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                  return;
               }
               if(_loc2_.StrengthenLevel == 9 && !SharedManager.Instance.isAffirm)
               {
                  SharedManager.Instance.isAffirm = true;
                  SharedManager.Instance.save();
                  _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.game.GameViewBase.HintTitle"),LanguageMgr.GetTranslation("store.view.strength.clew"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  _loc3_.info.showCancel = false;
                  _loc3_.addEventListener(FrameEvent.RESPONSE,this._response);
               }
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,1);
               this._actionState = true;
               param1.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
               this.reset();
            }
            else if(!this.isAdaptToStone(_loc2_))
            {
            }
         }
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      protected function isAdaptToStone(param1:InventoryItemInfo) : Boolean
      {
         if(this._stoneType == "")
         {
            return true;
         }
         if(this._stoneType == StoneType.STRENGTH && param1.RefineryLevel <= 0)
         {
            return true;
         }
         if(this._stoneType == StoneType.STRENGTH_1 && param1.RefineryLevel > 0)
         {
            return true;
         }
         return false;
      }
      
      protected function reset() : void
      {
         this._stoneType = "";
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
