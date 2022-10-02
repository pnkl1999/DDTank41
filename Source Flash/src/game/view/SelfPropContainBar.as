package game.view
{
   import bagAndInfo.bag.ItemCellView;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.ItemEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.model.LocalPlayer;
   import game.view.propContainer.BaseGamePropBarView;
   import game.view.propContainer.PropShortCutView;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   
   public class SelfPropContainBar extends BaseGamePropBarView
   {
      
      public static var USE_THREE_SKILL:String = "useThreeSkill";
      
      public static var USE_PLANE:String = "usePlane";
       
      
      private var _back:Bitmap;
      
      private var _info:SelfInfo;
      
      private var _shortCut:PropShortCutView;
      
      private var _myitems:Array;
      
      public function SelfPropContainBar(param1:LocalPlayer)
      {
         super(param1,3,3,false,false,false,ItemCellView.PROP_SHORT);
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.propBackAsset");
         addChild(this._back);
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("asset.game.itemContainerPos");
         _itemContainer.x = _loc2_.x;
         _itemContainer.y = _loc2_.y;
         addChild(_itemContainer);
         this._shortCut = new PropShortCutView();
         this._shortCut.setPropCloseEnabled(0,false);
         this._shortCut.setPropCloseEnabled(1,false);
         this._shortCut.setPropCloseEnabled(2,false);
         addChild(this._shortCut);
         this.setLocalPlayer(param1.playerInfo as SelfInfo);
         this.initData();
      }
      
      private function initData() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:PropInfo = null;
         var _loc1_:BagInfo = this._info.FightBag;
         for each(_loc2_ in _loc1_.items)
         {
            _loc3_ = new PropInfo(_loc2_);
            _loc3_.Place = _loc2_.Place;
            this.addProp(_loc3_);
         }
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case KeyStroke.VK_Z.getCode():
               _itemContainer.mouseClickAt(0);
               break;
            case KeyStroke.VK_X.getCode():
               _itemContainer.mouseClickAt(1);
               break;
            case KeyStroke.VK_C.getCode():
               _itemContainer.mouseClickAt(2);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._shortCut)
         {
            this._shortCut.dispose();
         }
         this._shortCut = null;
         removeChild(this._back);
         this._info = null;
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      public function setLocalPlayer(param1:SelfInfo) : void
      {
         if(this._info != param1)
         {
            if(this._info)
            {
               this._info.FightBag.removeEventListener(BagEvent.UPDATE,this.__updateProp);
               _itemContainer.clear();
            }
            this._info = param1;
            if(this._info)
            {
               this._info.FightBag.addEventListener(BagEvent.UPDATE,this.__updateProp);
            }
         }
      }
      
      private function __removeProp(param1:BagEvent) : void
      {
         var _loc2_:PropInfo = new PropInfo(param1.changedSlots as InventoryItemInfo);
         _loc2_.Place = param1.changedSlots.Place;
         this.removeProp(_loc2_ as PropInfo);
      }
      
      private function __updateProp(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:PropInfo = null;
         var _loc6_:PropInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = this._info.FightBag.getItemAt(_loc3_.Place);
            if(_loc4_)
            {
               _loc5_ = new PropInfo(_loc4_);
               _loc5_.Place = _loc4_.Place;
               this.addProp(_loc5_);
            }
            else
            {
               _loc6_ = new PropInfo(_loc3_);
               _loc6_.Place = _loc3_.Place;
               this.removeProp(_loc6_);
            }
         }
      }
      
      override public function setClickEnabled(param1:Boolean, param2:Boolean) : void
      {
         super.setClickEnabled(param1,param2);
      }
      
      override protected function __click(param1:ItemEvent) : void
      {
         var _loc2_:PropInfo = null;
         if(param1.item == null)
         {
            return;
         }
         if(self.LockState)
         {
            if(self.LockType == 0)
            {
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.effect.seal"));
         }
         else
         {
            if(self.isLiving && !self.isAttacking)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
               return;
            }
            if(self.energy >= Number(PropItemView(param1.item).info.Template.Property4))
            {
               _loc2_ = PropItemView(param1.item).info;
               self.useItem(_loc2_.Template);
               GameInSocketOut.sendUseProp(2,_loc2_.Place,_loc2_.Template.TemplateID);
               if(_loc2_.Template.TemplateID == 10003)
               {
                  dispatchEvent(new Event(USE_THREE_SKILL));
               }
               if(_loc2_.Template.TemplateID == 10016)
               {
                  dispatchEvent(new Event(USE_PLANE));
               }
               _itemContainer.setItemClickAt(_loc2_.Place,false,true);
               this._shortCut.setPropCloseVisible(_loc2_.Place,false);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.actions.SelfPlayerWalkAction"));
            }
         }
      }
      
      override protected function __over(param1:ItemEvent) : void
      {
         super.__over(param1);
         this._shortCut.setPropCloseVisible(param1.index,true);
      }
      
      override protected function __out(param1:ItemEvent) : void
      {
         super.__out(param1);
         this._shortCut.setPropCloseVisible(param1.index,false);
      }
      
      public function addProp(param1:PropInfo) : void
      {
         this._shortCut.setPropCloseEnabled(param1.Place,true);
         _itemContainer.appendItemAt(new PropItemView(param1,true,false),param1.Place);
      }
      
      public function removeProp(param1:PropInfo) : void
      {
         this._shortCut.setPropCloseEnabled(param1.Place,false);
         this._shortCut.setPropCloseVisible(param1.Place,false);
         _itemContainer.removeItemAt(param1.Place);
      }
   }
}
