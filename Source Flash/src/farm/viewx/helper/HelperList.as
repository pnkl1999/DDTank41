package farm.viewx.helper
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class HelperList extends Sprite implements Disposeable
   {
       
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _helperListBG:MovieClip;
      
      private var _helperListVLine:MutipleImage;
      
      private var _fieldIndex:BaseButton;
      
      private var _seedID:BaseButton;
      
      private var _fertilizerID:BaseButton;
      
      private var _isAuto:BaseButton;
      
      private var _fieldIndexText:FilterFrameText;
      
      private var _seedIDText:FilterFrameText;
      
      private var _fertilizerIDText:FilterFrameText;
      
      private var _isAutoText:FilterFrameText;
      
      private var _seedInfos:Dictionary;
      
      private var _fertilizerInfos:Dictionary;
      
      private var _helperItemList:Array;
      
      private var _currentSelectHelperItem:HelperItem;
      
      public function HelperList()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._helperListBG = ClassUtils.CreatInstance("assets.farm.helperPanelBg");
         this._helperListVLine = ComponentFactory.Instance.creatComponentByStylename("farm.helperListVLine");
         this._fieldIndex = ComponentFactory.Instance.creatComponentByStylename("helperList.fieldIndex");
         this._seedID = ComponentFactory.Instance.creatComponentByStylename("helperList.seedID");
         this._fertilizerID = ComponentFactory.Instance.creatComponentByStylename("helperList.fertilizerID");
         this._isAuto = ComponentFactory.Instance.creatComponentByStylename("helperList.isAuto");
         this._fieldIndexText = ComponentFactory.Instance.creatComponentByStylename("helperList.fieldIndexText");
         this._seedIDText = ComponentFactory.Instance.creatComponentByStylename("helperList.seedIDText");
         this._fertilizerIDText = ComponentFactory.Instance.creatComponentByStylename("helperList.fertilizerIDText");
         this._isAutoText = ComponentFactory.Instance.creatComponentByStylename("helperList.isAutoText");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperList.listVbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperList.listScrollPanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._helperListBG);
         addChild(this._helperListVLine);
         addChild(this._fieldIndex);
         addChild(this._seedID);
         addChild(this._fertilizerID);
         addChild(this._isAuto);
         addChild(this._fieldIndexText);
         addChild(this._seedIDText);
         addChild(this._fertilizerIDText);
         addChild(this._isAutoText);
         addChild(this._vbox);
         addChild(this._scrollPanel);
         this._fieldIndexText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.fieldIndexText");
         this._seedIDText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.seedIDText");
         this._fertilizerIDText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.fertilizerIDText");
         this._isAutoText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.isAutoText");
         this.setTip(this._fieldIndex,this._fieldIndexText.text);
         this.setTip(this._seedID,this._seedIDText.text);
         this.setTip(this._fertilizerID,this._fertilizerIDText.text);
         this.setTip(this._isAuto,this._isAutoText.text);
         this.setListData();
      }
      
      private function setTip(param1:BaseButton, param2:String) : void
      {
         param1.tipStyle = "ddt.view.tips.OneLineTip";
         param1.tipDirctions = "0";
         param1.tipData = param2;
      }
      
      public function get helperItemList() : Array
      {
         return this._helperItemList;
      }
      
      private function findNumState(param1:int, param2:int) : int
      {
         var _loc6_:HelperItem = null;
         var _loc7_:InventoryItemInfo = null;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in this._helperItemList)
         {
            _loc9_ = _loc6_.getSetViewItemData;
            if(!_loc9_)
            {
               _loc9_ = _loc6_.getItemData;
            }
            _loc10_ = int(_loc9_.currentSeedText);
            if(param1 > 0 && _loc10_ == param1)
            {
               _loc4_ += int(_loc9_.currentSeedNum);
            }
            _loc11_ = int(_loc9_.currentFertilizerText);
            if(param2 > 0 && _loc11_ == param2)
            {
               _loc5_ += int(_loc9_.currentFertilizerNum);
            }
         }
         _loc7_ = FarmModelController.instance.model.findItemInfo(EquipType.SEED,param1);
         if(_loc7_ && _loc4_ > _loc7_.Count)
         {
            _loc3_ = 1;
         }
         var _loc8_:InventoryItemInfo = FarmModelController.instance.model.findItemInfo(EquipType.MANURE,param2);
         if(_loc8_ && _loc5_ > _loc8_.Count)
         {
            _loc3_ = 2;
         }
         return _loc3_;
      }
      
      private function setListData() : void
      {
         var _loc8_:HelperItem = null;
         var _loc9_:FieldVO = null;
         var _loc10_:ShopItemInfo = null;
         var _loc11_:ShopItemInfo = null;
         this._vbox.disposeAllChildren();
         this._helperItemList = [];
         var _loc1_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         var _loc2_:int = !!Boolean(_loc1_) ? int(int(_loc1_.length)) : int(int(0));
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc8_ = new HelperItem();
            _loc8_.addEventListener(MouseEvent.CLICK,this.__onItemClickHandler);
            _loc8_.findNumState = this.findNumState;
            _loc8_.index = _loc3_;
            _loc9_ = null;
            _loc9_ = _loc1_[_loc3_];
            if(_loc9_.isDig)
            {
               _loc8_.initView(1);
               _loc8_.setCellValue(_loc9_);
               this._helperItemList.push(_loc8_);
               this._vbox.addChild(_loc8_);
            }
            _loc3_++;
         }
         this._scrollPanel.invalidateViewport();
         this._seedInfos = new Dictionary();
         this._fertilizerInfos = new Dictionary();
         var _loc4_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         var _loc5_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc10_ = _loc4_[_loc6_];
            this._seedInfos[_loc10_.TemplateInfo.Name] = _loc10_.TemplateInfo.TemplateID;
            _loc6_++;
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            _loc11_ = _loc5_[_loc7_];
            this._fertilizerInfos[_loc11_.TemplateInfo.Name] = _loc11_.TemplateInfo.TemplateID;
            _loc7_++;
         }
      }
      
      public function onKeyStart() : void
      {
         var _loc2_:HelperItem = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._helperItemList)
         {
            if(_loc2_.onKeyStart())
            {
               _loc1_.push(_loc2_.getItemData);
            }
         }
         if(_loc1_.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.onKeyStartFail"));
         }
         else
         {
            FarmModelController.instance.farmHelperSetSwitch(_loc1_,true);
         }
      }
      
      public function onKeyStop() : void
      {
         var _loc2_:HelperItem = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._helperItemList)
         {
            if(_loc2_.onKeyStop())
            {
               _loc1_.push(_loc2_.getItemData);
            }
         }
         if(_loc1_.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.onKeyStopFail"));
         }
         else
         {
            FarmModelController.instance.farmHelperSetSwitch(_loc1_,false);
         }
      }
      
      private function __onItemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:HelperItem = HelperItem(param1.currentTarget);
         _loc2_.isSelelct(true);
         if(this._currentSelectHelperItem && this._currentSelectHelperItem != _loc2_)
         {
            this._currentSelectHelperItem.isSelelct(false);
         }
         this._currentSelectHelperItem = _loc2_;
      }
      
      private function initEvent() : void
      {
         FarmModelController.instance.addEventListener(FarmEvent.HELPER_SWITCH_FIELD,this.__helperSwitchHandler);
         FarmModelController.instance.addEventListener(FarmEvent.HELPER_KEY_FIELD,this.__helperKeyHandler);
      }
      
      private function __helperSwitchHandler(param1:FarmEvent) : void
      {
         var _loc2_:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.isAutoId);
         if(_loc2_.isDig)
         {
            HelperItem(this.getHelperItem(_loc2_.fieldID)).setCellValue(_loc2_);
         }
         FarmModelController.instance.model.dispatchEvent(new FarmEvent(FarmEvent.UPDATE_HELPERISAUTO));
      }
      
      private function __helperKeyHandler(param1:FarmEvent) : void
      {
         var _loc3_:FieldVO = null;
         var _loc2_:int = 0;
         while(_loc2_ < FarmModelController.instance.model.batchFieldIDArray.length)
         {
            _loc3_ = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.batchFieldIDArray[_loc2_]);
            if(_loc3_.isDig)
            {
               HelperItem(this.getHelperItem(_loc3_.fieldID)).setCellValue(_loc3_);
            }
            _loc2_++;
         }
         FarmModelController.instance.model.dispatchEvent(new FarmEvent(FarmEvent.UPDATE_HELPERISAUTO));
      }
      
      public function getHelperItem(param1:int) : HelperItem
      {
         var _loc2_:HelperItem = null;
         for each(_loc2_ in this._helperItemList)
         {
            if(_loc2_.currentFieldID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function dispose() : void
      {
         var _loc1_:HelperItem = null;
         FarmModelController.instance.removeEventListener(FarmEvent.HELPER_SWITCH_FIELD,this.__helperSwitchHandler);
         FarmModelController.instance.removeEventListener(FarmEvent.HELPER_KEY_FIELD,this.__helperKeyHandler);
         if(this._helperItemList)
         {
            for each(_loc1_ in this._helperItemList)
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,this.__onItemClickHandler);
               _loc1_.dispose();
            }
            this._helperItemList = null;
         }
         if(this._vbox)
         {
            this._vbox.disposeAllChildren();
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(this._helperListBG)
         {
            ObjectUtils.disposeObject(this._helperListBG);
         }
         this._helperListBG = null;
         if(this._scrollPanel)
         {
            ObjectUtils.disposeObject(this._scrollPanel);
         }
         this._scrollPanel = null;
         if(this._fieldIndex)
         {
            ObjectUtils.disposeObject(this._fieldIndex);
         }
         this._fieldIndex = null;
         if(this._seedID)
         {
            ObjectUtils.disposeObject(this._seedID);
         }
         this._seedID = null;
         if(this._fertilizerID)
         {
            ObjectUtils.disposeObject(this._fertilizerID);
         }
         this._fertilizerID = null;
         if(this._isAuto)
         {
            ObjectUtils.disposeObject(this._isAuto);
         }
         this._isAuto = null;
         if(this._fieldIndexText)
         {
            ObjectUtils.disposeObject(this._fieldIndexText);
         }
         this._fieldIndexText = null;
         if(this._seedIDText)
         {
            ObjectUtils.disposeObject(this._seedIDText);
         }
         this._seedIDText = null;
         if(this._fertilizerIDText)
         {
            ObjectUtils.disposeObject(this._fertilizerIDText);
         }
         this._fertilizerIDText = null;
         if(this._isAutoText)
         {
            ObjectUtils.disposeObject(this._isAutoText);
         }
         this._isAutoText = null;
         ObjectUtils.disposeAllChildren(this);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
