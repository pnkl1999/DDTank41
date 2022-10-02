package store
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.events.ChoosePanelEvnet;
   import store.events.StoreIIEvent;
   import store.view.Compose.StoreIIComposeBG;
   import store.view.embed.StoreEmbedBG;
   import store.view.fusion.StoreIIFusionBG;
   import store.view.strength.StoreIIStrengthBG;
   import store.view.transfer.StoreIITransferBG;
   
   public class StoreMainView extends Sprite implements Disposeable
   {
      
      public static const STRENGTH:int = 0;
      
      public static const COMPOSE:int = 1;
      
      public static const FUSION:int = 2;
      
      public static const LIANGHUA:int = 4;
      
      public static const EMBED:int = 3;
      
      public static const TRANSF:int = 5;
      
      public static const EXALT:int = 6;
      
      public static const WISHBEAD:int = 7;
	  
	  public static const LatentEnergy:int = 8;
	  
	  public static const GemStone:int = 9;
      
      private static var _instance:StoreMainView;
       
      
      private var _composePanel:StoreIIComposeBG;
      
      private var _strengthPanel:StoreIIStrengthBG;
      
      private var _fusionPanel:StoreIIFusionBG;
      
      private var _embedPanel:StoreEmbedBG;
      
      private var _transferPanel:StoreIITransferBG;
      
      private var _currentPanelIndex:int;
      
      private var strength_btn:BaseButton;
      
      private var compose_btn:BaseButton;
      
      private var fusion_btn:BaseButton;
      
      private var embed_btn:BaseButton;
      
      private var transf_Btn:BaseButton;
      
      private var bg:ScaleFrameImage;
      
      private var _embedBtn_shine:MovieImage;
      
      public var panelIndex:int;
      
      public function StoreMainView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      public static function get instance() : StoreMainView
      {
         if(_instance == null)
         {
            _instance = new StoreMainView();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.bg = ComponentFactory.Instance.creatComponentByStylename("store.MainViewBG");
         addChild(this.bg);
         this.strength_btn = ComponentFactory.Instance.creatComponentByStylename("store.strength_btn");
         addChild(this.strength_btn);
         this.compose_btn = ComponentFactory.Instance.creatComponentByStylename("store.compose_btn");
         addChild(this.compose_btn);
         this.fusion_btn = ComponentFactory.Instance.creatComponentByStylename("store.fusion_btn");
         addChild(this.fusion_btn);
         this.embed_btn = ComponentFactory.Instance.creatComponentByStylename("store.embed_btn");
         addChild(this.embed_btn);
         this.transf_Btn = ComponentFactory.Instance.creatComponentByStylename("store.transf_Btn");
         addChild(this.transf_Btn);
         this._embedBtn_shine = ComponentFactory.Instance.creatComponentByStylename("store.embed_btnMC");
         addChild(this._embedBtn_shine);
         this._strengthPanel = ComponentFactory.Instance.creatCustomObject("store.StoreIIStrengthBG");
         this._composePanel = ComponentFactory.Instance.creatCustomObject("store.StoreIICompose");
         this._transferPanel = ComponentFactory.Instance.creatCustomObject("store.StoreIITransfer");
         this._fusionPanel = ComponentFactory.Instance.creatCustomObject("store.StoreIIFusionBG");
         this._embedPanel = ComponentFactory.Instance.creatCustomObject("store.StoreEmbedBG");
         addChild(this._strengthPanel);
         this._strengthPanel.show();
         this._currentPanelIndex = STRENGTH;
         addChild(this._composePanel);
         addChild(this._transferPanel);
         addChild(this._fusionPanel);
         addChild(this._embedPanel);
         this._embedBtn_shine.mouseEnabled = false;
         this._embedBtn_shine.mouseChildren = false;
         this._embedBtn_shine.movie.gotoAndStop(1);
         this.bg.setFrame(1);
         this.sortBtn();
      }
      
      public function refreshCurrentPanel() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this._composePanel.hide();
         this._strengthPanel.hide();
         this._transferPanel.hide();
         if(this.currentPanel)
         {
            this.currentPanel.show();
         }
      }
      
      public function changeToConsortiaState() : void
      {
         this._strengthPanel.consortiaRate();
      }
      
      public function changeToBaseState() : void
      {
         this._strengthPanel.consortiaRate();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this.strength_btn.addEventListener(MouseEvent.CLICK,this.__strengthClick);
         this.compose_btn.addEventListener(MouseEvent.CLICK,this.__composeClick);
         this.fusion_btn.addEventListener(MouseEvent.CLICK,this.__fusionClick);
         this.embed_btn.addEventListener(MouseEvent.CLICK,this.__embedBtnClick);
         this.transf_Btn.addEventListener(MouseEvent.CLICK,this.__transferClick);
         this._embedPanel.addEventListener(StoreIIEvent.EMBED_INFORCHANGE,this.embedInfoChangeHandler);
         this._strengthPanel.addEventListener(Event.CHANGE,this.changeHandler);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this.strength_btn.removeEventListener(MouseEvent.CLICK,this.__strengthClick);
         this.compose_btn.removeEventListener(MouseEvent.CLICK,this.__composeClick);
         this.fusion_btn.removeEventListener(MouseEvent.CLICK,this.__fusionClick);
         this.embed_btn.removeEventListener(MouseEvent.CLICK,this.__embedBtnClick);
         this.transf_Btn.addEventListener(MouseEvent.CLICK,this.__transferClick);
         this._embedPanel.removeEventListener(StoreIIEvent.EMBED_INFORCHANGE,this.embedInfoChangeHandler);
         this._strengthPanel.removeEventListener(Event.CHANGE,this.changeHandler);
      }
      
      private function changeHandler(param1:Event) : void
      {
         this._embedBtn_shine.movie.gotoAndStop(1);
      }
      
      private function __updateStoreBag(param1:BagEvent) : void
      {
         this.currentPanel.refreshData(param1.changedSlots);
      }
      
      public function set currentPanelIndex(param1:int) : void
      {
         this._currentPanelIndex = param1;
         this.panelIndex = param1;
         dispatchEvent(new ChoosePanelEvnet(this._currentPanelIndex));
      }
      
      public function get currentPanelIndex() : int
      {
         return this._currentPanelIndex;
      }
      
      public function get currentPanel() : IStoreViewBG
      {
         switch(this.currentPanelIndex)
         {
            case STRENGTH:
               return this._strengthPanel;
            case COMPOSE:
               return this._composePanel;
            case FUSION:
               return this._fusionPanel;
            case EMBED:
               return this._embedPanel;
            case TRANSF:
               return this._transferPanel;
            default:
               return null;
         }
      }
      
      public function __strengthClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == STRENGTH)
         {
            return;
         }
         this.currentPanelIndex = STRENGTH;
         if(param1 == null)
         {
            this.changeToTab(this.currentPanelIndex,false);
         }
         else
         {
            this.changeToTab(this.currentPanelIndex);
         }
         this.sortBtn();
         addChild(this.strength_btn);
      }
      
      private function __composeClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == COMPOSE)
         {
            return;
         }
         this.currentPanelIndex = COMPOSE;
         this.changeToTab(this.currentPanelIndex);
         this.sortBtn();
         addChild(this.compose_btn);
      }
      
      private function __fusionClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == FUSION)
         {
            return;
         }
         this.currentPanelIndex = FUSION;
         this.changeToTab(this.currentPanelIndex);
         this.sortBtn();
         addChild(this.fusion_btn);
      }
      
      private function __lianhuaClick(param1:MouseEvent) : void
      {
      }
      
      private function __embedBtnClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == EMBED)
         {
            return;
         }
         this.currentPanelIndex = EMBED;
         this.changeToTab(this.currentPanelIndex);
         this.sortBtn();
         addChild(this.embed_btn);
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_CLICK));
      }
      
      private function __transferClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == TRANSF)
         {
            return;
         }
         this.currentPanelIndex = TRANSF;
         this.changeToTab(this.currentPanelIndex);
         this.sortBtn();
         addChild(this.transf_Btn);
      }
      
      private function changeToTab(param1:int, param2:Boolean = true) : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         SoundManager.instance.play("008");
         this._composePanel.hide();
         this._strengthPanel.hide();
         this._fusionPanel.hide();
         this._embedPanel.hide();
         this._transferPanel.hide();
         this.currentPanel.show();
         this.bg.setFrame(param1 + 1);
         this._embedBtn_shine.movie.gotoAndStop(1);
      }
      
      private function sortBtn() : void
      {
         addChild(this.fusion_btn);
         addChild(this.transf_Btn);
         addChild(this.compose_btn);
         addChild(this.embed_btn);
         addChild(this.strength_btn);
      }
      
      public function shineEmbedBtn() : void
      {
         addChild(this._embedBtn_shine);
         this._embedBtn_shine.movie.play();
      }
      
      private function embedInfoChangeHandler(param1:StoreIIEvent) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_INFORCHANGE));
      }
      
      public function deleteSomeDataTemp() : void
      {
         this._strengthPanel.hide();
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._composePanel)
         {
            ObjectUtils.disposeObject(this._composePanel);
         }
         this._composePanel = null;
         if(this._strengthPanel)
         {
            ObjectUtils.disposeObject(this._strengthPanel);
         }
         this._strengthPanel = null;
         if(this._fusionPanel)
         {
            ObjectUtils.disposeObject(this._fusionPanel);
         }
         this._fusionPanel = null;
         if(this._embedPanel)
         {
            ObjectUtils.disposeObject(this._embedPanel);
         }
         this._embedPanel = null;
         if(this._transferPanel)
         {
            ObjectUtils.disposeObject(this._transferPanel);
         }
         this._transferPanel = null;
         if(this.bg)
         {
            ObjectUtils.disposeObject(this.bg);
         }
         this.bg = null;
         if(this.strength_btn)
         {
            ObjectUtils.disposeObject(this.strength_btn);
         }
         this.strength_btn = null;
         if(this.transf_Btn)
         {
            ObjectUtils.disposeObject(this.transf_Btn);
         }
         this.transf_Btn = null;
         if(this.compose_btn)
         {
            ObjectUtils.disposeObject(this.compose_btn);
         }
         this.compose_btn = null;
         if(this.embed_btn)
         {
            ObjectUtils.disposeObject(this.embed_btn);
         }
         this.embed_btn = null;
         if(this._embedBtn_shine)
         {
            ObjectUtils.disposeObject(this._embedBtn_shine);
         }
         this._embedBtn_shine = null;
         if(this.fusion_btn)
         {
            ObjectUtils.disposeObject(this.fusion_btn);
         }
         this.fusion_btn = null;
         SocketManager.Instance.out.sendClearStoreBag();
         SocketManager.Instance.out.sendSaveDB();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
