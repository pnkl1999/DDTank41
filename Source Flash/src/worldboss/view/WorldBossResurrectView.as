package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.socket.ePackageType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageOut;
   import worldboss.WorldBossManager;
   import worldboss.model.WorldBossGamePackageType;
   
   public class WorldBossResurrectView extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _resurrectBtn:BaseButton;
      
      private var _timeCD:MovieClip;
      
      private var _txtProp:FilterFrameText;
      
      private var _totalCount:int;
      
      private var timer:Timer;
      
      private var alert:BaseAlerFrame;
      
      public function WorldBossResurrectView(param1:int)
      {
         super();
         this._totalCount = param1;
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("worldBossRoom.resurrectBg");
         addChild(this._bg);
         this._txtProp = ComponentFactory.Instance.creat("worldBossRoom.resurrect.txtProp");
         addChild(this._txtProp);
         this._txtProp.text = LanguageMgr.GetTranslation("worldboss.resurrectView.prop");
         this._resurrectBtn = ComponentFactory.Instance.creat("worldbossRoom.resurrect.btn");
         addChild(this._resurrectBtn);
         this._timeCD = ComponentFactory.Instance.creat("asset.worldboosRoom.timeCD");
         addChild(this._timeCD);
         this.timer = new Timer(1000,this._totalCount + 1);
         this.timer.addEventListener(TimerEvent.TIMER,this.__startCount);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this.timer.start();
      }
      
      private function addEvent() : void
      {
         this._resurrectBtn.addEventListener(MouseEvent.CLICK,this.__resurrect);
      }
      
      private function __resurrect(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worldboss.revive.propMoney",WorldBossManager.Instance.bossInfo.reviveMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this.alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      public function __startCount(param1:TimerEvent) : void
      {
         if(this._totalCount < 0)
         {
            this.__timerComplete();
            return;
         }
         var _loc2_:String = this.setFormat(int(this._totalCount / 3600)) + ":" + this.setFormat(int(this._totalCount / 60 % 60)) + ":" + this.setFormat(int(this._totalCount % 60));
         (this._timeCD["timeHour2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(0));
         (this._timeCD["timeHour"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(1));
         (this._timeCD["timeMint2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(3));
         (this._timeCD["timeMint"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(4));
         (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(6));
         (this._timeCD["timeSecond"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(7));
         --this._totalCount;
      }
      
      private function removeEvent() : void
      {
         this._resurrectBtn.removeEventListener(MouseEvent.CLICK,this.__resurrect);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.Money >= WorldBossManager.Instance.bossInfo.reviveMoney)
               {
                  this.requestRevive();
               }
               else
               {
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  _loc2_.moveEnable = false;
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
               }
               this.alert.dispose();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.alert.dispose();
         }
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function requestRevive() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc1_.writeByte(WorldBossGamePackageType.REQUEST_REVIVE);
         SocketManager.Instance.socket.send(_loc1_);
      }
      
      private function setFormat(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         if(param1 < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      private function __timerComplete(param1:TimerEvent = null) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.__startCount);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         if(this.alert)
         {
            this.alert.dispose();
         }
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._bg = null;
         this._txtProp = null;
         this._resurrectBtn = null;
         this._timeCD = null;
      }
   }
}
