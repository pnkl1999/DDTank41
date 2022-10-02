package changeColor.view
{
   import bagAndInfo.cell.BagCell;
   import changeColor.ChangeColorModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.ColorEditor;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import road7th.utils.StringHelper;
   
   public class ChangeColorLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bg:DisplayObject;
      
      private var _charaterBack:ScaleBitmapImage;
      
      private var _controlBack:DisplayObject;
      
      private var _title:DisplayObject;
      
      private var _charater:ICharacter;
      
      private var _hideHat:SelectedCheckButton;
      
      private var _hideGlass:SelectedCheckButton;
      
      private var _hideSuit:SelectedCheckButton;
      
      private var _hideWing:SelectedCheckButton;
      
      private var _cell:ColorEditCell;
      
      private var _colorEditor:ColorEditor;
      
      private var _model:ChangeColorModel;
      
      private var _itemChanged:Boolean;
      
      public function ChangeColorLeftView()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._charaterBack = null;
         this._controlBack = null;
         this._cell = null;
         this._charater = null;
         this._colorEditor = null;
         this._model = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set model(param1:ChangeColorModel) : void
      {
         this._model = param1;
         this.dataUpdate();
      }
      
      public function reset() : void
      {
         if(this._model.currentItem == null)
         {
            return;
         }
         this.restoreItem();
         this.restoreCharacter();
         this._model.changed = false;
         this._model.currentItem = null;
      }
      
      public function setCurrentItem(param1:BagCell) : void
      {
         SoundManager.instance.play("008");
         if(this._cell.bagCell == null && param1.info != null)
         {
            this._cell.bagCell = param1;
            param1.locked = true;
         }
         else
         {
            this._model.initColor = null;
            this._model.initSkinColor = null;
            this._cell.bagCell.locked = false;
            this._cell.bagCell = param1;
            param1.locked = true;
         }
         this.updateColorPanel();
      }
      
      private function __cellChangedHandler(param1:Event) : void
      {
         if((param1.target as BagCell).info && this._model.currentItem == null)
         {
            this._model.currentItem = this._cell.bagCell.itemInfo;
            this.savaItemInfo();
            this.updateCharator();
         }
         else if((param1.target as BagCell).info == null)
         {
            this.reset();
         }
         this.updateColorPanel();
      }
      
      private function __hideGalssChange(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.self.setGlassHide(this._hideGlass.selected);
      }
      
      private function __hideHatChange(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.self.setHatHide(this._hideHat.selected);
      }
      
      private function __hideSuitChange(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.self.setSuiteHide(this._hideSuit.selected);
      }
      
      private function __hideWingChange(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.self.wingHide = this._hideWing.selected;
      }
      
      private function __setColor(param1:Event) : void
      {
         if(this._model.currentItem)
         {
            if(this._colorEditor.selectedType == 2)
            {
               this.setItemSkin(this._model.currentItem,this._colorEditor.selectedSkin.toString());
            }
            else
            {
               this.setItemColor(this._model.currentItem,this._colorEditor.selectedColor.toString());
            }
            this._model.changed = true;
         }
      }
      
      private function dataUpdate() : void
      {
         this.initView();
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this._cell.addEventListener(Event.CHANGE,this.__cellChangedHandler);
         this._colorEditor.addEventListener(Event.CHANGE,this.__setColor);
         this._colorEditor.addEventListener(ColorEditor.REDUCTIVE_COLOR,this.__reductiveColor);
         this._hideHat.addEventListener(MouseEvent.CLICK,this.__hideHatChange);
         this._hideGlass.addEventListener(MouseEvent.CLICK,this.__hideGalssChange);
         this._hideSuit.addEventListener(MouseEvent.CLICK,this.__hideSuitChange);
         this._hideWing.addEventListener(MouseEvent.CLICK,this.__hideWingChange);
      }
      
      private function initView() : void
      {
         var _loc1_:Rectangle = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("LeftBack");
         addChild(this._bg);
         this._charaterBack = ComponentFactory.Instance.creatComponentByStylename("CharacterBack");
         addChild(this._charaterBack);
         this._controlBack = ComponentFactory.Instance.creatBitmap("asset.changeColor.ControlBack");
         addChild(this._controlBack);
         this._title = ComponentFactory.Instance.creatBitmap("asset.changeColor.title");
         addChild(this._title);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.leftViewBgImgRec");
         this._charater = CharactoryFactory.createCharacter(this._model.self);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.charaterRec");
         ObjectUtils.copyPropertyByRectangle(this._charater as DisplayObject,_loc1_);
         this._charater.show(false,-1);
         this._charater.showGun = false;
         addChild(this._charater as DisplayObject);
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(0,0);
         _loc2_.graphics.drawRect(0,0,90,90);
         _loc2_.graphics.endFill();
         this._cell = new ColorEditCell(_loc2_);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.colorEditCellRec");
         ObjectUtils.copyPropertyByRectangle(this._cell as DisplayObject,_loc1_);
         addChild(this._cell);
         this._colorEditor = ComponentFactory.Instance.creatCustomObject("changeColor.ColorEdit");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.colorEditorRec");
         ObjectUtils.copyPropertyByRectangle(this._colorEditor as DisplayObject,_loc1_);
         addChild(this._colorEditor);
         this._hideHat = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.hideHatRec");
         ObjectUtils.copyPropertyByRectangle(this._hideHat as DisplayObject,_loc1_);
         this._hideHat.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
         this._hideHat.selected = this._model.self.getHatHide();
         addChild(this._hideHat);
         this._hideGlass = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.hideGlassRec");
         ObjectUtils.copyPropertyByRectangle(this._hideGlass as DisplayObject,_loc1_);
         this._hideGlass.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
         this._hideGlass.selected = this._model.self.getGlassHide();
         addChild(this._hideGlass);
         this._hideSuit = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.hideSuitRec");
         ObjectUtils.copyPropertyByRectangle(this._hideSuit as DisplayObject,_loc1_);
         this._hideSuit.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
         this._hideSuit.selected = this._model.self.getSuitesHide();
         addChild(this._hideSuit);
         this._hideWing = ComponentFactory.Instance.creatComponentByStylename("personanHideWingCheckBox");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.hideWingRec");
         ObjectUtils.copyPropertyByRectangle(this._hideWing as DisplayObject,_loc1_);
         this._hideWing.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
         this._hideWing.selected = this._model.self.wingHide;
         addChild(this._hideWing);
         this.updateColorPanel();
      }
      
      private function removeEvents() : void
      {
         this._cell.removeEventListener(Event.CHANGE,this.__cellChangedHandler);
         this._colorEditor.removeEventListener(Event.CHANGE,this.__setColor);
         this._colorEditor.removeEventListener(ColorEditor.REDUCTIVE_COLOR,this.__reductiveColor);
      }
      
      private function restoreCharacter() : void
      {
         this._model.self.setPartStyle(this._model.currentItem.CategoryID,!!this._model.self.Sex ? int(int(1)) : int(int(2)),PlayerManager.Instance.Self.getPartStyle(this._model.currentItem.CategoryID),PlayerManager.Instance.Self.getPartColor(this._model.currentItem.CategoryID),true);
         this._model.self.setPartColor(this._model.currentItem.CategoryID,PlayerManager.Instance.Self.getPartColor(this._model.currentItem.CategoryID));
         this._model.self.setSkinColor(PlayerManager.Instance.Self.Skin);
      }
      
      private function restoreItem() : void
      {
         this._model.restoreItem();
      }
      
      private function savaItemInfo() : void
      {
         this._model.savaItemInfo();
      }
      
      private function setItemColor(param1:InventoryItemInfo, param2:String) : void
      {
         if(param1.Color == "||")
         {
            param1.Color = "";
         }
         var _loc3_:Array = param1.Color.split("|");
         _loc3_[this._cell.editLayer - 1] = String(param2);
         var _loc4_:String = _loc3_.join("|").replace(/\|$/,"");
         param1.Color = _loc4_;
         this._cell.setColor(_loc4_);
         this._model.self.setPartColor(this._model.currentItem.CategoryID,_loc4_);
         this._model.self.setSkinColor(this._model.self.getSkinColor());
      }
      
      private function setItemSkin(param1:InventoryItemInfo, param2:String) : void
      {
         var _loc3_:Array = param1.Color.split("|");
         _loc3_[1] = param2;
         var _loc4_:String = _loc3_.join("|");
         param1.Skin = param2;
         this._model.self.setSkinColor(param2);
      }
      
      public function setInitColor() : void
      {
         this._model.self.setPartColor(this._model.currentItem.CategoryID,this._model.initColor);
         this._cell.itemInfo.Color = this._model.initColor;
      }
      
      public function setInitSkinColor() : void
      {
         this._model.self.setSkinColor(this._model.initSkinColor);
         this._cell.itemInfo.Skin = this._model.initSkinColor;
      }
      
      private function checkColorChanged(param1:String, param2:String) : Boolean
      {
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc3_:Array = param1.split("|");
         var _loc4_:Array = param2.split("|");
         var _loc5_:int = Math.max(_loc3_.length,_loc4_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = !StringHelper.isNullOrEmpty(_loc3_[_loc6_]) && _loc3_[_loc6_] != "undefined";
            _loc8_ = !StringHelper.isNullOrEmpty(_loc4_[_loc6_]) && _loc4_[_loc6_] != "undefined";
            if((_loc7_ || _loc8_) && _loc3_[_loc6_] != _loc4_[_loc6_])
            {
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      protected function __reductiveColor(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(this._colorEditor.selectedType == 1)
         {
            this.setItemColor(this._model.currentItem,"");
         }
         else
         {
            this.setItemSkin(this._model.currentItem,"");
         }
         if(this._cell.info)
         {
            _loc2_ = this.checkColorChanged(this._model.initColor,this._cell.itemInfo.Color);
            _loc3_ = this.checkColorChanged(this._model.initSkinColor,this._cell.itemInfo.Skin);
            if(_loc2_ || _loc3_)
            {
               this._model.changed = true;
            }
            else
            {
               this._model.changed = false;
            }
         }
         else
         {
            this._model.changed = false;
         }
      }
      
      private function updateCharator() : void
      {
         this._model.self.setPartStyle(this._model.currentItem.CategoryID,this._model.currentItem.NeedSex,this._model.currentItem.TemplateID,this._model.currentItem.Color);
         if(this._model.currentItem.CategoryID == EquipType.FACE || this._model.currentItem.Skin != "")
         {
            this._model.self.setSkinColor(this._cell.bagCell.itemInfo.Skin);
         }
         else
         {
            this._model.self.setSkinColor(this._model.self.getSkinColor());
         }
      }
      
      private function updateColorPanel() : void
      {
         var _loc1_:Array = null;
         if(this._cell.info == null)
         {
            this._colorEditor.skinEditable = false;
            this._colorEditor.colorEditable = false;
         }
         else
         {
            this._colorEditor.reset();
            _loc1_ = this._cell.itemInfo.Color.split("|");
            this._colorEditor.colorRestorable = _loc1_.length > this._cell.editLayer - 1 && !StringHelper.isNullOrEmpty(_loc1_[this._cell.editLayer - 1]) && _loc1_[this._cell.editLayer - 1] != "undefined";
            this._colorEditor.skinRestorable = !StringHelper.isNullOrEmpty(this._cell.itemInfo.Skin) && this._cell.itemInfo.Skin != "undefined";
            this._itemChanged = this._colorEditor.colorRestorable || this._colorEditor.skinRestorable;
            if(this._cell.info.CategoryID == EquipType.FACE)
            {
               if(EquipType.isEditable(this._cell.info))
               {
                  this._colorEditor.colorEditable = true;
               }
               this._colorEditor.skinEditable = true;
            }
            else
            {
               this._colorEditor.colorEditable = true;
            }
            this._colorEditor.editColor();
            if(!this._model.initColor)
            {
               this._model.initColor = this._cell.itemInfo.Color;
            }
            if(!this._model.initSkinColor)
            {
               this._model.initSkinColor = this._cell.itemInfo.Skin;
            }
            if(this._colorEditor.selectedType == 2)
            {
               this._colorEditor.editSkin();
            }
         }
         if(this._colorEditor.skinEditable == false)
         {
            this._colorEditor.selectedType = 1;
         }
         if(!this._colorEditor.colorEditable && this._colorEditor.skinEditable)
         {
            this._colorEditor.selectedType = 2;
         }
      }
   }
}
