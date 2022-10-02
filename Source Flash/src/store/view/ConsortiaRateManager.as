package store.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.analyze.ConsortionBuildingUseConditionAnalyer;
   import consortion.analyze.ConsortionListAnalyzer;
   import consortion.data.ConsortiaAssetLevelOffer;
   import ddt.data.ConsortiaInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import store.events.StoreIIEvent;
   
   public class ConsortiaRateManager extends EventDispatcher
   {
      
      public static var _instance:ConsortiaRateManager;
      
      public static const CHANGE_CONSORTIA:String = "loadComplete_consortia";
       
      
      private var _SmithLevel:int = 0;
      
      private var _data:String;
      
      private var _rate:int;
      
      private var _selfRich:int;
      
      private var _needRich:int = 100;
      
      public function ConsortiaRateManager()
      {
         super();
         this.initEvents();
      }
      
      public static function get instance() : ConsortiaRateManager
      {
         if(_instance == null)
         {
            _instance = new ConsortiaRateManager();
         }
         return _instance;
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._propertyChange);
      }
      
      private function __resultConsortiaEquipContro(param1:ConsortionBuildingUseConditionAnalyer) : void
      {
         var _loc4_:ConsortiaAssetLevelOffer = null;
         var _loc2_:int = param1.useConditionList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.useConditionList[_loc3_];
            if(_loc4_.Type == 2)
            {
               this.setStripTipDataRichs(_loc4_.Riches);
            }
            _loc3_++;
         }
      }
      
      private function __consortiaClubSearchResult(param1:ConsortionListAnalyzer) : void
      {
         var _loc2_:ConsortiaInfo = null;
         if(param1.consortionList.length > 0)
         {
            _loc2_ = param1.consortionList[0];
            if(_loc2_)
            {
               this._SmithLevel = _loc2_.SmithLevel;
            }
            this._rate = this._SmithLevel;
            this.setStripTipData();
         }
      }
      
      private function setStripTipData() : void
      {
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            if(this._SmithLevel <= 0)
            {
               this._loadComplete();
            }
            else
            {
               ConsortionModelControl.Instance.loadUseConditionList(this.__resultConsortiaEquipContro,PlayerManager.Instance.Self.ConsortiaID);
            }
         }
         else
         {
            this._loadComplete();
         }
      }
      
      private function setStripTipDataRichs(param1:int) : void
      {
         this._selfRich = PlayerManager.Instance.Self.RichesOffer + PlayerManager.Instance.Self.RichesRob;
         if(this._selfRich < param1)
         {
            this._rate = 0;
         }
         this._needRich = param1;
         this._loadComplete();
      }
      
      private function __onLoadErrorII(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),param1.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponseII);
      }
      
      private function __onAlertResponseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponseII);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function _propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["SmithLevel"])
         {
            this._SmithLevel = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
         }
         if(param1.changedProperties["RichesOffer"] || param1.changedProperties["RichesRob"])
         {
            this._selfRich = PlayerManager.Instance.Self.RichesOffer + PlayerManager.Instance.Self.RichesRob;
         }
         this._rate = this._SmithLevel;
         this._loadComplete();
      }
      
      public function reset() : void
      {
         this._SmithLevel = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
         this._selfRich = PlayerManager.Instance.Self.Riches;
         ConsortionModelControl.Instance.getConsortionList(this.__consortiaClubSearchResult,1,6,"",-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
      }
      
      public function get consortiaTipData() : String
      {
         this._rate = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel <= 0)
            {
               this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateIII");
            }
            else if(PlayerManager.Instance.Self.UseOffer < this._needRich)
            {
               this._rate = 0;
               this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateII",PlayerManager.Instance.Self.UseOffer,this._needRich);
            }
            else
            {
               this._data = LanguageMgr.GetTranslation("store.StoreIIComposeBG.consortiaRate_txt",PlayerManager.Instance.Self.consortiaInfo.SmithLevel * 10);
            }
         }
         else
         {
            this._rate = 0;
            this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
         }
         return this._data;
      }
      
      public function get smithLevel() : int
      {
         return PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
      }
      
      public function get rate() : int
      {
         this._rate = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel > 0 && PlayerManager.Instance.Self.UseOffer < this._needRich)
            {
               this._rate = 0;
            }
         }
         else
         {
            this._rate = 0;
         }
         return this._rate;
      }
      
      private function _loadComplete() : void
      {
         dispatchEvent(new Event(CHANGE_CONSORTIA));
      }
      
      public function sendTransferShowLightEvent(param1:ItemTemplateInfo, param2:Boolean) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.TRANSFER_LIGHT,param1,param2));
      }
      
      public function dispose() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._propertyChange);
      }
   }
}
