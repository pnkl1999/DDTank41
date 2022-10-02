package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.ConsortiaDutyType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ConsortiaTaskView extends Sprite implements Disposeable
   {
      
      private static var RESET_MONEY:int = 500;
      
      private static var SUBMIT_RICHES:int = 5000;
       
      
      private var _myView:ConsortiaMyTaskView;
      
      private var _timeBG:Bitmap;
      
      private var _panel:ScrollPanel;
      
      private var _lastTimeTxt:FilterFrameText;
      
      private var _noTask:Bitmap;
      
      private var _timer:Timer;
      
      private var diff:Number;
      
      private var _myReseBtn:TextButton;
      
      public function ConsortiaTaskView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._timeBG = ComponentFactory.Instance.creatBitmap("asset.conortionTask.timeBG");
         this._myView = ComponentFactory.Instance.creatCustomObject("ConsortiaMyTaskView");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("consortion.task.scrollpanel");
         this._lastTimeTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.lastTimeTxt");
         this._noTask = ComponentFactory.Instance.creatBitmap("asset.conortionTask.notask");
         this._myReseBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.reset1");
         this._myReseBtn.text = LanguageMgr.GetTranslation("consortia.task.resetTable");
         addChild(this._timeBG);
         addChild(this._panel);
         addChild(this._lastTimeTxt);
         addChild(this._noTask);
         addChild(this._myReseBtn);
         this._panel.setView(this._myView);
         this._panel.invalidateViewport();
         this._noTask.visible = false;
         this._timeBG.visible = false;
         this._panel.visible = false;
         this._lastTimeTxt.visible = false;
         this._myReseBtn.visible = false;
         SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.GET_TASKINFO);
      }
      
      private function initEvents() : void
      {
         ConsortionModelControl.Instance.TaskModel.addEventListener(ConsortiaTaskEvent.GETCONSORTIATASKINFO,this.__getTaskInfo);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
         this._myReseBtn.addEventListener(MouseEvent.CLICK,this.__resetClick);
      }
      
      private function __propChange(param1:PlayerPropertyEvent) : void
      {
         var _loc2_:int = 0;
         if(param1.changedProperties["Right"] && ConsortionModelControl.Instance.TaskModel.taskInfo != null)
         {
            _loc2_ = PlayerManager.Instance.Self.Right;
            this._myReseBtn.visible = ConsortiaDutyManager.GetRight(_loc2_,ConsortiaDutyType._10_ChangeMan);
         }
      }
      
      private function __resetClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.stopTable"));
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.resetTable"),LanguageMgr.GetTranslation("consortia.task.resetContent"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.stopTable"));
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("consortia.task.stopTable"));
            }
            else if(PlayerManager.Instance.Self.Money < RESET_MONEY)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopItem.Money"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
            }
            else
            {
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RESET_TASK);
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
            }
         }
         ObjectUtils.disposeObject(param1.currentTarget as BaseAlerFrame);
      }
      
      private function __onNoMoneyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         _loc2_.disposeChildren = true;
         _loc2_.dispose();
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function removeEvents() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerOne);
         }
         ConsortionModelControl.Instance.TaskModel.removeEventListener(ConsortiaTaskEvent.GETCONSORTIATASKINFO,this.__getTaskInfo);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function __getTaskInfo(param1:ConsortiaTaskEvent) : void
      {
         if(param1.value == ConsortiaTaskModel.GET_TASKINFO || param1.value == ConsortiaTaskModel.SUMBIT_TASK || param1.value == ConsortiaTaskModel.UPDATE_TASKINFO || param1.value == ConsortiaTaskModel.SUCCESS_FAIL)
         {
            if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
            {
               this.__noTask();
            }
            else
            {
               this.__showTask();
            }
         }
      }
      
      private function __showTask() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.Right;
         this._noTask.visible = false;
         this._timeBG.visible = true;
         this._panel.visible = true;
         this._lastTimeTxt.visible = true;
         this._myReseBtn.visible = ConsortiaDutyManager.GetRight(_loc1_,ConsortiaDutyType._10_ChangeMan);
         this._myView.taskInfo = ConsortionModelControl.Instance.TaskModel.taskInfo;
         this.__startTimer();
      }
      
      private function __noTask() : void
      {
         this._noTask.visible = true;
         this._timeBG.visible = false;
         this._panel.visible = false;
         this._lastTimeTxt.visible = false;
         this._myReseBtn.visible = false;
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerOne);
            this._timer = null;
         }
      }
      
      private function __startTimer() : void
      {
         var _loc1_:Date = ConsortionModelControl.Instance.TaskModel.taskInfo.beginTime;
         if(this._timer != null || _loc1_ == null)
         {
            return;
         }
         this.diff = ConsortionModelControl.Instance.TaskModel.taskInfo.time * 60 - int(TimeManager.Instance.TotalSecondToNow(_loc1_)) + 60;
         this._timer = new Timer(1000,this.diff);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerOne);
         this._timer.start();
      }
      
      private function __timerOne(param1:TimerEvent) : void
      {
         --this.diff;
         this._lastTimeTxt.text = LanguageMgr.GetTranslation("consortia.task.lasttime",int(this.diff / 60),int(this.diff % 60));
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._myView)
         {
            ObjectUtils.disposeObject(this._myView);
         }
         this._myView = null;
         if(this._timeBG)
         {
            ObjectUtils.disposeObject(this._timeBG);
         }
         this._timeBG = null;
         if(this._panel)
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(this._lastTimeTxt)
         {
            ObjectUtils.disposeObject(this._lastTimeTxt);
         }
         this._lastTimeTxt = null;
         if(this._noTask)
         {
            ObjectUtils.disposeObject(this._noTask);
         }
         this._noTask = null;
         if(this._myReseBtn)
         {
            ObjectUtils.disposeObject(this._myReseBtn);
         }
         this._myReseBtn = null;
         if(this._timer)
         {
            this._timer.stop();
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
