package farm.viewx.helper
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.modelx.FieldVO;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class HelperItem extends Sprite
   {
       
      
      private var _itemBG:ScaleFrameImage;
      
      private var _fieldVO:FieldVO;
      
      private var _fieldIndex:FilterFrameText;
      
      private var _SeedTxt:FilterFrameText;
      
      private var _SeedNumTxt:FilterFrameText;
      
      private var _FertilizerTxt:FilterFrameText;
      
      private var _FertilizerNumTxt:FilterFrameText;
      
      private var _cbxSeed:ComboBox;
      
      private var _cbxFertilizer:ComboBox;
      
      private var _btnIsAuto:BaseButton;
      
      private var _light:Scale9CornerImage;
      
      private var _seedInfos:Dictionary;
      
      private var _fertilizerInfos:Dictionary;
      
      private var _txtIsAutoArray:Array;
      
      private var _selectTipMsg:String;
      
      public var _isAutoFunction:Function;
      
      private var _btnState:Boolean;
      
      private var _currentFrame:int;
      
      private var _index:int;
      
      private var _isSelected:Boolean;
      
      private var _state:int;
      
      private var _findNumState:Function;
      
      private var _helperSetView:HelperSetView;
      
      public function HelperItem()
      {
         super();
      }
      
      public function initView(param1:int = 0) : void
      {
         buttonMode = true;
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("helperItem.BG");
         addChild(this._itemBG);
         this._fieldIndex = ComponentFactory.Instance.creatComponentByStylename("helperItem.fieldIndex");
         addChild(this._fieldIndex);
         this._state = param1;
         if(param1 != 0)
         {
            this._cbxSeed = ComponentFactory.Instance.creat("asset.ddtfarm.helper.seedDropListCombo");
            this._cbxFertilizer = ComponentFactory.Instance.creat("asset.ddtfarm.helper.filterFrameDropListCombo");
            this._SeedTxt = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedTxt");
            addChild(this._SeedTxt);
            this._SeedTxt.text = LanguageMgr.GetTranslation("ddt.fram.helperItem.Text");
            this._SeedNumTxt = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedNumTxt");
            addChild(this._SeedNumTxt);
            this._FertilizerTxt = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedTxt");
            addChild(this._FertilizerTxt);
            this._FertilizerTxt.text = LanguageMgr.GetTranslation("ddt.fram.helperItem.Text");
            PositionUtils.setPos(this._FertilizerTxt,"farm.helper.SeedTxtPos");
            this._FertilizerNumTxt = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedNumTxt");
            addChild(this._FertilizerNumTxt);
            PositionUtils.setPos(this._FertilizerNumTxt,"farm.helper.SeedTxtNumPos");
            this._btnIsAuto = ComponentFactory.Instance.creatComponentByStylename("helperItem.isAutoBtn");
            addChild(this._btnIsAuto);
            this._light = ComponentFactory.Instance.creatComponentByStylename("farm.helperListItem.light");
            addChild(this._light);
            this._light.mouseChildren = this._light.mouseEnabled = this._light.visible = false;
            this._txtIsAutoArray = [LanguageMgr.GetTranslation("ddt.farm.helperList.txtStart"),LanguageMgr.GetTranslation("ddt.farm.helperList.txtStop")];
            this._selectTipMsg = LanguageMgr.GetTranslation("ddt.fram.helperItem.Text");
            this.setSeedPanelData();
            this.setFertilizerPanelData();
            this.initEvent();
         }
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      private function initEvent() : void
      {
         this._btnIsAuto.addEventListener(MouseEvent.CLICK,this.__isAutoClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function __cbxSeedChange(param1:ListItemEvent) : void
      {
         if(this._cbxSeed.textField.text == this._selectTipMsg)
         {
            return;
         }
         if(!this.__seedItemClickCheck())
         {
            this._cbxSeed.textField.text = this._selectTipMsg;
         }
      }
      
      private function __fertilizerChange(param1:ListItemEvent) : void
      {
         if(this._cbxFertilizer.textField.text == this._selectTipMsg)
         {
            return;
         }
         if(!this.__fertilizerItemClickCheck())
         {
            this._cbxFertilizer.textField.text = this._selectTipMsg;
         }
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         this._light.visible = this._isSelected;
      }
      
      public function isSelelct(param1:Boolean) : void
      {
         if(this._light)
         {
            this._light.visible = this._isSelected = param1;
         }
      }
      
      public function getCellValue() : *
      {
         return this._fieldVO;
      }
      
      public function set btnState(param1:Boolean) : void
      {
         this._btnState = param1;
      }
      
      public function get btnState() : Boolean
      {
         return this._btnState;
      }
      
      public function get currentFertilizer() : String
      {
         return this._FertilizerTxt.text;
      }
      
      public function get currentFertilizerNum() : int
      {
         return int(this._FertilizerNumTxt.text);
      }
      
      public function get currentSeed() : String
      {
         return this._SeedTxt.text;
      }
      
      public function get currentSeedNum() : int
      {
         return int(this._SeedNumTxt.text);
      }
      
      public function get currentfindIndex() : int
      {
         return int(this._fieldIndex.text) - 1;
      }
      
      public function get currentFieldID() : int
      {
         return this._fieldVO.fieldID;
      }
      
      public function setCellValue(param1:*) : void
      {
         if(param1)
         {
            this._fieldVO = param1;
            this._fieldIndex.text = String(this._fieldVO.fieldID + 1);
            if(this._SeedTxt && this._FertilizerTxt)
            {
               if(this._fieldVO.autoSeedID == 0)
               {
                  this._SeedTxt.text = this._selectTipMsg;
                  this._SeedNumTxt.text = this._fieldVO.autoSeedIDCount.toString();
               }
               else
               {
                  this._SeedTxt.text = ItemManager.Instance.getTemplateById(this._fieldVO.autoSeedID).Name;
                  this._SeedNumTxt.text = this._fieldVO.autoSeedIDCount.toString();
               }
               if(this._fieldVO.autoFertilizerID == 0)
               {
                  this._FertilizerTxt.text = this._selectTipMsg;
                  this._FertilizerNumTxt.text = this._fieldVO.autoFertilizerCount.toString();
               }
               else
               {
                  this._FertilizerTxt.text = ItemManager.Instance.getTemplateById(this._fieldVO.autoFertilizerID).Name;
                  this._FertilizerNumTxt.text = this._fieldVO.autoFertilizerCount.toString();
               }
               this.btnState = !this._fieldVO.isAutomatic;
               if(this._fieldVO.isAutomatic)
               {
                  this._currentFrame = 2;
                  this._btnIsAuto.enable = false;
                  this._itemBG.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                  this._itemBG.setFrame(1);
               }
               else
               {
                  this._currentFrame = 1;
                  this._btnIsAuto.enable = true;
                  this._itemBG.filters = ComponentFactory.Instance.creatFilters("lightFilter");
                  this._itemBG.setFrame(1);
               }
            }
         }
      }
      
      private function setDropListClickable(param1:Boolean) : void
      {
         this._cbxSeed.enable = param1;
         this._cbxFertilizer.enable = param1;
      }
      
      private function setSeedPanelData() : void
      {
         var _loc4_:ShopItemInfo = null;
         this._seedInfos = new Dictionary();
         this._cbxSeed.beginChanges();
         var _loc1_:VectorListModel = this._cbxSeed.listPanel.vectorListModel;
         _loc1_.clear();
         _loc1_.append(this._selectTipMsg);
         var _loc2_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            this._seedInfos[_loc4_.TemplateInfo.Name] = _loc4_.TemplateInfo.TemplateID;
            _loc1_.append(_loc4_.TemplateInfo.Name);
            _loc3_++;
         }
         this._cbxSeed.commitChanges();
      }
      
      private function setFertilizerPanelData() : void
      {
         var _loc4_:ShopItemInfo = null;
         this._fertilizerInfos = new Dictionary();
         this._cbxFertilizer.beginChanges();
         var _loc1_:VectorListModel = this._cbxFertilizer.listPanel.vectorListModel;
         _loc1_.clear();
         _loc1_.append(this._selectTipMsg);
         var _loc2_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            this._fertilizerInfos[_loc4_.TemplateInfo.Name] = _loc4_.TemplateInfo.TemplateID;
            _loc1_.append(_loc4_.TemplateInfo.Name);
            _loc3_++;
         }
         this._cbxFertilizer.commitChanges();
      }
      
      private function __seedCheck() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc1_:Boolean = true;
         if(this._seedInfos.hasOwnProperty(this._SeedTxt.text))
         {
            _loc2_ = this._seedInfos[this._SeedTxt.text];
            _loc3_ = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED);
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.TemplateID == _loc2_)
               {
                  if(_loc4_.Count > 0)
                  {
                     _loc1_ = true;
                  }
                  break;
               }
            }
         }
         return _loc1_;
      }
      
      public function set findNumState(param1:Function) : void
      {
         this._findNumState = param1;
      }
      
      private function __seedItemClickCheck() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc1_:Boolean = false;
         if(this._seedInfos.hasOwnProperty(this._SeedTxt.text))
         {
            _loc2_ = this._seedInfos[this._SeedTxt.text];
            _loc3_ = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED);
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.TemplateID == _loc2_)
               {
                  if(_loc4_.Count > 0)
                  {
                     _loc1_ = true;
                  }
                  break;
               }
            }
            if(!_loc1_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.selectSeedFail"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.pleaseSelectSeed"));
         }
         return _loc1_;
      }
      
      private function __fertilizerItemClickCheck() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc1_:Boolean = false;
         if(this._fertilizerInfos.hasOwnProperty(this._cbxFertilizer.textField.text))
         {
            _loc2_ = this._fertilizerInfos[this._cbxFertilizer.textField.text];
            _loc3_ = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.MANURE);
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.TemplateID == _loc2_)
               {
                  if(_loc4_.Count > 0)
                  {
                     _loc1_ = true;
                  }
                  break;
               }
            }
            if(!_loc1_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.selectFertilizerFail"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.pleaseSelectSeedI"));
         }
         return _loc1_;
      }
      
      private function __isAutoClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helperSetView = ComponentFactory.Instance.creatComponentByStylename("farm.helperSetView.helper");
         this._helperSetView.helperSetViewSelectResult = this.__helperSetViewSelect;
         this._helperSetView.update(this._SeedTxt,this._SeedNumTxt,this._FertilizerTxt,this._FertilizerNumTxt);
         this._helperSetView.findNumState = this._findNumState;
         this._helperSetView.show();
      }
      
      private function __helperSetViewSelect(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ItemTemplateInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ItemTemplateInfo = null;
         if(param1.isSeed)
         {
            _loc2_ = int(param1.seedId);
            _loc3_ = int(param1.seedNum);
            _loc4_ = ItemManager.Instance.getTemplateById(_loc2_);
            this._SeedTxt.text = _loc4_.Name;
            this._SeedNumTxt.text = _loc3_.toString();
         }
         else
         {
            this._SeedTxt.text = this._selectTipMsg;
            this._SeedNumTxt.text = "0";
         }
         if(param1.isManure)
         {
            _loc5_ = int(param1.manureId);
            _loc6_ = int(param1.manureNum);
            _loc7_ = ItemManager.Instance.getTemplateById(_loc5_);
            this._FertilizerTxt.text = _loc7_.Name;
            this._FertilizerNumTxt.text = _loc6_.toString();
         }
         else
         {
            this._FertilizerTxt.text = this._selectTipMsg;
            this._FertilizerNumTxt.text = "0";
         }
      }
      
      public function get getSetViewItemData() : Object
      {
         var _loc1_:Object = null;
         if(this._helperSetView)
         {
            _loc1_ = {};
            _loc1_.currentSeedText = this._helperSetView.getTxtId1;
            _loc1_.currentSeedNum = this._helperSetView.getTxtNum1;
            _loc1_.currentFertilizerText = this._helperSetView.getTxtId2;
            _loc1_.currentFertilizerNum = this._helperSetView.getTxtNum2;
         }
         return _loc1_;
      }
      
      public function get getItemData() : Object
      {
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         var _loc1_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc6_ = _loc1_[_loc2_];
            this._seedInfos[_loc6_.TemplateInfo.Name] = _loc6_.TemplateInfo.TemplateID;
            _loc2_++;
         }
         var _loc3_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc4_];
            this._fertilizerInfos[_loc7_.TemplateInfo.Name] = _loc7_.TemplateInfo.TemplateID;
            _loc4_++;
         }
         var _loc5_:Object = {};
         _loc5_.currentfindIndex = this.currentfindIndex;
         if(this.currentSeed == this._selectTipMsg)
         {
            _loc5_.currentSeedText = 0;
         }
         else
         {
            _loc5_.currentSeedText = this._seedInfos[this.currentSeed];
         }
         if(this.currentFertilizer == this._selectTipMsg)
         {
            _loc5_.currentFertilizerText = 0;
         }
         else
         {
            _loc5_.currentFertilizerText = this._fertilizerInfos[this.currentFertilizer];
         }
         _loc5_.currentSeedNum = this.currentSeedNum;
         _loc5_.autoFertilizerNum = this.currentFertilizerNum;
         return _loc5_;
      }
      
      public function onKeyStart() : Boolean
      {
         if(!this._fieldVO.isDig)
         {
            return false;
         }
         if(this._state == 0 || !this.btnState || !this.__seedCheck())
         {
            return false;
         }
         var _loc1_:int = int(this._fieldIndex.text) - 1;
         var _loc2_:int = 0;
         if(this._SeedTxt.text != this._selectTipMsg && this._seedInfos.hasOwnProperty(this._SeedTxt.text))
         {
            _loc2_ = this._seedInfos[this._SeedTxt.text];
         }
         var _loc3_:int = 0;
         if(this._fertilizerInfos.hasOwnProperty(this._FertilizerTxt.text))
         {
            _loc3_ = this._fertilizerInfos[this._FertilizerTxt.text];
         }
         if(_loc2_ > 0)
         {
            return true;
         }
         return true;
      }
      
      public function onKeyStop() : Boolean
      {
         if(!this._fieldVO.isDig)
         {
            return false;
         }
         if(this._state == 0 || this.btnState)
         {
            return false;
         }
         var _loc1_:int = int(this._fieldIndex.text) - 1;
         var _loc2_:int = 0;
         if(this._seedInfos.hasOwnProperty(this._SeedTxt.text))
         {
            _loc2_ = this._seedInfos[this._SeedTxt.text];
         }
         var _loc3_:int = 0;
         if(this._fertilizerInfos.hasOwnProperty(this._FertilizerTxt.text))
         {
            _loc3_ = this._fertilizerInfos[this._FertilizerTxt.text];
         }
         return true;
      }
      
      private function removeEvent() : void
      {
         if(this._btnIsAuto)
         {
            this._btnIsAuto.removeEventListener(MouseEvent.CLICK,this.__isAutoClick);
         }
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         if(this._cbxSeed)
         {
            this._cbxSeed.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__cbxSeedChange);
         }
         if(this._cbxFertilizer)
         {
            this._cbxFertilizer.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__fertilizerChange);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._itemBG)
         {
            ObjectUtils.disposeObject(this._itemBG);
         }
         this._itemBG = null;
         if(this._fieldIndex)
         {
            ObjectUtils.disposeObject(this._fieldIndex);
         }
         this._fieldIndex = null;
         if(this._cbxSeed)
         {
            this._cbxSeed.dispose();
         }
         this._cbxSeed = null;
         if(this._cbxFertilizer)
         {
            this._cbxFertilizer.dispose();
         }
         this._cbxFertilizer = null;
         if(this._btnIsAuto)
         {
            ObjectUtils.disposeObject(this._btnIsAuto);
         }
         this._btnIsAuto = null;
         ObjectUtils.disposeAllChildren(this);
         this._findNumState = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
