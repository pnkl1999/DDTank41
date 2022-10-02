package ddt.bagStore
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import ddt.data.store.StoreState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.StoreController;
   import store.forge.ForgeMainView;
   import store.states.BaseStoreView;
   import com.pickgliss.utils.ObjectUtils;
   import store.fineStore.view.FineStoreView;
   import ddt.utils.PositionUtils;
   
   public class BagStoreFrame extends Frame
   {
       
      
      private var _view:Sprite;
      
      private var _controller:StoreController;
      
      private var _storeBtn:SelectedButton;
      
      private var _forgeBtn:SelectedButton;
      
	  private var _fineStoreBtn:SelectedButton;
	  
      private var _btnGroup:SelectedButtonGroup;
	  
	  private var _fineStoreView:FineStoreView;
      
      private var _index:int;
      
      public function BagStoreFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("tank.view.store.title");
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._storeBtn = ComponentFactory.Instance.creatComponentByStylename("newStore.tabStoreBtn");
         this._forgeBtn = ComponentFactory.Instance.creatComponentByStylename("newStore.tabForgeBtn");
		 this._fineStoreBtn = ComponentFactory.Instance.creatComponentByStylename("newStore.tabFineStoreBtn");
         addToContent(this._storeBtn);
         addToContent(this._forgeBtn);
		 addToContent(this._fineStoreBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._storeBtn);
         this._btnGroup.addSelectItem(this._forgeBtn);
		 this._btnGroup.addSelectItem(this._fineStoreBtn);
         this._btnGroup.selectIndex = 0;
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler,false,0,true);
         this._storeBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._forgeBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
		 this._fineStoreBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
      }
      
      private function __changeHandler(param1:Event) : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
		 if(this._fineStoreView)
		 {
			 this._fineStoreView.visible = false;
		 }
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._view.visible = true;
               (this._view as BaseStoreView).showForeView(0);
               break;
            case 1:
               if(PlayerManager.Instance.Self.Grade < 20)
               {
				  SocketManager.Instance.out.sendErrorMsg("this._index 1: " + this._index);
                  this._btnGroup.selectIndex = this._index;//0;
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ShowForeView.NoLevelTip"));
                  return;
               }
               this._view.visible = true;
               (this._view as BaseStoreView).showForeView(1);
               break;
			case 2:
				if(!this._fineStoreView)
				{
					this._fineStoreView = new FineStoreView(this._controller,this._controller.selectedIndex["fine_store"]);
					PositionUtils.setPos(this._fineStoreView,"ddtstore.BagStoreViewPos");
					this._fineStoreView.x = this._view.x - 5;
					this._fineStoreView.y = this._view.y - 10;
					addToContent(this._fineStoreView);
				}
				this._fineStoreView.visible = true;
				this._view.visible = false;
				break;
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function set controller(param1:StoreController) : void
      {
         this._controller = param1;
      }
      
      public function show(param1:String, param2:int) : void
      {
         BagStore.instance.isInBagStoreFrame = true;
         this._index = param2;
         this._view = this._controller.getView(this.getStoreType(param1));
         addToContent(this._view);
         addEventListener(FrameEvent.RESPONSE,this._response);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         if(param1 != StoreState.CONSORTIASTORE)
         {
            this._controller.startupEvent();
         }
      }
      
      private function getStoreType(param1:String) : String
      {
         if(param1 == BagStore.BAG_STORE)
         {
            if(PlayerManager.Instance.Self.ConsortiaID != 0)
            {
               param1 = BagStore.CONSORTIA;
            }
            else
            {
               param1 = BagStore.GENERAL;
            }
         }
         return param1;
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            BagStore.instance._isStoreOpen = false;
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ForgeMainView.IsExalt = false;
		 ObjectUtils.disposeObject(this._fineStoreView);
		 this._fineStoreView = null;
         this._controller.shutdownEvent();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._view = null;
         this._controller = null;
         BagStore.instance.storeOpenAble = false;
         BagStore.instance.closed();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
