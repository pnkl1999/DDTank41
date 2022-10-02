package ddt.view.enthrall
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.EnthrallManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EnthrallView extends Component
   {
      
      public static const HALL_VIEW_STATE:uint = 0;
      
      public static const ROOMLIST_VIEW_STATE:uint = 1;
      
      public static const GAME_VIEW_STATE:uint = 2;
       
      
      private var _enthrall:ScaleFrameImage;
      
      private var _enthrallBall:ScaleFrameImage;
      
      private var _info:TimeTip;
      
      private var _approveBtn:SimpleBitmapButton;
      
      private var _manager:EnthrallManager;
      
      public function EnthrallView()
      {
         super();
      }
      
      public function set manager(param1:EnthrallManager) : void
      {
         this._manager = param1;
         this.initUI();
      }
      
      private function initUI() : void
      {
         this._enthrall = ComponentFactory.Instance.creat("core.view.enthrall.InfoNormal");
         this._enthrall.setFrame(1);
         addChild(this._enthrall);
         this._approveBtn = ComponentFactory.Instance.creat("core.view.enthrall.ValidateBtn");
         addChild(this._approveBtn);
         this._enthrallBall = ComponentFactory.Instance.creat("core.view.enthrall.InfoBall");
         this._info = ComponentFactory.Instance.creat("EnthrallTip");
         this._info.visible = false;
         this._info.info_txt.text = "";
         addChild(this._info);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         TimeManager.addEventListener(TimeManager.CHANGE,this.__changeHandler);
         this._enthrall.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._enthrall.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._enthrallBall.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._enthrallBall.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._approveBtn.addEventListener(MouseEvent.CLICK,this.popFrame);
      }
      
      private function popFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._manager.showCIDCheckerFrame();
      }
      
      public function update() : void
      {
         this.upGameTimeStatus();
      }
      
      private function __changeHandler(param1:Event) : void
      {
         if(this.parent == null || this.visible == false)
         {
            return;
         }
         this.upGameTimeStatus();
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         this.upGameTimeStatus();
         this._info.visible = true;
      }
      
      private function upGameTimeStatus() : void
      {
         var _loc1_:Number = TimeManager.Instance.totalGameTime;
         this._info.info_txt.text = this.getTimeTxt(_loc1_);
         this.setViewState(_loc1_);
      }
      
      private function getTimeTxt(param1:Number) : String
      {
         var _loc2_:Number = Math.floor(param1 / 60);
         var _loc3_:Number = Math.floor(param1 % 60);
         return (_loc3_ < 10 ? _loc2_ + ":0" + _loc3_ : _loc2_ + ":" + _loc3_) + " / 5:00";
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         this._info.info_txt.text = "";
         this.setViewState(TimeManager.Instance.totalGameTime);
         this._info.visible = false;
      }
      
      private function setViewState(param1:Number) : void
      {
         var _loc2_:Number = Math.floor(param1);
         if(_loc2_ < 180)
         {
            this._enthrall.setFrame(1);
            this._enthrallBall.setFrame(1);
         }
         else if(_loc2_ < 300)
         {
            this._enthrall.setFrame(2);
            this._enthrallBall.setFrame(2);
         }
         else if(_loc2_ > 300)
         {
            this._enthrall.setFrame(3);
            this._enthrallBall.setFrame(3);
         }
      }
      
      public function show(param1:EnthrallView) : void
      {
         this.setViewState(TimeManager.Instance.totalGameTime);
      }
      
      public function changeBtn(param1:Boolean) : void
      {
         this._approveBtn.visible = param1;
      }
      
      public function changeToGameState(param1:Boolean) : void
      {
         this._enthrallBall.visible = param1;
         this._enthrall.visible = !param1;
         this._approveBtn.visible = !param1;
      }
      
      private function removeEvent() : void
      {
         TimeManager.removeEventListener(TimeManager.CHANGE,this.__changeHandler);
         this._enthrall.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._enthrall.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._enthrallBall.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._enthrallBall.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._approveBtn.removeEventListener(MouseEvent.CLICK,this.popFrame);
      }
      
      override public function dispose() : void
      {
      }
      
      public function get enthrall() : ScaleFrameImage
      {
         return this._enthrall;
      }
   }
}
