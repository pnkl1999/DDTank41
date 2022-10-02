package store.forge
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.StoreMainView;
   import store.events.ChoosePanelEvnet;
   import store.forge.wishBead.WishBeadMainView;
   import store.view.exalt.StoreExaltBG;
   import latentEnergy.LatentEnergyMainView;
   import gemstone.GemstoneFrame;
   import gemstone.GemstoneManager;
   
   public class ForgeMainView extends Sprite implements Disposeable
   {
      
      public static var ISFRIST:Boolean;
      
      public static var IsExalt:Boolean;
       
      
      private var _tabVbox:VBox;
      
      private var _tabSBG:SelectedButtonGroup;
      
      private var _tabSBList:Vector.<SelectedButton>;
      
      private var bg:ScaleFrameImage;
      
      private var _rightBgView:ForgeRightBgView;
      
      private var _wishBeadView:WishBeadMainView;
      
      private var _exaltPanel:StoreExaltBG;
      
      private var _initIndex:int = 0;
      
      private var _currentPanelIndex:int;
	  
	  private var _latentEnergyView:LatentEnergyMainView;
	  
	  private var _gemstoneFrame:GemstoneFrame;
      
      public function ForgeMainView(param1:int = 0)
      {
         super();
         this._initIndex = param1;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FORGE_MAIN);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.FORGE_MAIN)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.FORGE_MAIN)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.initView();
            this.initEvent();
            this._tabSBG.selectIndex = this._initIndex;
         }
      }
      
      private function initView() : void
      {
         var _loc2_:SelectedButton = null;
         this.bg = ComponentFactory.Instance.creatComponentByStylename("store.MainViewBG1");
         this.bg.x = 57;
         this.bg.y = 31;
         addChild(this.bg);
         this._rightBgView = new ForgeRightBgView();
         PositionUtils.setPos(this._rightBgView,"forgeMainView.rightBgViewPos");
         addChild(this._rightBgView);
         this._tabVbox = ComponentFactory.Instance.creatComponentByStylename("forgeMainView.tabVBox");
         this._tabSBList = new Vector.<SelectedButton>();
         this._tabSBG = new SelectedButtonGroup();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("forgeMainView.tabSelectedButton" + _loc1_);
            _loc2_.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            this._tabVbox.addChild(_loc2_);
            this._tabSBG.addSelectItem(_loc2_);
            this._tabSBList.push(_loc2_);
            _loc1_++;
         }
         this.bg.setFrame(1);
         this._tabSBG.selectIndex = this._initIndex;
         addChild(this._tabVbox);
      }
      
      private function initEvent() : void
      {
         this._tabSBG.addEventListener(Event.CHANGE,this.changeHandler,false,0,true);
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._tabSBList.indexOf(param1.currentTarget as SelectedButton) == 3 && PlayerManager.Instance.Self.Grade < 30)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gemstone.limitLevel.tipTxt"));
            param1.stopImmediatePropagation();
         }
      }
      
      public function set currentPanelIndex(param1:int) : void
      {
         this._currentPanelIndex = param1;
         dispatchEvent(new ChoosePanelEvnet(this._currentPanelIndex));
      }
      
      public function get currentPanelIndex() : int
      {
         return this._currentPanelIndex;
      }
      
      public function changeHandler(param1:Event) : void
      {
         IsExalt = false;
         SocketManager.Instance.out.sendClearStoreBag();
         this._tabVbox.arrange();
         if(this._wishBeadView)
         {
            this._wishBeadView.visible = false;
         }
         if(this._exaltPanel)
         {
            this._exaltPanel.visible = false;
         }
		 if(this._latentEnergyView)
		 {
			 this._latentEnergyView.visible = false;
		 }
		 if(this._gemstoneFrame)
		 {
			 this._gemstoneFrame.visible = false;
		 }
         switch(this._tabSBG.selectIndex)
         {
            case 0:
               if(!this._wishBeadView)
               {
                  this._wishBeadView = new WishBeadMainView();
                  PositionUtils.setPos(this._wishBeadView,"forgeMainView.wishBeadViewPos");
                  addChild(this._wishBeadView);
               }
               this._wishBeadView.visible = true;
               this._rightBgView.showStoreBagViewText("forgeMainView.wishBead.equipTipTxt","forgeMainView.wishBead.itemTipTxt");
               this._rightBgView.visible = true;
               this.bg.setFrame(1);
               this.currentPanelIndex = StoreMainView.WISHBEAD;
               break;
            case 1:
               IsExalt = true;
               if(this._exaltPanel)
               {
                  ObjectUtils.disposeObject(this._exaltPanel);
                  this._exaltPanel = null;
               }
               if(this._exaltPanel == null)
               {
                  this._exaltPanel = new StoreExaltBG();
                  PositionUtils.setPos(this._exaltPanel,"forgeMainView.exaltPanelPos");
                  addChild(this._exaltPanel);
               }
               this._exaltPanel.visible = true;
               this._rightBgView.visible = false;
               this.bg.setFrame(1);
               this.currentPanelIndex = StoreMainView.EXALT;
			   break;
			case 2:
				if(!this._latentEnergyView)
				{
					this._latentEnergyView = new LatentEnergyMainView();
					PositionUtils.setPos(this._latentEnergyView,"forgeMainView.latentEnergyViewPos");
					addChild(this._latentEnergyView);
				}
				this._latentEnergyView.visible = true;
				this._rightBgView.showStoreBagViewText("forgeMainView.latentEnergy.equipTipTxt","forgeMainView.latentEnergy.itemTipTxt");
				this._rightBgView.visible = true;
				this.bg.setFrame(1);
				this.currentPanelIndex = StoreMainView.LatentEnergy;
				break;
			case 3:
				this._rightBgView.visible = false;
				if(!this._gemstoneFrame)
				{
					this._gemstoneFrame = new GemstoneFrame();
					PositionUtils.setPos(this._gemstoneFrame,"forgeMainView.gemstoneFramePos");
					addChild(this._gemstoneFrame);
					GemstoneManager.Instance.initFrame(this._gemstoneFrame);
				}
				this._gemstoneFrame.visible = true;
				this._rightBgView.visible = false;
				this.bg.setFrame(2);
				//this.currentPanelIndex = StoreMainView.GemStone;
				break;
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(visible)
         {
            if(this._wishBeadView)
            {
               this._wishBeadView.clearCellInfo();
               this._wishBeadView.refreshListData();
            }
            if(this._tabSBG)
            {
               this.changeHandler(null);
            }
			if(this._latentEnergyView)
			{
				this._latentEnergyView.clearCellInfo();
				this._latentEnergyView.refreshListData();
			}
         }
      }
      
      private function removeEvent() : void
      {
         if(this._tabSBG)
         {
            this._tabSBG.removeEventListener(Event.CHANGE,this.changeHandler);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:SelectedButton = null;
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         this.removeEvent();
         for each(_loc1_ in this._tabSBList)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         ObjectUtils.disposeAllChildren(this);
         this._tabVbox = null;
         this._tabSBG = null;
         this._tabSBList = null;
         this._rightBgView = null;
         this._wishBeadView = null;
         this._exaltPanel = null;
		 this._latentEnergyView = null;
		 this._gemstoneFrame = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get exaltPanel() : StoreExaltBG
      {
         return this._exaltPanel;
      }
   }
}
