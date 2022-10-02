package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.events.WebSpeedEvent;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   import game.GameManager;
   import room.model.WebSpeedInfo;
   
   public class WebSpeedView extends Sprite
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _info:WebSpeedInfo;
      
      private var _startTime:Number;
      
      private var _count:uint = 1500;
      
      public function WebSpeedView()
      {
         this._info = GameManager.Instance.Current.selfGamePlayer.webSpeedInfo;
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.game.webSpdIcon");
         addChild(this._bg);
         this._bg.setFrame(1);
         this._startTime = getTimer();
         this.__stateChanged(null);
      }
      
      public function dispose() : void
      {
         this._info.removeEventListener(WebSpeedEvent.STATE_CHANE,this.__stateChanged);
         removeEventListener(Event.ENTER_FRAME,this.__frame);
         this._info = null;
         this._bg.dispose();
         this._bg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function initEvent() : void
      {
         this._info.addEventListener(WebSpeedEvent.STATE_CHANE,this.__stateChanged);
         addEventListener(Event.ENTER_FRAME,this.__frame);
      }
      
      private function __stateChanged(param1:WebSpeedEvent) : void
      {
         this._bg.setFrame(this._info.stateId);
         var _loc2_:Object = new Object();
         _loc2_["stateTxt"] = this._info.state;
         _loc2_["delayTxt"] = LanguageMgr.GetTranslation("tank.game.WebSpeedView.delay") + this._info.delay.toString();
         _loc2_["fpsTxt"] = LanguageMgr.GetTranslation("tank.game.WebSpeedView.frame") + this._info.fps.toString();
         _loc2_["explain1"] = LanguageMgr.GetTranslation("tank.game.WebSpeedView.explain1");
         _loc2_["explain2"] = LanguageMgr.GetTranslation("tank.game.WebSpeedView.explain2");
         this._bg.tipData = _loc2_;
      }
      
      private function __frame(param1:Event) : void
      {
         var _loc2_:Number = getTimer() - this._startTime;
         ++this._count;
         this._startTime = getTimer();
         if(this._count < 1500)
         {
            return;
         }
         this._info.fps = int(1000 / _loc2_);
         this._count = 0;
      }
   }
}
