package store.fineStore.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.AssetModuleLoader;
   import ddt.utils.HelpBtnEnable;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import store.FineBringUpController;
   import store.StoreController;
   import store.fineStore.view.pageBringUp.FineBringUpView;
   
   public class FineStoreView extends Sprite implements Disposeable
   {
      
      private static const _forgeGroupType:Array = ["storeFineForge","equipGhost","storeFineBringUp"];
       
      
      private var _tabVbox:VBox;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _forgeBtn:SelectedButton;
      
      private var _forgeView:FineForgeView;
      
      private var _bringUpBtn:SelectedButton;
      
      private var _bringUpView:FineBringUpView;
      
      private var _ghostBtn:SelectedButton;
      
      private var _ghostView:FineGhostView;
      
      private var _content:Sprite;
      
      private var _index:int;
      
      private var _controller:StoreController;
      
      public function FineStoreView(param1:StoreController, param2:int)
      {
         super();
         this._index = param2;
         this._controller = param1;
         this.init();
         this.setIndex();
      }
      
      private function setIndex() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = this._btnGroup.length();
         _loc2_ = this._index;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._btnGroup.getItemByIndex(_loc2_) as ITipedDisplay;
            if(HelpBtnEnable.getInstance().isForbidden(_loc1_) == false)
            {
               this._btnGroup.selectIndex = 1;
               break;
            }
            _loc2_++;
         }
      }
      
      private function init() : void
      {
         //var _loc1_:DisplayObject = ComponentFactory.Instance.creatCustomObject("ddtstore.BagStoreFrame.ContentBg");
         //addChild(_loc1_);
         //_loc1_.height = 425;
         this._content = new Sprite();
         addChild(this._content);
         this._forgeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.fineStore.forgeBtn");
         this._ghostBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.equipGhost.ghost");
         this._bringUpBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.fineStore.bringUpBtn");
         this._bringUpBtn.x = this._forgeBtn.x = 999;
         this._bringUpBtn.y = this._forgeBtn.y = 999;
         HelpBtnEnable.getInstance().addMouseOverTips(this._forgeBtn,15);
         HelpBtnEnable.getInstance().addMouseOverTips(this._ghostBtn,15);
         HelpBtnEnable.getInstance().addMouseOverTips(this._bringUpBtn,15);
         this._tabVbox = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.TabSelectedBtnContainer");
         PositionUtils.setPos(this._tabVbox,"ddtstore.FineStore.VboxPos");
         addChild(this._tabVbox);
         this._tabVbox.addChild(this._forgeBtn);
         this._tabVbox.addChild(this._ghostBtn);
         this._tabVbox.addChild(this._bringUpBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addEventListener("change",this.__changeHandler,false,0,true);
         this._btnGroup.addSelectItem(this._forgeBtn);
         this._btnGroup.addSelectItem(this._ghostBtn);
         this._btnGroup.addSelectItem(this._bringUpBtn);
         AssetModuleLoader.addModelLoader("storeFineForge",6);
         AssetModuleLoader.startCodeLoader(this.showView2);
      }
      
      private function showView2() : void
      {
         if(!this._forgeView)
         {
            this._forgeView = new FineForgeView();
            PositionUtils.setPos(this._forgeView,"ddtstore.FineStore.ItemViewPos");
            this._content.addChild(this._forgeView);
         }
         this._forgeView.visible = true;
      }
      
      private function __changeHandler(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:String = _forgeGroupType[this._btnGroup.selectIndex];
         this._tabVbox.arrange();
         if(this._btnGroup.selectIndex == 4)
         {
            AssetModuleLoader.addModelLoader(_loc2_,5);
            AssetModuleLoader.addModelLoader("uigeneral",7);
         }
         else
         {
            AssetModuleLoader.addModelLoader(_loc2_,6);
         }
         AssetModuleLoader.startCodeLoader(this.showView);
      }
      
      private function showView() : void
      {
         if(this._forgeView)
         {
            this._forgeView.visible = false;
         }
         if(this._ghostView)
         {
            this._ghostView.visible = false;
         }
         if(this._bringUpView)
         {
            ObjectUtils.disposeObject(this._bringUpView);
            this._bringUpView = null;
            FineBringUpController.getInstance().dispose();
            SocketManager.Instance.out.sendClearStoreBag();
         }
         switch(int(this._btnGroup.selectIndex))
         {
            case 0:
               if(!this._forgeView)
               {
                  this._forgeView = new FineForgeView();
                  PositionUtils.setPos(this._forgeView,"ddtstore.FineStore.ItemViewPos");
                  this._content.addChild(this._forgeView);
               }
               this._forgeView.visible = true;
               break;
            case 1:
               SocketManager.Instance.out.sendClearStoreBag();
               if(!this._ghostView)
               {
                  this._ghostView = new FineGhostView(this._controller);
                  PositionUtils.setPos(this._ghostView,"ddtstore.FineStore.ghostViewPos");
                  this._content.addChild(this._ghostView);
               }
               this._ghostView.show();
               break;
            case 2:
               if(!this._bringUpView)
               {
                  this._bringUpView = new FineBringUpView();
                  PositionUtils.setPos(this._bringUpView,"ddtstore.FineStore.ItemViewPos");
                  this._content.addChild(this._bringUpView);
                  FineBringUpController.getInstance().setup();
               }
               FineBringUpController.getInstance().usingLock = false;
               SocketManager.Instance.out.sendClearStoreBag();
               this._bringUpView.refreshBagList();
               this._bringUpView.visible = true;
         }
      }
      
      public function dispose() : void
      {
         FineBringUpController.getInstance().dispose();
         this._controller = null;
         this._bringUpBtn && HelpBtnEnable.getInstance().removeMouseOverTips(this._bringUpBtn);
         this._forgeBtn && HelpBtnEnable.getInstance().removeMouseOverTips(this._forgeBtn);
         this._ghostBtn && HelpBtnEnable.getInstance().removeMouseOverTips(this._ghostBtn);
         if(this._btnGroup)
         {
            this._btnGroup.removeEventListener("change",this.__changeHandler);
            this._btnGroup.dispose();
            this._btnGroup = null;
         }
         ObjectUtils.disposeAllChildren(this._content);
         ObjectUtils.disposeAllChildren(this);
         this._tabVbox = null;
      }
   }
}
