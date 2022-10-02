package bagAndInfo
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.info.PlayerInfoView;
   import cardSystem.data.CardInfo;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.view.PetsBagOutView;
   import texpSystem.view.TexpView;
   
   public class BagAndInfoFrame extends Sprite implements Disposeable
   {
       
      
      private var _info:SelfInfo;
      
      private var _infoView:PlayerInfoView;
      
      private var _texpView:TexpView;
      
      private var _bagView:BagView;
      
      private var _petsView:PetsBagOutView;
      
      private var _bankBtn:SimpleBitmapButton;
      
      private var _visible:Boolean = false;
      
      public function BagAndInfoFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bagView = ComponentFactory.Instance.creatCustomObject("bagFrameBagView");
         addChild(this._bagView);
         this._infoView = ComponentFactory.Instance.creatCustomObject("bagAndInfoPersonalInfoView");
         this._infoView.showSelfOperation = true;
         addChild(this._infoView);
         this._bankBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.selfBankBagBtn");
         addChild(this._bankBtn);
      }
      
      private function initEvents() : void
      {
         this._bagView.addEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bagView.addEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bagView.addEventListener(BagView.TABCHANGE,this.__changeHandler);
         this._bankBtn.addEventListener("click",this.__onClickBank);
      }
      
      private function removeEvents() : void
      {
         this._bagView.removeEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bagView.removeEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bagView.removeEventListener(BagView.TABCHANGE,this.__changeHandler);
         this._bankBtn.addEventListener("click",this.__onClickBank);
      }
      
      public function set isScreenFood(param1:Boolean) : void
      {
         this._bagView.isScreenFood = param1;
      }
      
      protected function __onClickBank(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener("close",this.__onClose);
         UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.__activeComplete);
         UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.__activeProgress);
         UIModuleLoader.Instance.addUIModuleImp("bank");
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__activeComplete);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__activeProgress);
      }
      
      private function __activeProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __activeComplete(param1:UIModuleEvent) : void
      {
         var _loc2_:* = null;
         if(param1.module == "bank")
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
            UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__activeProgress);
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__activeComplete);
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("BankFrame");
            LayerManager.Instance.addToLayer(_loc2_,3,true,1);
            BagAndInfoManager.Instance.hideBagAndInfo();
         }
      }
      
      public function switchShow(param1:int) : void
      {
         this.info = PlayerManager.Instance.Self;
         if(param1 == BagAndGiftFrame.BAGANDINFO)
         {
            if(this._texpView)
            {
               this._texpView.visible = false;
            }
            if(this._petsView)
            {
               this._petsView.visible = false;
            }
            this.bagType = BagView.EQUIP;
            this._bagView.isNeedCard(true);
            this._bagView.sortBagEnable = true;
            this._bagView.breakBtnEnable = true;
            this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("lightFilter");
            this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("lightFilter");
            this._infoView.visible = true;
         }
         else if(param1 == BagAndGiftFrame.TEXPVIEW)
         {
            this._infoView.visible = false;
            this._bagView.isNeedCard(false);
            this._bagView.sortBagEnable = false;
            this._bagView.breakBtnEnable = false;
            this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this.showTexpView();
         }
         else if(param1 == BagAndGiftFrame.PETVIEW)
         {
            this._infoView.visible = false;
            this._bagView.isNeedCard(false);
            this._bagView.sortBagEnable = false;
            this._bagView.breakBtnEnable = false;
            this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this.showPetsView();
         }
      }
      
      public function clearTexpInfo() : void
      {
         if(this._texpView)
         {
            this._texpView.clearInfo();
         }
         if(this._petsView)
         {
            this._petsView.clearInfo();
         }
      }
      
      private function showTexpView() : void
      {
         try
         {
            if(this._texpView == null)
            {
               this._texpView = ComponentFactory.Instance.creatCustomObject("texpSystem.main");
               addChild(this._texpView);
            }
            if(this._petsView)
            {
               this._petsView.visible = false;
            }
            this.bagType = BagView.PROP;
            this._texpView.visible = true;
            return;
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TEXP_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createTexp);
            return;
         }
      }
      
      private function __createTexp(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TEXP_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createTexp);
            this.showTexpView();
         }
      }
      
      private function showPetsView() : void
      {
         try
         {
            if(this._petsView == null)
            {
               this._petsView = ComponentFactory.Instance.creatCustomObject("petsBagOutPnl");
               addChild(this._petsView);
            }
            if(this._texpView)
            {
               this._texpView.visible = false;
            }
            this.bagType = BagView.PET;
            this._petsView.visible = true;
            this._petsView.infoPlayer = PlayerManager.Instance.Self;
            PetBagController.instance().view = this._petsView;
            return;
         }
         catch(e:Error)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,__onPetsSmallLoadingClose);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.PETS_BAG);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createPets);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__onPetsUIProgress);
            return;
         }
      }
      
      private function __createPets(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onPetsSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onPetsUIProgress);
            this.showPetsView();
         }
      }
      
      private function __onPetsSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onPetsSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onPetsUIProgress);
      }
      
      private function __onPetsUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __changeHandler(param1:Event) : void
      {
         this._infoView.switchShow(this._bagView.bagType == BagView.CARD);
      }
      
      private function __stopShine(param1:CellEvent) : void
      {
         this._infoView.stopShine();
         if(this._texpView)
         {
            this._texpView.stopShine();
         }
         if(this._petsView)
         {
            this._petsView.stopShine();
            this._petsView.stopShined(0);
            this._petsView.stopShined(1);
            this._petsView.stopShined(2);
         }
      }
      
      private function __startShine(param1:CellEvent) : void
      {
         if(param1.data is ItemTemplateInfo)
         {
            if((param1.data as ItemTemplateInfo).CategoryID == EquipType.TEXP)
            {
               if(this._texpView)
               {
                  this._texpView.startShine();
               }
            }
            else if((param1.data as ItemTemplateInfo).CategoryID == EquipType.FOOD)
            {
               if(this._petsView)
               {
                  this._petsView.startShine();
               }
            }
            else if((param1.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_ARM)
            {
               if(this._petsView)
               {
                  this._petsView.playShined(0);
               }
            }
            else if((param1.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_CLOTH)
            {
               if(this._petsView)
               {
                  this._petsView.playShined(2);
               }
            }
            else if((param1.data as ItemTemplateInfo).CategoryID == EquipType.PET_EQUIP_HEAD)
            {
               if(this._petsView)
               {
                  this._petsView.playShined(1);
               }
            }
            else
            {
               this._infoView.startShine(param1.data as ItemTemplateInfo);
            }
         }
         else if(param1.data is CardInfo)
         {
            this._infoView.cardEquipShine(param1.data as CardInfo);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bankBtn);
         this._bankBtn = null;
         if(this._texpView)
         {
            this._texpView.dispose();
            this._texpView = null;
         }
         this._bagView.dispose();
         this._bagView = null;
         this._infoView.dispose();
         this._infoView = null;
         this._info = null;
         if(this._petsView)
         {
            this._petsView.dispose();
            this._petsView = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get info() : SelfInfo
      {
         return this._info;
      }
      
      public function set info(param1:SelfInfo) : void
      {
         this._info = param1;
         this._infoView.info = param1;
         this._bagView.info = param1;
         this._infoView.allowLvIconClick();
      }
      
      public function set bagType(param1:int) : void
      {
         this._bagView.setBagType(param1);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}
