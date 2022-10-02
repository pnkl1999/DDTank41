package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.ColorEditor;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import shop.ShopController;
   import shop.ShopEvent;
   import shop.ShopModel;
   
   public class ShopLeftView extends Sprite implements Disposeable
   {
      
      public static const SHOW_CART:uint = 1;
      
      public static const SHOW_COLOR:uint = 1;
      
      public static const SHOW_DRESS:uint = 0;
      
      public static const SHOW_WEALTH:uint = 0;
      
      public static const COLOR:uint = 1;
      
      public static const SKIN:uint = 2;
      
      private static const MALE:uint = 1;
      
      private static const FEMALE:uint = 2;
       
      
      private var _controller:ShopController;
      
      private var _model:ShopModel;
      
      private var prop:ShopLeftViewPropCollection;
      
      private var latestRandom:int = 0;
      
      public function ShopLeftView()
      {
         super();
         this.prop = new ShopLeftViewPropCollection();
         this.prop.setup();
         this.prop.addChildrenTo(this);
      }
      
      public function adjustBottomView(param1:uint) : void
      {
         this.prop.middlePanelBg.setFrame(param1 + 1);
         this.prop.panelBtnGroup.selectIndex = param1;
         if(param1 == SHOW_WEALTH)
         {
            this.prop.purchaseView.visible = true;
            this.prop.colorEditor.visible = false;
         }
         if(param1 == SHOW_COLOR)
         {
            this.prop.purchaseView.visible = false;
            this.prop.colorEditor.visible = true;
            this.__updateColorEditor();
         }
      }
      
      public function getColorEditorVisble() : Boolean
      {
         return this.prop.colorEditor.visible;
      }
      
      public function adjustUpperView(param1:uint) : void
      {
         this.prop.topBtnGroup.selectIndex = param1;
         if(param1 == SHOW_DRESS)
         {
            if(this.prop.middlePanelBg.getFrame == SHOW_WEALTH + 1)
            {
               this.prop.purchaseView.visible = true;
            }
            this.prop.dressView.visible = true;
            this.prop.cartScroll.visible = false;
         }
         if(param1 == SHOW_CART)
         {
            ObjectUtils.modifyVisibility(true,this.prop.cartScroll);
            ObjectUtils.modifyVisibility(false,this.prop.dressView);
            this.adjustBottomView(SHOW_WEALTH);
         }
      }
      
      public function refreshCharater() : void
      {
         if(!this.prop.maleCharacter)
         {
            this.prop.maleCharacter = CharactoryFactory.createCharacter(this._model.manModelInfo,"room") as RoomCharacter;
            this.prop.maleCharacter.show(false,-1);
            this.prop.maleCharacter.showGun = false;
            PositionUtils.setPos(this.prop.maleCharacter,"shop.PlayerCharacterPos");
            this.prop.dressView.addChild(this.prop.maleCharacter);
         }
         if(!this.prop.femaleCharacter)
         {
            this.prop.femaleCharacter = CharactoryFactory.createCharacter(this._model.womanModelInfo,"room") as RoomCharacter;
            this.prop.femaleCharacter.show(false,-1);
            this.prop.femaleCharacter.showGun = false;
            PositionUtils.setPos(this.prop.femaleCharacter,"shop.PlayerCharacterPos");
            this.prop.dressView.addChild(this.prop.femaleCharacter);
         }
         this.__fittingSexChanged();
      }
      
      public function setup(param1:ShopController, param2:ShopModel) : void
      {
         this._controller = param1;
         this._model = param2;
         this.initEvent();
         this.refreshCharater();
      }
      
      private function __addCarEquip(param1:ShopEvent) : void
      {
         this.addCarEquip(param1.param as ShopCarItemInfo);
      }
      
      private function __clearClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.revertToDefault();
      }
      
      private function __clearLastClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.removeLatestItem();
         this.__fittingSexChanged();
      }
      
      private function __conditionChange(param1:Event) : void
      {
         this._controller.updateCost();
      }
      
      private function __deleteItem(param1:Event) : void
      {
         var _loc2_:ShopCartItem = param1.currentTarget as ShopCartItem;
         this._controller.removeFromCar(_loc2_.shopItemInfo as ShopCarItemInfo);
         if(this.prop.cartList.contains(_loc2_))
         {
            this.prop.cartList.removeChild(_loc2_);
         }
      }
      
      private function __addTempEquip(param1:ShopEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:ShopCarItemInfo = param1.param as ShopCarItemInfo;
         if(EquipType.isProp(_loc2_.TemplateInfo))
         {
            return;
         }
         if(EquipType.dressAble(_loc2_.TemplateInfo) && _loc2_.CategoryID != EquipType.CHATBALL)
         {
            _loc3_ = EquipType.CategeryIdToPlace(_loc2_.CategoryID)[0];
            _loc4_ = this._model.getBagItems(_loc3_,true);
            this.prop.playerCells[_loc4_].shopItemInfo = _loc2_;
            _loc2_.place = _loc3_;
            this._model.currentModel.setPartStyle(_loc2_.CategoryID,_loc2_.TemplateInfo.NeedSex,_loc2_.TemplateID,_loc2_.Color);
         }
         this.__updateCar(param1);
         this.updateButtons();
         this.prop.lastItem.shopItemInfo = _loc2_;
         this.__updateColorEditor();
         if(this.prop.panelBtnGroup.selectIndex != 1)
         {
            if(_loc2_.TemplateInfo.NeedSex == MALE)
            {
               ++this.prop.addedManNewEquip;
            }
            else if(_loc2_.TemplateInfo.NeedSex == FEMALE)
            {
               ++this.prop.addedWomanNewEquip;
            }
         }
      }
      
      private function __fittingSexChanged(param1:ShopEvent = null) : void
      {
         var _loc3_:ShopCarItemInfo = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:ShopEvent = null;
         this.prop.femaleCharacter.visible = !!this._model.fittingSex ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         this.prop.maleCharacter.visible = !!this._model.fittingSex ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         this.prop.muteLock = true;
         this.prop.cbHideGlasses.selected = this._model.currentModel.getGlassHide();
         this.prop.cbHideHat.selected = this._model.currentModel.getHatHide();
         this.prop.cbHideSuit.selected = this._model.currentModel.getSuitesHide();
         this.prop.cbHideWings.selected = this._model.currentModel.wingHide;
         this.prop.muteLock = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.prop.playerCells.length)
         {
            _loc5_ = this._model.getBagItems(_loc2_);
            if(this._model.currentModel.Bag.items[_loc5_])
            {
               this.prop.playerCells[_loc2_].info = this._model.currentModel.Bag.items[_loc5_];
               this.prop.playerCells[_loc2_].locked = true;
            }
            else
            {
               this.prop.playerCells[_loc2_].shopItemInfo = null;
            }
            _loc2_++;
         }
         for each(_loc3_ in this._model.currentTempList)
         {
            _loc6_ = new ShopEvent("shop",_loc3_);
            this.__addTempEquip(_loc6_);
         }
         this.updateButtons();
         _loc4_ = this._model.currentTempList;
         if(_loc4_.length > 0)
         {
            this.prop.lastItem.shopItemInfo = _loc4_[_loc4_.length - 1];
         }
         else
         {
            this.prop.lastItem.shopItemInfo = null;
         }
      }
      
      private function __hideGlassChange(param1:Event) : void
      {
         if(!this.prop.muteLock)
         {
            SoundManager.instance.play("008");
         }
         this._model.currentModel.setGlassHide(this.prop.cbHideGlasses.selected);
      }
      
      private function __hideHatChange(param1:Event) : void
      {
         if(!this.prop.muteLock)
         {
            SoundManager.instance.play("008");
         }
         this._model.currentModel.setHatHide(this.prop.cbHideHat.selected);
      }
      
      private function __hideSuitesChange(param1:Event) : void
      {
         if(!this.prop.muteLock)
         {
            SoundManager.instance.play("008");
         }
         this._model.currentModel.setSuiteHide(this.prop.cbHideSuit.selected);
      }
      
      private function __hideWingClickHandler(param1:Event) : void
      {
         if(!this.prop.muteLock)
         {
            SoundManager.instance.play("008");
         }
         this._model.currentModel.wingHide = this.prop.cbHideWings.selected;
      }
      
      private function __originClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.restoreAllItemsOnBody();
      }
      
      private function __panelBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.adjustBottomView(this.prop.panelBtnGroup.selectIndex);
         if(param1.currentTarget == this.prop.panelColorBtn)
         {
            this.prop.colorEffet.stop();
         }
         this.__update(null);
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.MONEY] || param1.changedProperties[PlayerInfo.GIFT] || param1.changedProperties[PlayerInfo.MEDAL])
         {
            this.prop.playerMoneyTxt.text = String(this._model.Self.Money);
            this.prop.playerGiftTxt.text = String(this._model.Self.Gift);
            this.prop.playerMedalTxt.text = this._model.Self.medal.toString();
         }
      }
      
      private function __removeCarEquip(param1:ShopEvent) : void
      {
         var _loc3_:ShopCartItem = null;
         var _loc2_:ShopCarItemInfo = param1.param as ShopCarItemInfo;
         var _loc4_:uint = 0;
         while(this.prop.cartList.numChildren > 0)
         {
            _loc3_ = this.prop.cartList.getChildAt(_loc4_) as ShopCartItem;
            if(_loc3_.shopItemInfo == _loc2_)
            {
               break;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            _loc3_.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
            this.prop.cartList.removeChild(_loc3_);
         }
         this.prop.cartScroll.invalidateViewport();
      }
      
      private function __selectedColorChanged(param1:*) : void
      {
         var _loc2_:Object = new Object();
         if(this.prop.colorEditor.selectedType == COLOR)
         {
            this.setColorLayer(this.prop.colorEditor.selectedColor);
            _loc2_.color = this.prop.colorEditor.selectedColor;
         }
         else
         {
            this.setSkinColor(String(this.prop.colorEditor.selectedSkin));
            _loc2_.color = this.prop.colorEditor.selectedSkin;
         }
         _loc2_.item = this.prop.lastItem.shopItemInfo;
         _loc2_.type = this.prop.colorEditor.selectedType;
         dispatchEvent(new ShopEvent(ShopEvent.COLOR_SELECTED,_loc2_));
      }
      
      private function __topBtnClick(param1:MouseEvent = null) : void
      {
         SoundManager.instance.play("008");
         this.adjustUpperView(this.prop.topBtnGroup.selectIndex);
      }
      
      private function __update(param1:ShopEvent) : void
      {
         this.prop.leftMoneyPanelBuyBtn.enable = this._model.allItemsCount > 0;
         this.prop.purchaseBtn.enable = this._model.allItemsCount > 0;
         if(this.prop.purchaseBtn.enable)
         {
            this.prop.purchaseEffet.play();
         }
         else
         {
            this.prop.purchaseEffet.stop();
         }
         this.prop.presentBtn.enable = this._model.allItemsCount > 0;
         if(this.prop.presentBtn.enable)
         {
            this.prop.presentEffet.play();
         }
         else
         {
            this.prop.presentEffet.stop();
         }
         this.prop.costMedalTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitTF"));
         this.prop.costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitTF"));
         this.prop.costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitTF"));
         this.prop.costMedalTxt.text = String(this._model.totalMedal);
         this.prop.costMoneyTxt.text = String(this._model.totalMoney);
         this.prop.costGiftTxt.text = String(this._model.totalGift);
         this.prop.currentCountTxt.text = String(this._model.allItemsCount);
         if(this._model.totalMedal > this._model.Self.medal)
         {
            this.prop.costMedalTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitWarningTF"));
         }
         if(this._model.totalMoney > this._model.Self.Money)
         {
            this.prop.costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitWarningTF"));
         }
         if(this._model.totalGift > this._model.Self.Gift)
         {
            this.prop.costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("shop.DigitWarningTF"));
         }
      }
      
      private function __updateColorEditor(param1:ShopEvent = null) : void
      {
         this.prop.colorEditor.skinEditable = false;
         if(this._model.canChangSkin())
         {
            this.prop.colorEditor.selectedType = SKIN;
            if(this.prop.lastItem.shopItemInfo && this.prop.lastItem.shopItemInfo.CategoryID == EquipType.FACE)
            {
               this.prop.colorEditor.skinEditable = true;
            }
            this.setSkinColor(this._model.currentSkin);
            this.prop.colorEditor.editSkin(this.prop.colorEditor.selectedSkin);
         }
         else
         {
            this.prop.colorEditor.skinEditable = false;
            this.prop.colorEditor.resetSkin();
         }
         if(this.prop.lastItem.shopItemInfo && EquipType.isEditable(this.prop.lastItem.shopItemInfo.TemplateInfo))
         {
            this.prop.colorEditor.selectedType = COLOR;
            this.prop.colorEditor.colorEditable = true;
            this.prop.colorEditor.editColor(int(this.prop.lastItem.shopItemInfo.colorValue));
         }
         else
         {
            this.prop.colorEditor.colorEditable = false;
         }
      }
      
      private function addCarEquip(param1:ShopCarItemInfo) : void
      {
         var _loc2_:ShopCartItem = new ShopCartItem();
         _loc2_.shopItemInfo = param1;
         this.prop.cartList.addChild(_loc2_);
         _loc2_.addEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         _loc2_.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
         this.prop.cartScroll.invalidateViewport(true);
      }
      
      private function checkShiner(param1:Event = null) : void
      {
         if(this.prop.topBtnGroup.selectIndex == SHOW_DRESS && (this.prop.colorEditor.colorEditable || this.prop.colorEditor.skinEditable) && this.prop.lastItem.info != null)
         {
            this.prop.panelColorBtn.enable = true;
            if(this.prop.panelBtnGroup.selectIndex == SHOW_WEALTH && this.prop.canShine)
            {
               this.prop.colorEffet.play();
               this.prop.canShine = false;
            }
         }
         else
         {
            this.prop.panelColorBtn.enable = false;
            this.prop.colorEffet.stop();
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.checkShiner);
         this.prop.colorEditor.addEventListener(Event.CHANGE,this.__selectedColorChanged);
         this.prop.colorEditor.addEventListener(ColorEditor.REDUCTIVE_COLOR,this.__reductiveColor);
         this.prop.lastItem.addEventListener(ShopEvent.ITEMINFO_CHANGE,this.__updateColorEditor);
         this.prop.dressBtn.addEventListener(MouseEvent.CLICK,this.__topBtnClick);
         this.prop.cartBtn.addEventListener(MouseEvent.CLICK,this.__topBtnClick);
         this.prop.btnClearEquip.addEventListener(MouseEvent.CLICK,this.__clearClick);
         this.prop.btnClearLastEquip.addEventListener(MouseEvent.CLICK,this.__clearLastClick);
         this.prop.btnOriginEquip.addEventListener(MouseEvent.CLICK,this.__originClick);
         this.prop.cbHideHat.addEventListener(Event.SELECT,this.__hideHatChange);
         this.prop.cbHideGlasses.addEventListener(Event.SELECT,this.__hideGlassChange);
         this.prop.cbHideSuit.addEventListener(Event.SELECT,this.__hideSuitesChange);
         this.prop.cbHideWings.addEventListener(Event.SELECT,this.__hideWingClickHandler);
         this._model.addEventListener(ShopEvent.ADD_TEMP_EQUIP,this.__addTempEquip);
         this._model.addEventListener(ShopEvent.COST_UPDATE,this.__update);
         this._model.addEventListener(ShopEvent.ADD_CAR_EQUIP,this.__addCarEquip);
         this._model.addEventListener(ShopEvent.FITTINGMODEL_CHANGE,this.__fittingSexChanged);
         this._model.addEventListener(ShopEvent.REMOVE_CAR_EQUIP,this.__removeCarEquip);
         this._model.addEventListener(ShopEvent.SELECTEDEQUIP_CHANGE,this.__selectedEquipChange);
         this._model.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._model.addEventListener(ShopEvent.REMOVE_TEMP_EQUIP,this.__removeTempEquip);
         this.prop.lastItem.addEventListener(ShopEvent.ITEMINFO_CHANGE,this.__itemInfoChange);
         this.prop.panelCartBtn.addEventListener(MouseEvent.CLICK,this.__panelBtnClickHandler);
         this.prop.panelColorBtn.addEventListener(MouseEvent.CLICK,this.__panelBtnClickHandler);
         this.prop.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentClick);
         this.prop.purchaseBtn.addEventListener(MouseEvent.CLICK,this.__purchaseClick);
         this.prop.leftMoneyPanelBuyBtn.addEventListener(MouseEvent.CLICK,this.__purchaseClick);
         this.prop.randomBtn.addEventListener(MouseEvent.CLICK,this.__random);
         this.prop.saveFigureBtn.addEventListener(MouseEvent.CLICK,this.__saveFigureClick);
         this._model.addEventListener(ShopEvent.UPDATE_CAR,this.__updateCar);
         var _loc1_:int = 0;
         while(_loc1_ < this.prop.playerCells.length)
         {
            this.prop.playerCells[_loc1_].addEventListener(MouseEvent.CLICK,this.__cellClick);
            _loc1_++;
         }
      }
      
      private function __cellClick(param1:MouseEvent) : void
      {
         var _loc2_:ShopPlayerCell = param1.currentTarget as ShopPlayerCell;
         if(_loc2_.locked)
         {
            return;
         }
         this._controller.setSelectedEquip(_loc2_.shopItemInfo);
         this.prop.lastItem.shopItemInfo = _loc2_.shopItemInfo;
      }
      
      private function __updateCar(param1:ShopEvent) : void
      {
         var _loc5_:ShopCartItem = null;
         var _loc7_:uint = 0;
         var _loc2_:ShopCarItemInfo = param1.param as ShopCarItemInfo;
         var _loc3_:Array = this._model.allItems;
         var _loc4_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < this.prop.cartList.numChildren)
         {
            _loc5_ = this.prop.cartList.getChildAt(_loc6_) as ShopCartItem;
            _loc4_.push(_loc5_.shopItemInfo);
            _loc6_++;
         }
         if(_loc4_.length < _loc3_.length)
         {
            this.addCarEquip(_loc2_);
         }
         else if(_loc4_.length == _loc3_.length)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               if(_loc3_.indexOf(_loc4_[_loc7_]) < 0)
               {
                  (this.prop.cartList.getChildAt(_loc7_) as ShopCartItem).shopItemInfo = _loc2_;
                  break;
               }
               _loc7_++;
            }
         }
         else if(_loc4_.length > _loc3_.length)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               if(_loc3_.indexOf(_loc4_[_loc7_]) < 0)
               {
                  _loc6_ = 0;
                  while(_loc6_ < this.prop.cartList.numChildren)
                  {
                     _loc5_ = this.prop.cartList.getChildAt(_loc6_) as ShopCartItem;
                     if(_loc5_.shopItemInfo == _loc4_[_loc7_])
                     {
                        _loc5_.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
                        _loc5_.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
                        _loc5_.dispose();
                        break;
                     }
                     _loc6_++;
                  }
               }
               _loc7_++;
            }
         }
         this.prop.cartScroll.invalidateViewport();
      }
      
      private function removeEvents() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.checkShiner);
         this.prop.colorEditor.removeEventListener(Event.CHANGE,this.__selectedColorChanged);
         this.prop.colorEditor.removeEventListener(ColorEditor.REDUCTIVE_COLOR,this.__reductiveColor);
         this.prop.lastItem.removeEventListener(ShopEvent.ITEMINFO_CHANGE,this.__updateColorEditor);
         this.prop.dressBtn.removeEventListener(MouseEvent.CLICK,this.__topBtnClick);
         this.prop.cartBtn.removeEventListener(MouseEvent.CLICK,this.__topBtnClick);
         this.prop.btnClearEquip.removeEventListener(MouseEvent.CLICK,this.__clearClick);
         this.prop.btnClearLastEquip.removeEventListener(MouseEvent.CLICK,this.__clearLastClick);
         this.prop.btnOriginEquip.removeEventListener(MouseEvent.CLICK,this.__originClick);
         this.prop.cbHideHat.removeEventListener(Event.SELECT,this.__hideHatChange);
         this.prop.cbHideGlasses.removeEventListener(Event.SELECT,this.__hideGlassChange);
         this.prop.cbHideSuit.removeEventListener(Event.SELECT,this.__hideSuitesChange);
         this.prop.cbHideWings.removeEventListener(Event.SELECT,this.__hideWingClickHandler);
         this._model.removeEventListener(ShopEvent.ADD_TEMP_EQUIP,this.__addTempEquip);
         this._model.removeEventListener(ShopEvent.COST_UPDATE,this.__update);
         this._model.removeEventListener(ShopEvent.ADD_CAR_EQUIP,this.__addCarEquip);
         this._model.removeEventListener(ShopEvent.FITTINGMODEL_CHANGE,this.__fittingSexChanged);
         this._model.removeEventListener(ShopEvent.REMOVE_CAR_EQUIP,this.__removeCarEquip);
         this._model.removeEventListener(ShopEvent.SELECTEDEQUIP_CHANGE,this.__selectedEquipChange);
         this._model.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._model.removeEventListener(ShopEvent.REMOVE_TEMP_EQUIP,this.__removeTempEquip);
         this.prop.lastItem.removeEventListener(ShopEvent.ITEMINFO_CHANGE,this.__itemInfoChange);
         this.prop.panelCartBtn.removeEventListener(MouseEvent.CLICK,this.__panelBtnClickHandler);
         this.prop.panelColorBtn.removeEventListener(MouseEvent.CLICK,this.__panelBtnClickHandler);
         this.prop.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentClick);
         this.prop.purchaseBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseClick);
         this.prop.leftMoneyPanelBuyBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseClick);
         this.prop.saveFigureBtn.removeEventListener(MouseEvent.CLICK,this.__saveFigureClick);
         this._model.removeEventListener(ShopEvent.UPDATE_CAR,this.__updateCar);
         this.prop.randomBtn.removeEventListener(MouseEvent.CLICK,this.__random);
      }
      
      private function __purchaseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if((this._model.totalMoney > 0 || this._model.totalGift > 0 || this._model.totalMedal > 0) && PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.prop.checkOutPanel.setup(this._controller,this._model,this._model.allItems,ShopCheckOutView.PURCHASE);
         LayerManager.Instance.addToLayer(this.prop.checkOutPanel,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __random(param1:MouseEvent) : void
      {
         if(getTimer() - this.latestRandom < 1500)
         {
            return;
         }
         this.latestRandom = getTimer();
         this.prop.cbHideGlasses.selected = false;
         this.prop.cbHideHat.selected = false;
         this.prop.cbHideSuit.selected = true;
         this.prop.cbHideWings.selected = false;
         this._controller.model.random();
      }
      
      private function __saveFigureClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.prop.checkOutPanel.setup(this._controller,this._model,this._model.currentTempList,ShopCheckOutView.SAVE);
         LayerManager.Instance.addToLayer(this.prop.checkOutPanel,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __presentClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._model.hasFreeItems())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.message.free"));
            return;
         }
         var _loc2_:Array = ShopManager.Instance.moneyGoods(this._model.allItems,this._model.Self);
         if(_loc2_.length > 0)
         {
            this.prop.checkOutPanel.setup(this._controller,this._model,_loc2_,ShopCheckOutView.PRESENT);
            LayerManager.Instance.addToLayer(this.prop.checkOutPanel,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.cantPresent"));
         }
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         this.prop.canShine = true;
         this.__updateColorEditor();
      }
      
      private function __removeTempEquip(param1:ShopEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:ShopCarItemInfo = param1.param as ShopCarItemInfo;
         if(this.prop.lastItem.shopItemInfo == _loc2_)
         {
            this.prop.lastItem.shopItemInfo = null;
         }
         this.__updateColorEditor();
         if(_loc2_.TemplateInfo.NeedSex == MALE)
         {
            if(this.prop.addedManNewEquip > 0)
            {
               --this.prop.addedManNewEquip;
            }
            else
            {
               this.prop.addedManNewEquip = 0;
            }
         }
         else if(_loc2_.TemplateInfo.NeedSex == FEMALE)
         {
            if(this.prop.addedWomanNewEquip > 0)
            {
               --this.prop.addedWomanNewEquip;
            }
            else
            {
               this.prop.addedWomanNewEquip = 0;
            }
         }
         if(param1.model == this._model.currentModel)
         {
            _loc3_ = _loc2_.place;
            _loc4_ = this._model.getBagItems(_loc3_,true);
            _loc5_ = this._model.currentModel.Bag.items[_loc3_];
            if(_loc5_)
            {
               this.prop.playerCells[_loc4_].info = _loc5_;
               this.prop.playerCells[_loc4_].locked = true;
            }
            else
            {
               this.prop.playerCells[_loc4_].info = null;
            }
            this.updateButtons();
         }
         this.__updateCar(param1);
      }
      
      private function __selectedEquipChange(param1:ShopEvent) : void
      {
         this.prop.lastItem.shopItemInfo = param1.param as ShopCarItemInfo;
         this.updateButtons();
         this.__updateColorEditor();
      }
      
      private function setColorLayer(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc2_:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
         if(_loc2_ && EquipType.isEditable(_loc2_.TemplateInfo) && int(_loc2_.colorValue) != param1)
         {
            _loc3_ = this.prop.lastItem.editLayer - 1;
            _loc4_ = EquipType.CategeryIdToPlace(_loc2_.CategoryID)[0];
            _loc5_ = _loc2_.Color.split("|");
            _loc5_[_loc3_] = String(param1);
            _loc2_.Color = _loc5_.join("|");
            this.prop.lastItem.setColor(_loc2_.Color);
            this._model.currentModel.setPartColor(_loc2_.CategoryID,_loc2_.Color);
         }
      }
      
      private function setSkinColor(param1:String) : void
      {
         var _loc2_:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
         if(_loc2_ && _loc2_.CategoryID == EquipType.FACE)
         {
            _loc2_.skin = param1;
         }
         this.prop.lastItem.setSkinColor(param1);
         this._model.currentModel.Skin = param1;
      }
      
      protected function __reductiveColor(param1:Event) : void
      {
         var _loc2_:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
         if(this.prop.colorEditor.selectedType == COLOR)
         {
            if(_loc2_ && EquipType.isEditable(_loc2_.TemplateInfo))
            {
               _loc2_.Color = "";
               this._model.currentModel.setPartColor(_loc2_.CategoryID,null);
            }
         }
         else
         {
            _loc2_.skin = "";
            this._model.currentModel.setSkinColor("");
         }
      }
      
      private function updateButtons() : void
      {
         this.prop.saveFigureBtn.enable = this._model.isSelfModel && this._model.currentTempList.length != 0;
         if(this.prop.saveFigureBtn.enable)
         {
            this.prop.saveFigureEffet.play();
         }
         else
         {
            this.prop.saveFigureEffet.stop();
         }
         this.prop.btnOriginEquip.enable = this._model.Self.Sex == this._model.fittingSex;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this.prop.disposeAllChildrenFrom(this);
         this.prop = null;
         this._controller = null;
         this._model = null;
      }
   }
}
