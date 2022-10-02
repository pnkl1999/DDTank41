package hotSpring.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import hotSpring.controller.HotSpringRoomController;
   import hotSpring.model.HotSpringRoomModel;
   
   public class RoomMenuView extends Sprite implements Disposeable
   {
       
      
      private var _controller:HotSpringRoomController;
      
      private var _model:HotSpringRoomModel;
      
      private var _menuIsOpen:Boolean = true;
      
      private var _BG:Bitmap;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _switchIMG:ScaleFrameImage;
      
      private var _returnBtn:SimpleBitmapButton;
      
      private var _continuBtn:SimpleBitmapButton;
      
      private var _continu:Function;
      
      public function RoomMenuView(param1:HotSpringRoomController, param2:HotSpringRoomModel, continu:Function)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this._continu = continu;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.hotSpring.menuBG");
         addChild(this._BG);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("asset.hotSpring.switchBtn");
         addChild(this._closeBtn);
         this._switchIMG = ComponentFactory.Instance.creatComponentByStylename("asset.hotSpring.switchIMG");
         this._switchIMG.setFrame(1);
         this._closeBtn.addChild(this._switchIMG);
         this._continuBtn = ComponentFactory.Instance.creatComponentByStylename("asset.hotSpring.continuBtn");
         addChild(this._continuBtn);
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("asset.hotSpring.returnBtn");
         addChild(this._returnBtn);
         this.setEvent();
      }
      
      private function setEvent() : void
      {
         if(this._continuBtn)
         {
            this._continuBtn.addEventListener(MouseEvent.CLICK,this.__continu);
         }
         this._returnBtn.addEventListener(MouseEvent.CLICK,this.backRoomList);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.switchMenu);
      }
      
      private function __continu(evt:MouseEvent) : void
      {
         this._continu();
      }
      
      private function backRoomList(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         StateManager.setState(StateType.HOT_SPRING_ROOM_LIST);
      }
      
      private function switchMenu(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._menuIsOpen)
         {
            this._switchIMG.setFrame(2);
         }
         else
         {
            this._switchIMG.setFrame(1);
         }
         addEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
      }
      
      private function menuShowOrHide(param1:Event) : void
      {
         if(this._menuIsOpen)
         {
            this.x += 20;
            if(this.x >= StageReferance.stageWidth - this.width + (this.width - 34))
            {
               removeEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
               this.x = StageReferance.stageWidth - this.width + (this.width - 34);
               this._menuIsOpen = false;
            }
         }
         else
         {
            this.x -= 20;
            if(this.x <= StageReferance.stageWidth - this.width)
            {
               removeEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
               this.x = StageReferance.stageWidth - this.width;
               this._menuIsOpen = true;
            }
         }
      }
      
      public function dispose() : void
      {
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._closeBtn)
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(this._switchIMG)
         {
            ObjectUtils.disposeObject(this._switchIMG);
         }
         this._switchIMG = null;
         if(this._returnBtn)
         {
            ObjectUtils.disposeObject(this._returnBtn);
         }
         this._returnBtn = null;
         if(this._continuBtn)
         {
            ObjectUtils.disposeObject(this._continuBtn);
         }
         this._continuBtn = null;
         this._controller = null;
         this._model = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
