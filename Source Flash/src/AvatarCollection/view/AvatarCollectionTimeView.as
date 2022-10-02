package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AvatarCollectionTimeView extends Sprite implements Disposeable
   {
       
      
      private var _txt:FilterFrameText;
      
      private var _btn:SimpleBitmapButton;
      
      private var _timer:Timer;
      
      private var _data:AvatarCollectionUnitVo;
      
      private var _needHonor:int;
      
      public function AvatarCollectionTimeView()
      {
         super();
         this.x = 295;
         this.y = 391;
         this.initView();
         this.initEvent();
         this.initTimer();
         this.setDefaultView();
      }
      
      private function initView() : void
      {
         this._txt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.timeView.txt");
         this._btn = ComponentFactory.Instance.creatComponentByStylename("avatarColl.timeView.btn");
         addChild(this._txt);
         addChild(this._btn);
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         //var _loc2_:int = 0 / this._needHonor;//PlayerManager.Instance.Self.myHonor / this._needHonor;
		 var _loc2_:int = PlayerManager.Instance.Self.myHonor / this._needHonor;
         var _loc3_:AvatarCollectionDelayConfirmFrame = ComponentFactory.Instance.creatComponentByStylename("avatarColl.delayConfirmFrame");
         _loc3_.show(this._needHonor,_loc2_);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __onConfirmResponse(param1:FrameEvent) : void
      {
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         var _loc2_:AvatarCollectionDelayConfirmFrame = param1.currentTarget as AvatarCollectionDelayConfirmFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc3_ = _loc2_.selectValue;
            if(/*PlayerManager.Instance.Self.myHonor*/0 < this._needHonor * _loc3_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.noEnoughHonor"));
            }
            else
            {
               SocketManager.Instance.out.sendAvatarCollectionDelayTime(this._data.id,_loc3_);
            }
         }
         _loc2_.dispose();
      }
      
      private function initTimer() : void
      {
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         this.refreshTimePlayTxt();
      }
      
      public function refreshView(param1:AvatarCollectionUnitVo) : void
      {
         this._data = param1;
         if(!this._data)
         {
            this.setDefaultView();
            this._timer.stop();
            return;
         }
         var _loc2_:int = this._data.totalItemList.length;
         var _loc3_:int = this._data.totalActivityItemCount;
         if(_loc3_ < _loc2_ / 2)
         {
            this.setDefaultView();
            this._timer.stop();
            this._needHonor = 99999999;
            return;
         }
         if(_loc3_ == _loc2_)
         {
            this._needHonor = this._data.needHonor * 2;
         }
         else
         {
            this._needHonor = this._data.needHonor;
         }
         this._btn.enable = true;
         this.refreshTimePlayTxt();
         this._timer.start();
      }
      
      private function refreshTimePlayTxt() : void
      {
         var _loc5_:String = null;
         var _loc1_:Number = this._data.endTime.getTime();
         var _loc2_:Number = TimeManager.Instance.Now().getTime();
         var _loc3_:Number = _loc1_ - _loc2_;
         _loc3_ = _loc3_ < 0?Number(0):Number(_loc3_);
         var _loc4_:int = 0;
         if(_loc3_ / TimeManager.DAY_TICKS > 1)
         {
            _loc4_ = _loc3_ / TimeManager.DAY_TICKS;
            _loc5_ = _loc4_ + LanguageMgr.GetTranslation("day");
         }
         else if(_loc3_ / TimeManager.HOUR_TICKS > 1)
         {
            _loc4_ = _loc3_ / TimeManager.HOUR_TICKS;
            _loc5_ = _loc4_ + LanguageMgr.GetTranslation("hour");
         }
         else if(_loc3_ / TimeManager.Minute_TICKS > 1)
         {
            _loc4_ = _loc3_ / TimeManager.Minute_TICKS;
            _loc5_ = _loc4_ + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            _loc4_ = _loc3_ / TimeManager.Second_TICKS;
            _loc5_ = _loc4_ + LanguageMgr.GetTranslation("second");
         }
         this._txt.text = LanguageMgr.GetTranslation("avatarCollection.timeView.txt") + _loc5_;
      }
      
      private function setDefaultView() : void
      {
         this._txt.text = LanguageMgr.GetTranslation("avatarCollection.timeView.txt") + 0 + LanguageMgr.GetTranslation("day");
         this._btn.enable = false;
      }
      
      private function removeEvent() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         ObjectUtils.disposeAllChildren(this);
         this._txt = null;
         this._btn = null;
         this._timer = null;
         this._data = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
