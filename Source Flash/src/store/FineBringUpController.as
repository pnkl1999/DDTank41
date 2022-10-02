package store
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.socket.ePackageType;
   import ddt.events.CEvent;
   import ddt.events.PkgEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import store.fineStore.view.pageBringUp.FineBringUpAlertYESConfirm;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class FineBringUpController extends EventDispatcher
   {
      
      public static const UPDATE_ITEM_LOCK_STATUS:String = "bringup_item_lock_status";
      
      public static const UPDATE_LOCK_STATUS_LIST:String = "bringup_lock_status_list";
      
      public static const EAT_MOUSE_STATUS_CHANGE:String = "eat_mouse_status_change";
      
      protected static const All:String = "all";
      
      protected static const FIRST_ONE:String = "one";
      
      protected static const QUICK:String = "quick";
      
      protected static const ALL_LOW:String = "all_Low";
      
      protected static const ALL_REMAIN:String = "all_remain";
      
      private static var instance:FineBringUpController;
       
      
      private var _hasSetedup:Boolean = false;
      
      public var usingLock:Boolean = false;
      
      private var _needPlayMovie:Boolean = false;
      
      private var _eatBtnClk:Boolean = false;
      
      private var _state:String = "";
      
      private var _firstConfirm:Boolean = false;
      
      private var _placeMap:Dictionary;
      
      private var _needGuide:Boolean = true;
      
      private var _bagBringUpInfo:BagInfo;
      
      private var _tagItem:InventoryItemInfo;
      
      private var _tagTempleteItem:ItemTemplateInfo;
      
      private var _onSending:Boolean;
      
      private var expData:ExpData;
      
      private var _quickEatInfo:InventoryItemInfo;
      
      public function FineBringUpController(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : FineBringUpController
      {
         if(!instance)
         {
            instance = new FineBringUpController(new inner());
         }
         return instance;
      }
      
      public function get needPlayMovie() : Boolean
      {
         return this._needPlayMovie;
      }
      
      public function dispose() : void
      {
         this._placeMap = null;
         this._hasSetedup = false;
         SocketManager.Instance.removeEventListener(PkgEvent.format(ePackageType.EQUIP_BRING_UP),this.onBringUpEatResult);
      }
      
      public function setup() : void
      {
         if(this._hasSetedup)
         {
            return;
         }
         this._hasSetedup = true;
         this._onSending = false;
         this.expData = null;
         this._state = "";
         SocketManager.Instance.addEventListener(PkgEvent.format(ePackageType.EQUIP_BRING_UP),this.onBringUpEatResult);
      }
      
      protected function onBringUpEatResult(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         this._onSending = false;
         if(this._state == All || this._state == ALL_REMAIN || this._state == ALL_LOW)
         {
            this.eat(this._state);
         }
         else
         {
            this._onSending = false;
            this._needPlayMovie = false;
         }
         dispatchEvent(new CEvent(EAT_MOUSE_STATUS_CHANGE,"submited"));
      }
      
      public function alertIsMaxLevel() : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cannotBringUp"),0,false,1);
      }
      
      public function havePropertiesCanNotEaten(param1:InventoryItemInfo) : Boolean
      {
         if(param1.hasComposeAttribte)
         {
            return true;
         }
         return false;
      }
      
      public function alertHavePropertiesCanNotEaten() : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.bringup.canNotEatenProperties"),0,true,1);
      }
      
      public function eatBtnClick(param1:InventoryItemInfo, param2:InventoryItemInfo = null) : void
      {
         this._eatBtnClk = true;
         this.hideNewHandTip();
         if(this.havePropertiesCanNotEaten(param2))
         {
            this.alertHavePropertiesCanNotEaten();
            dispatchEvent(new CEvent(EAT_MOUSE_STATUS_CHANGE,"submited"));
            return;
         }
         this._tagItem = param1;
         this._tagTempleteItem = ItemManager.Instance.getTemplateById(param1.TemplateID);
         this._quickEatInfo = param2;
         if(param2 == null)
         {
            this._state = FIRST_ONE;
            this.eat(this._state);
         }
         else
         {
            this._state = QUICK;
            this.eat(this._state);
         }
      }
      
      public function eatAllBtnClick(param1:InventoryItemInfo) : void
      {
         this._eatBtnClk = true;
         this.hideNewHandTip();
         this._tagItem = param1;
         this._tagTempleteItem = ItemManager.Instance.getTemplateById(param1.TemplateID);
         this._state = All;
         this._firstConfirm = true;
         this.eat(this._state);
      }
      
      public function isMaxLevel(param1:InventoryItemInfo) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return param1.FusionType == 0;
      }
      
      private function eat(param1:String, param2:ExpData = null) : void
      {
         var alert:BaseAlerFrame = null;
         var level:int = 0;
         var _responseEatAll:Function = null;
         var onFirstShown:Function = null;
         var $state:String = param1;
         var $expData:ExpData = param2;
         alert = null;
         var msg:String = null;
         level = 0;
         _responseEatAll = null;
         onFirstShown = null;
         var aInfo:AlertInfo = null;
         var itemName:String = null;
         var spaceString:String = null;
         _responseEatAll = function(param1:FrameEvent):void
         {
            SoundManager.instance.play("008");
            (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,_responseEatAll);
            switch(param1.responseCode)
            {
               case FrameEvent.SUBMIT_CLICK:
               case FrameEvent.ENTER_CLICK:
                  switch(level)
                  {
                     case 0:
                        sendEat();
                        break;
                     case 1:
                     case 3:
                        sendEat();
                        break;
                     case 2:
                     case 4:
                     case 6:
                        if((alert as FineBringUpAlertYESConfirm).isYesCorrect())
                        {
                           if($state == All)
                           {
                              _state = ALL_REMAIN;
                           }
                           sendEat();
                        }
                        else
                        {
                           MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.bringup.confirmFailed"),0,false,1);
                        }
                  }
                  break;
               case FrameEvent.ESC_CLICK:
               case FrameEvent.CANCEL_CLICK:
                  if(_state == All && (level == 2 || level == 4 || level == 6))
                  {
                     if(_state == All)
                     {
                        _state = ALL_LOW;
                     }
                     eat(_state);
                  }
                  dispatchEvent(new CEvent(EAT_MOUSE_STATUS_CHANGE,"canceled"));
            }
            (param1.currentTarget as BaseAlerFrame).dispose();
         };
         onFirstShown = function(param1:FrameEvent):void
         {
            SoundManager.instance.play("008");
            (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,onFirstShown);
            switch(param1.responseCode)
            {
               case FrameEvent.SUBMIT_CLICK:
               case FrameEvent.ENTER_CLICK:
                  eat(_state,expData);
                  break;
               case FrameEvent.ESC_CLICK:
               case FrameEvent.CANCEL_CLICK:
                  _onSending = false;
                  expData = null;
                  _state = "";
            }
         };
         $expData == null && (this.expData = this.getExperienceList(this._tagItem,$state));
         if(this._firstConfirm)
         {
            this._firstConfirm = false;
            if(this.expData.experienceArr.length == 0)
            {
               msg = LanguageMgr.GetTranslation("tank.view.bagII.bringup.noneCanEat");
               MessageTipManager.getInstance().show(msg,0,true,1);
            }
            else
            {
               msg = LanguageMgr.GetTranslation("tank.view.bagII.bringup.eatAll",this._tagItem.Name,this.expData.totalExp);
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true);
               LayerManager.Instance.addToLayer(alert,0,true,LayerManager.BLCAK_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,onFirstShown);
            }
            return;
         }
         level = this.alertLevel();
         switch(level)
         {
            case 0:
               if($state == All || $state == ALL_LOW || $state == ALL_REMAIN)
               {
                  this.sendEat();
                  return;
               }
               msg = LanguageMgr.GetTranslation("tank.view.bagII.level1EatAll.alert",this.expData.nameArr[0],this.expData.experienceArr[0]);
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true);
               break;
            case 1:
               if($state == All || $state == ALL_LOW || $state == ALL_REMAIN)
               {
                  this.sendEat();
                  return;
               }
               msg = LanguageMgr.GetTranslation("tank.view.bagII.level1EatAll.alert",this.expData.nameArr[0],this.expData.experienceArr[0]);
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true);
               break;
            case 2:
            case 4:
            case 6:
               if($state == ALL_REMAIN)
               {
                  this.sendEat();
               }
               else
               {
                  if($state == ALL_LOW)
                  {
                     return;
                  }
                  alert = ComponentFactory.Instance.creatComponentByStylename("storeBringUp.confirmYesAlert");
                  aInfo = new AlertInfo(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,msg);
                  aInfo.enableHtml = true;
                  alert.info = aInfo;
                  itemName = "[" + this.expData.nameArr[0] + "]";
                  spaceString = Helpers.spaceString(itemName.length * 28,8);
                  msg = LanguageMgr.GetTranslation("tank.view.bagII.level2EatAll.alert",spaceString,this.expData.experienceArr[0]);
                  msg = level >= 4 ? msg + LanguageMgr.GetTranslation("tank.view.bagII.lostMuchExp") : msg;
                  (alert as FineBringUpAlertYESConfirm).upadteView(msg,itemName);
               }
         }
         LayerManager.Instance.addToLayer(alert,0,true,LayerManager.BLCAK_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,_responseEatAll);
      }
      
      private function sendEat() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._needPlayMovie = true;
         this._onSending = true;
         if(this.expData != null && this.expData.placeArr.length > 0)
         {
            _loc1_ = new Array();
            _loc2_ = this.expData.placeArr.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_.push(BagInfo.EQUIPBAG);
               _loc1_.push(this.expData.placeArr.shift());
               this.expData.experienceArr.shift();
               this.expData.nameArr.shift();
               _loc3_++;
            }
            GameInSocketOut.sendBringUpEat(_loc2_,_loc1_);
         }
         if(!this.expData || this.expData.placeArr.length <= 0)
         {
            this._onSending = false;
            this.expData = null;
            this._state = "";
         }
      }
      
      public function buyExp(param1:int, param2:int) : void
      {
         this._onSending = false;
         this.expData = null;
         this._state = "";
         GameInSocketOut.sendBringUpEat(0,param1,param2);
      }
      
      private function alertLevel() : int
      {
         var item:ItemTemplateInfo = null;
         item = null;
         var i:int = 0;
         var check:Function = function():void
         {
            __alertLevel = checkLevel(item);
         };
         var __alertLevel:int = 0;
         var list:Array = this._bagBringUpInfo.items.list;
         var len:int = list.length;
         if(this._state == QUICK)
         {
            item = ItemManager.Instance.getTemplateById(this._quickEatInfo.TemplateID);
            check();
         }
         else
         {
            i = 0;
            while(i < len)
            {
               if((list[i] as InventoryItemInfo).cellLocked != true)
               {
                  if(!this.havePropertiesCanNotEaten(list[i]))
                  {
                     item = ItemManager.Instance.getTemplateById((list[i] as InventoryItemInfo).TemplateID);
                     check();
                     if(__alertLevel >= 2)
                     {
                        break;
                     }
                  }
               }
               i++;
            }
         }
         return __alertLevel;
      }
      
      private function checkLevel(param1:ItemTemplateInfo) : int
      {
         var _loc2_:int = 0;
         if(int(param1.Property1) >= 4)
         {
            _loc2_ = 2 | _loc2_;
         }
         if(int(param1.Property3) > int(this._tagTempleteItem.Property3) && int(param1.Property1) >= 2)
         {
            _loc2_ = 4 | _loc2_;
         }
         return _loc2_;
      }
      
      private function getExperienceList(param1:InventoryItemInfo, param2:String) : ExpData
      {
         var obj:ExpData = null;
         var tagItemTempleteID:int = 0;
         var isAll:Boolean = false;
         var tagItem:InventoryItemInfo = param1;
         var type:String = param2;
         obj = null;
         tagItemTempleteID = 0;
         isAll = false;
         var search:Function = function():void
         {
            var _loc1_:InventoryItemInfo = null;
            var _loc2_:Number = NaN;
            var _loc3_:Array = _bagBringUpInfo.items.list;
            _loc3_.sortOn("Place",Array.NUMERIC);
            var _loc4_:int = _loc3_.length;
            var _loc5_:int = 0;
            while(_loc5_ < _loc4_)
            {
               _loc1_ = _loc3_[_loc5_] as InventoryItemInfo;
               if(_loc1_.cellLocked == false && _loc1_.getRemainDate() > 0 && tagItem.Place != _loc1_.Place)
               {
                  if(!havePropertiesCanNotEaten(_loc1_))
                  {
                     if(!(_state == ALL_LOW && checkLevel(_loc1_) > 1))
                     {
                        _loc2_ = calculateExperience(tagItemTempleteID,_loc1_);
                        obj.totalExp += _loc2_;
                        obj.experienceArr.push(_loc2_);
                        obj.placeArr.push(_loc1_.Place);
                        obj.nameArr.push(_loc1_.Name);
                        if(!isAll)
                        {
                           break;
                        }
                     }
                  }
               }
               _loc5_++;
            }
         };
         obj = new ExpData();
         tagItemTempleteID = tagItem.TemplateID;
         if(type == QUICK)
         {
            obj.totalExp = this.calculateExperience(tagItemTempleteID,this._quickEatInfo);
            obj.experienceArr.push(obj.totalExp);
            obj.nameArr.push(this._quickEatInfo.Name);
            obj.placeArr.push(this._quickEatInfo.Place);
            return obj;
         }
         isAll = type == All || type == ALL_LOW || type == ALL_REMAIN;
         search();
         return obj;
      }
      
      private function calculateExperience(param1:int, param2:InventoryItemInfo) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1);
         var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param2.TemplateID);
         var _loc6_:int = int(_loc4_.Property1);
         var _loc7_:int = int(_loc4_.Property3);
         var _loc8_:int = int(_loc5_.Property1);
         var _loc9_:int = int(_loc5_.Property2);
         var _loc10_:int = int(_loc5_.Property3);
         var _loc11_:int = param2.curExp;
         if(_loc7_ < _loc10_)
         {
            _loc5_ = this.getTempleteInfoByLevel(_loc8_,_loc4_);
            _loc9_ = int(_loc5_.Property2);
            _loc10_ = _loc7_;
            _loc11_ = _loc9_;
         }
         if(_loc11_ == 0)
         {
            _loc11_ = _loc9_;
         }
         return Number(_loc11_);
      }
      
      private function getTempleteInfoByLevel(param1:int, param2:ItemTemplateInfo) : ItemTemplateInfo
      {
         var _loc3_:int = int(param2.Property1);
         if(_loc3_ > param1)
         {
            while(_loc3_ > param1)
            {
               if(int(param2.Property4) == 0)
               {
                  break;
               }
               param2 = ItemManager.Instance.getTemplateById(int(param2.Property4));
               _loc3_ = int(param2.Property1);
            }
         }
         else if(_loc3_ < param1)
         {
            while(_loc3_ < param1)
            {
               if(param2.FusionType == 0)
               {
                  break;
               }
               param2 = ItemManager.Instance.getTemplateById(param2.FusionType);
               _loc3_ = int(param2.Property1);
            }
         }
         return param2;
      }
      
      public function getPlaceMap() : Dictionary
      {
         var _loc1_:InventoryItemInfo = null;
         if(this._placeMap != null)
         {
            return this._placeMap;
         }
         this.getCanBringUpData();
         this._placeMap = new Dictionary();
         var _loc2_:int = 0;
         for each(_loc1_ in this._bagBringUpInfo.items)
         {
            if(_loc1_.Place <= 15)
            {
               _loc1_.cellLocked = true;
               GameInSocketOut.sendBringUpLockStatusUpdate(_loc1_.BagType,_loc1_.Place,true);
            }
            this._placeMap[_loc2_] = _loc1_.Place;
            _loc2_++;
         }
         return this._placeMap;
      }
      
      public function getItem(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:DictionaryData = this._bagBringUpInfo.items;
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.Place == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getCanBringUpData() : BagInfo
      {
         var item:InventoryItemInfo = null;
         var __item:InventoryItemInfo = null;
         var isNotWeddingRing:Function = function(param1:InventoryItemInfo):Boolean
         {
            switch(param1.TemplateID)
            {
               case 9022:
               case 9122:
               case 9222:
               case 9322:
               case 9422:
               case 9522:
                  return false;
               default:
                  return true;
            }
         };
         var bagList:DictionaryData = PlayerManager.Instance.Self.Bag.items;
         this._bagBringUpInfo = new BagInfo(BagInfo.EQUIPBAG,21);
         for each(item in bagList)
         {
            if((item.CategoryID == 8 || item.CategoryID == 9) && isNotWeddingRing(item) && item.getRemainDate() > 0)
            {
               __item = new InventoryItemInfo();
               ObjectUtils.copyProperties(__item,item);
               this._bagBringUpInfo.addItem(__item);
            }
         }
         return this._bagBringUpInfo;
      }
      
      public function isTopLevel() : void
      {
         if(this._eatBtnClk)
         {
            this._eatBtnClk = false;
            return;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.bringup.isTopLevel"));
      }
      
      public function showNewHandTip() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(this.needGuide())
         {
            _loc1_ = LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER);
            NewHandContainer.Instance.showArrow(ArrowType.BRING_UP,135,new Point(447,538),"asset.trainer.bringupAsset","guide.bringup.btnPos",_loc1_,0,true);
         }
      }
      
      public function hideNewHandTip() : void
      {
         this._needGuide = false;
         NewHandContainer.Instance.clearArrowByID(ArrowType.BRING_UP);
      }
      
      public function progress(param1:InventoryItemInfo) : int
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1 == null)
         {
            return 0;
         }
         var _loc4_:int = ItemManager.Instance.getTemplateById(param1.TemplateID).FusionType;
         if(_loc4_ == 0)
         {
            return 0;
         }
         _loc2_ = int(ItemManager.Instance.getTemplateById(_loc4_).Property2);
         _loc3_ = int(param1.curExp);
         return _loc3_ / _loc2_ * 100;
      }
      
      public function expDataArr(param1:ItemTemplateInfo) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return [0,0];
         }
         if((param1 as InventoryItemInfo).curExp == 0)
         {
            _loc2_ = int(ItemManager.Instance.getTemplateById(param1.TemplateID).Property2);
         }
         else
         {
            _loc2_ = (param1 as InventoryItemInfo).curExp;
         }
         if(param1.FusionType == 0)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc3_ = int(ItemManager.Instance.getTemplateById(param1.FusionType).Property2);
         }
         return [_loc2_,_loc3_];
      }
      
      public function progressTipData(param1:ItemTemplateInfo) : String
      {
         var _loc2_:Array = this.expDataArr(param1);
         return _loc2_[0].toString() + "/" + _loc2_[1].toString();
      }
      
      public function needGuide() : Boolean
      {
         return this._needGuide;
      }
      
      public function get onSending() : Boolean
      {
         return this._onSending;
      }
   }
}

class inner
{
    
   
   function inner()
   {
      super();
   }
}

class ExpData
{
    
   
   public var totalExp:Number = 0;
   
   public var placeArr:Array;
   
   public var experienceArr:Array;
   
   public var nameArr:Array;
   
   function ExpData()
   {
      this.placeArr = new Array();
      this.experienceArr = new Array();
      this.nameArr = new Array();
      super();
   }
}
