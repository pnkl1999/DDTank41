package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionMainView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _unitList:Vector.<AvatarCollectionUnitView>;
      
      private var _rightView:AvatarCollectionRightView;
      
      private var _canActivitySCB:SelectedCheckButton;
      
      private var _canBuySCB:SelectedCheckButton;
      
      public function AvatarCollectionMainView()
      {
         super();
         this.x = -5;
         this.y = 40;
         AvatarCollectionManager.instance.initShopItemInfoList();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc2_:AvatarCollectionUnitView = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarCollMainView.bg");
         this._rightView = new AvatarCollectionRightView();
         PositionUtils.setPos(this._rightView,"avatarColl.mainView.rightViewPos");
         this._canActivitySCB = ComponentFactory.Instance.creatComponentByStylename("avatarColl.canActivitySCB");
         this._canBuySCB = ComponentFactory.Instance.creatComponentByStylename("avatarColl.canBuySCB");
         this._vbox = new VBox();
         PositionUtils.setPos(this._vbox,"avatarColl.mainView.vboxPos");
         this._vbox.spacing = 2;
         this._unitList = new Vector.<AvatarCollectionUnitView>();
         var _loc1_:int = 1;
         while(_loc1_ <= 2)
         {
            _loc2_ = new AvatarCollectionUnitView(_loc1_,this._rightView);
            _loc2_.addEventListener(AvatarCollectionUnitView.SELECTED_CHANGE,this.refreshView,false,0,true);
            this._vbox.addChild(_loc2_);
            this._unitList.push(_loc2_);
            _loc1_++;
         }
         addChild(this._bg);
         addChild(this._vbox);
         addChild(this._canActivitySCB);
         addChild(this._canBuySCB);
         addChild(this._rightView);
      }
      
      private function initEvent() : void
      {
         this._canActivitySCB.addEventListener(MouseEvent.CLICK,this.canActivityChangeHandler,false,0,true);
         this._canBuySCB.addEventListener(MouseEvent.CLICK,this.canBuyChangeHandler,false,0,true);
      }
      
      private function refreshView(param1:Event) : void
      {
         var _loc3_:AvatarCollectionUnitView = null;
         var _loc2_:AvatarCollectionUnitView = param1.target as AvatarCollectionUnitView;
         for each(_loc3_ in this._unitList)
         {
            if(_loc3_ != _loc2_)
            {
               _loc3_.unextendHandler();
            }
         }
         this._vbox.arrange();
      }
      
      private function canBuyChangeHandler(param1:MouseEvent) : void
      {
         var _loc2_:AvatarCollectionUnitView = null;
         SoundManager.instance.play("008");
         for each(_loc2_ in this._unitList)
         {
            _loc2_.isBuyFilter = this._canBuySCB.selected;
         }
         if(this._canBuySCB.selected)
         {
            this._canActivitySCB.selected = false;
         }
      }
      
      private function canActivityChangeHandler(param1:MouseEvent) : void
      {
         var _loc2_:AvatarCollectionUnitView = null;
         SoundManager.instance.play("008");
         for each(_loc2_ in this._unitList)
         {
            _loc2_.isFilter = this._canActivitySCB.selected;
         }
         if(this._canActivitySCB.selected)
         {
            this._canBuySCB.selected = false;
         }
      }
      
      private function removeEvent() : void
      {
         this._canActivitySCB.removeEventListener(MouseEvent.CLICK,this.canActivityChangeHandler);
         this._canBuySCB.removeEventListener(MouseEvent.CLICK,this.canBuyChangeHandler);
      }
      
      public function dispose() : void
      {
         var _loc1_:AvatarCollectionUnitView = null;
         this.removeEvent();
         for each(_loc1_ in this._unitList)
         {
            _loc1_.removeEventListener(AvatarCollectionUnitView.SELECTED_CHANGE,this.refreshView);
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._vbox = null;
         this._unitList = null;
         this._rightView = null;
         this._canActivitySCB = null;
         this._canBuySCB = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
