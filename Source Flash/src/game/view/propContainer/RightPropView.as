package game.view.propContainer
{
   import bagAndInfo.bag.ItemCellView;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.events.KeyboardEvent;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   
   public class RightPropView extends BaseGamePropBarView
   {
      
      private static const PROP_ID:int = 10;
       
      
      public function RightPropView(param1:LocalPlayer)
      {
         super(param1,8,1,false,false,false,ItemCellView.RIGHT_PROP);
         this.initView();
         this.setItem();
      }
      
      private function initView() : void
      {
         _itemContainer.vSpace = 4;
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case KeyStroke.VK_1.getCode():
            case KeyStroke.VK_NUMPAD_1.getCode():
               _itemContainer.mouseClickAt(0);
               break;
            case KeyStroke.VK_2.getCode():
            case KeyStroke.VK_NUMPAD_2.getCode():
               _itemContainer.mouseClickAt(1);
               break;
            case KeyStroke.VK_3.getCode():
            case KeyStroke.VK_NUMPAD_3.getCode():
               _itemContainer.mouseClickAt(2);
               break;
            case KeyStroke.VK_4.getCode():
            case KeyStroke.VK_NUMPAD_4.getCode():
               _itemContainer.mouseClickAt(3);
               break;
            case KeyStroke.VK_5.getCode():
            case KeyStroke.VK_NUMPAD_5.getCode():
               _itemContainer.mouseClickAt(4);
               break;
            case KeyStroke.VK_6.getCode():
            case KeyStroke.VK_NUMPAD_6.getCode():
               _itemContainer.mouseClickAt(5);
               break;
            case KeyStroke.VK_7.getCode():
            case KeyStroke.VK_NUMPAD_7.getCode():
               _itemContainer.mouseClickAt(6);
               break;
            case KeyStroke.VK_8.getCode():
            case KeyStroke.VK_NUMPAD_8.getCode():
               _itemContainer.mouseClickAt(7);
         }
      }
      
      public function setItem() : void
      {
         var _loc4_:* = null;
         var _loc5_:PropInfo = null;
         var _loc6_:Array = null;
         var _loc7_:InventoryItemInfo = null;
         _itemContainer.clear();
         var _loc1_:Boolean = false;
         var _loc2_:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.T_ALL_PROP,true,true);
         var _loc3_:Object = SharedManager.Instance.GameKeySets;
         for(_loc4_ in _loc3_)
         {
            if(int(_loc4_) == 9)
            {
               break;
            }
            _loc5_ = new PropInfo(ItemManager.Instance.getTemplateById(_loc3_[_loc4_]));
            if(_loc2_ || PlayerManager.Instance.Self.hasBuff(BuffInfo.FREE))
            {
               if(_loc2_)
               {
                  _loc5_.Place = _loc2_.Place;
               }
               else
               {
                  _loc5_.Place = -1;
               }
               _loc5_.Count = -1;
               _itemContainer.appendItemAt(new PropItemView(_loc5_,true,false,-1),int(_loc4_) - 1);
               _loc1_ = true;
            }
            else
            {
               _loc6_ = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_loc3_[_loc4_]);
               if(_loc6_.length > 0)
               {
                  _loc5_.Place = _loc6_[0].Place;
                  for each(_loc7_ in _loc6_)
                  {
                     _loc5_.Count += _loc7_.Count;
                  }
                  _itemContainer.appendItemAt(new PropItemView(_loc5_,true,false),int(_loc4_) - 1);
                  _loc1_ = true;
               }
               else
               {
                  _itemContainer.appendItemAt(new PropItemView(_loc5_,false,false),int(_loc4_) - 1);
               }
            }
         }
         if(_loc1_)
         {
            _itemContainer.setClickByEnergy(self.energy);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      override protected function __click(param1:ItemEvent) : void
      {
         var _loc2_:PropItemView = param1.item as PropItemView;
         var _loc3_:PropInfo = _loc2_.info;
         if(_loc2_.isExist)
         {
            if(self.isLiving == false)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.RightPropView.prop"));
               return;
            }
            if(!self.isAttacking)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
               return;
            }
            if(self.LockState)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.cantUseItem"));
               return;
            }
            if(self.energy < _loc3_.needEnergy)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.actions.SelfPlayerWalkAction"));
               return;
            }
            self.useItem(_loc3_.Template);
            GameInSocketOut.sendUseProp(1,_loc3_.Place,_loc3_.Template.TemplateID);
         }
         else
         {
            SoundManager.instance.play("008");
         }
      }
      
      private function confirm() : void
      {
         if(PlayerManager.Instance.Self.Money >= ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.FREE_PROP_CARD).getItemPrice(1).moneyValue)
         {
            SocketManager.Instance.out.sendUseCard(-1,-1,[EquipType.FREE_PROP_CARD],1,true);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
         }
      }
   }
}
