package newChickenBox.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.LaterEquipmentGoodView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import newChickenBox.controller.NewChickenBoxManager;
   import newChickenBox.events.NewChickenBoxEvents;
   import newChickenBox.model.NewChickenBoxModel;
   
   public class NewChickenBoxFrame extends Frame implements Disposeable
   {
       
      
      private var _model:NewChickenBoxModel;
      
      private var tipSprite:Sprite;
      
      private var _newBoxBG:Image;
      
      public var countNum:ScaleFrameImage;
      
      private var openCardTimes:Image;
      
      public var eyeBtn:BaseButton;
      
      public var startBnt:BaseButton;
      
      public var flushBnt:TextButton;
      
      public var msgText:FilterFrameText;
      
      public var newBoxView:NewChickenBoxView;
      
      private var _timer:Timer;
      
      private var timer1:Timer;
      
      private var timer2:Timer;
      
      private var _help_btn:BaseButton;
      
      private var egg:MovieClip;
      
      private var _helpPage:Frame;
      
      private var _helpPageCloseBtn:TextButton;
      
      private var _helpPageBg:Scale9CornerImage;
      
      private var _helpWord:MovieClip;
      
      private var eyepic:MovieClip;
      
      private var _refreshTimerTxt:FilterFrameText;
      
      private var _panel:ScrollPanel;
      
      public var frame:BaseAlerFrame;
      
      public function NewChickenBoxFrame()
      {
         super();
         this._model = NewChickenBoxModel.instance;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("newChickenBox.newChickenTitle");
         this._newBoxBG = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.newChickenBoxFrame.BG");
         addToContent(this._newBoxBG);
         this.countNum = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.countNum");
         var _loc1_:int = this._model.canOpenCounts + 1 - this._model.countTime;
         this.countNum.setFrame(_loc1_);
         addToContent(this.countNum);
         this.openCardTimes = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.openCardTimes");
         addToContent(this.openCardTimes);
         this.eyeBtn = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.eyeBtn");
         this.eyeBtn.enable = false;
         this.eyeBtn.tipData = LanguageMgr.GetTranslation("newChickenBox.useEyeCost",this._model.eagleEyePrice[this._model.countEye]);
         PositionUtils.setPos(this.eyeBtn,"asset.newChickenBox.eagleEyePos");
         addToContent(this.eyeBtn);
         this._help_btn = ComponentFactory.Instance.creat("newChickenBox.helpPageBtn");
         addToContent(this._help_btn);
         this.firstEnterHelp();
         this.startBnt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.startBtn");
         if(this._model.isShowAll)
         {
            this.startBnt.enable = true;
         }
         else
         {
            this.startBnt.enable = false;
         }
         addToContent(this.startBnt);
         this.flushBnt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.freeFluashBnt");
         this.flushBnt.text = LanguageMgr.GetTranslation("newChickenBox.freeFlush");
         this.flushBnt.tipData = LanguageMgr.GetTranslation("newChickenBox.flushTipData");
         this.flushTip();
         addToContent(this.flushBnt);
         this._refreshTimerTxt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.text.adoptRefreshTimer");
         this.firestGetTime();
         addToContent(this._refreshTimerTxt);
         this.msgText = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.TextStyle_1");
         addToContent(this.msgText);
         this.msgText.text = LanguageMgr.GetTranslation("newChickenBox.useMoneyMsg",this._model.openCardPrice[this._model.countTime]);
         this.newBoxView = new NewChickenBoxView();
         addToContent(this.newBoxView);
         this.eyepic = ClassUtils.CreatInstance("asset.newChickenBox.eyePic") as MovieClip;
         this.eyepic.visible = false;
         this.eyepic.mouseChildren = false;
         this.eyepic.mouseEnabled = false;
         addEventListener(Event.ENTER_FRAME,this.useEyePic);
         LayerManager.Instance.addToLayer(this.eyepic,LayerManager.GAME_TOP_LAYER);
         LaterEquipmentGoodView.isShow = false;
      }
      
      private function useEyePic(param1:Event) : void
      {
         if(this._model.clickEagleEye)
         {
            this.eyepic.visible = true;
            Mouse.hide();
         }
         else
         {
            this.eyepic.visible = false;
            Mouse.show();
         }
         this.eyepic.x = mouseX;
         this.eyepic.y = mouseY;
      }
      
      private function flushTip() : void
      {
         this.timer1 = new Timer(60000,0);
         this.timer1.addEventListener(TimerEvent.TIMER,this.updateTip);
         this.timer1.start();
      }
      
      private function firestGetTime() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Number = _loc2_.getTime();
         var _loc4_:Number = this._model.lastFlushTime.getTime();
         var _loc5_:Number = this._model.freeFlushTime * 60 * 1000;
         if(_loc3_ - _loc4_ > _loc5_)
         {
            this._refreshTimerTxt.text = LanguageMgr.GetTranslation("newChickenBox.flushTimecut",0,0);
            if(this.flushBnt)
            {
               this.flushBnt.text = LanguageMgr.GetTranslation("newChickenBox.freeFlush");
            }
            _loc1_ = true;
         }
         else
         {
            _loc6_ = _loc5_ - (_loc3_ - _loc4_);
            _loc7_ = _loc6_ / (1000 * 60 * 60);
            _loc8_ = (_loc6_ - _loc7_ * 1000 * 60 * 60) / (1000 * 60);
            this._refreshTimerTxt.text = LanguageMgr.GetTranslation("newChickenBox.flushTimecut",_loc7_,_loc8_);
            if(this.flushBnt)
            {
               this.flushBnt.text = LanguageMgr.GetTranslation("newChickenBox.flushText");
            }
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      private function updateTip(param1:TimerEvent) : void
      {
         this.firestGetTime();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.useEyePic);
         removeEventListener(MouseEvent.CLICK,this.clickFrame);
         removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(this.startBnt)
         {
            this.startBnt.removeEventListener(MouseEvent.CLICK,this.clickStart);
         }
         if(this.eyeBtn)
         {
            this.eyeBtn.removeEventListener(MouseEvent.CLICK,this.clickEye);
         }
         if(this.flushBnt)
         {
            this.flushBnt.removeEventListener(MouseEvent.CLICK,this.flushItem);
         }
         this._model.removeEventListener(NewChickenBoxEvents.CANCLICKENABLE,this.playMovie);
         this._model.removeEventListener("mouseShapoff",this.mouseoff);
         if(this._help_btn)
         {
            this._help_btn.removeEventListener(MouseEvent.CLICK,this.__help);
         }
         if(this._helpPageCloseBtn)
         {
            this._helpPageCloseBtn.removeEventListener(MouseEvent.CLICK,this.__helpPageClose);
            this._helpPage.removeEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
         }
      }
      
      private function mouseoff(param1:Event) : void
      {
         this.eyepic.visible = false;
         Mouse.show();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         this.startBnt.addEventListener(MouseEvent.CLICK,this.clickStart);
         this.eyeBtn.addEventListener(MouseEvent.CLICK,this.clickEye);
         this.flushBnt.addEventListener(MouseEvent.CLICK,this.flushItem);
         this._model.addEventListener(NewChickenBoxEvents.CANCLICKENABLE,this.playMovie);
         this._model.addEventListener("mouseShapoff",this.mouseoff);
         this._help_btn.addEventListener(MouseEvent.CLICK,this.__help);
         addEventListener(MouseEvent.CLICK,this.clickFrame);
      }
      
      private function clickFrame(param1:MouseEvent) : void
      {
         if(this._model.clickEagleEye)
         {
            this.eyepic.visible = false;
            Mouse.show();
            this._model.clickEagleEye = false;
         }
      }
      
      private function firstEnterHelp() : void
      {
         if(this._model.firstEnterHelp)
         {
            this._model.firstEnterHelp = false;
            if(!this._helpPage)
            {
               this.createHelpPage();
            }
            StageReferance.stage.focus = this._helpPage;
            this._helpPage.visible = !!this._helpPage.visible ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         }
      }
      
      private function __help(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.eyepic.visible = false;
         Mouse.show();
         this._model.clickEagleEye = false;
         param1.stopImmediatePropagation();
         if(!this._helpPage)
         {
            this.createHelpPage();
         }
         StageReferance.stage.focus = this._helpPage;
         this._helpPage.visible = !!this._helpPage.visible ? Boolean(Boolean(false)) : Boolean(Boolean(true));
      }
      
      private function createHelpPage() : void
      {
         this._helpPage = ComponentFactory.Instance.creat("newChickenBox.helpPageFrame");
         this._helpPage.escEnable = true;
         this._helpPage.titleText = LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.useHelp");
         LayerManager.Instance.addToLayer(this._helpPage,LayerManager.GAME_TOP_LAYER,true);
         this._helpPageBg = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.helpPageFrameBG");
         this._helpPage.addToContent(this._helpPageBg);
         this._helpPageCloseBtn = ComponentFactory.Instance.creat("newChickenBox.helpPageCloseBtn");
         this._helpPageCloseBtn.text = LanguageMgr.GetTranslation("close");
         this._helpPage.addToContent(this._helpPageCloseBtn);
         this._helpPageCloseBtn.addEventListener(MouseEvent.CLICK,this.__helpPageClose);
         this._helpWord = ComponentFactory.Instance.creat("asset.newChickenBox.helpPageWord");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.ReaderScrollpanel");
         this._panel.setView(this._helpWord);
         this._panel.invalidateViewport(false);
         this._helpPage.addToContent(this._panel);
         this._helpPage.visible = false;
         this._helpPage.addEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
      }
      
      private function __helpPageClose(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpPage.visible = false;
      }
      
      private function __helpResponseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this._helpPage.visible = false;
         }
         StageReferance.stage.focus = this;
      }
      
      private function playMovie(param1:NewChickenBoxEvents) : void
      {
         this.eyeBtn.enable = true;
         this.__start();
      }
      
      private function clickStart(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.startBnt.enable = false;
         SocketManager.Instance.out.sendClickStartBntNewChickenBox();
      }
      
      private function flushItem(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Date = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         Mouse.show();
         var _loc2_:int = this._model.flushPrice;
         var _loc3_:Boolean = this.firestGetTime();
         if(!_loc3_ && PlayerManager.Instance.Self.Money < _loc2_)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(this._model.AlertFlush && !_loc3_)
         {
            this.openAlertFrame();
         }
         else if(_loc3_)
         {
            this.startBnt.enable = true;
            this.eyeBtn.enable = false;
            _loc4_ = this._model.canOpenCounts + 1;
            this.countNum.setFrame(_loc4_);
            this._model.countTime = 0;
            this._model.countEye = 0;
            _loc5_ = TimeManager.Instance.Now();
            _loc6_ = _loc5_.getTime();
            _loc7_ = this._model.lastFlushTime.getTime();
            _loc8_ = this._model.freeFlushTime * 60 * 1000;
            _loc9_ = _loc8_;
            _loc10_ = _loc9_ / (1000 * 60 * 60);
            _loc11_ = (_loc9_ - _loc10_ * 1000 * 60 * 60) / (1000 * 60);
            this._refreshTimerTxt.text = LanguageMgr.GetTranslation("newChickenBox.flushTimecut",_loc10_,_loc11_);
            if(this.flushBnt)
            {
               this.flushBnt.text = LanguageMgr.GetTranslation("newChickenBox.flushText");
            }
            this._model.canclickEnable = false;
            SocketManager.Instance.out.sendFlushNewChickenBox();
         }
         else
         {
            this.startBnt.enable = true;
            _loc12_ = this._model.canOpenCounts + 1;
            this.countNum.setFrame(_loc12_);
            this._model.countTime = 0;
            this._model.countEye = 0;
            this.eyeBtn.enable = false;
            this._model.canclickEnable = false;
            SocketManager.Instance.out.sendFlushNewChickenBox();
         }
      }
      
      private function openAlertFrame() : BaseAlerFrame
      {
         var _loc1_:String = LanguageMgr.GetTranslation("newChickenBox.useMoneyAlert",this._model.flushPrice);
         var _loc2_:TextField = new TextField();
         var _loc3_:SelectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.selectBnt");
         _loc3_.text = LanguageMgr.GetTranslation("newChickenBox.noAlert");
         _loc3_.addEventListener(MouseEvent.CLICK,this.noAlertEable);
         if(this.frame)
         {
            ObjectUtils.disposeObject(this.frame);
         }
         this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("newChickenBox.newChickenTitle"),_loc1_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         this.frame.addChild(_loc3_);
         this.frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         return this.frame;
      }
      
      private function noAlertEable(param1:MouseEvent) : void
      {
         var _loc2_:SelectedCheckButton = param1.currentTarget as SelectedCheckButton;
         if(_loc2_.selected)
         {
            this._model.AlertFlush = false;
         }
         else
         {
            this._model.AlertFlush = true;
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.startBnt.enable = true;
            this.eyeBtn.enable = false;
            _loc3_ = this._model.canOpenCounts + 1;
            this.countNum.setFrame(_loc3_);
            this._model.countTime = 0;
            this._model.countEye = 0;
            this._model.canclickEnable = false;
            SocketManager.Instance.out.sendFlushNewChickenBox();
         }
      }
      
      private function clickEye(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._model.countEye >= this._model.canEagleEyeCounts)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.eyeNotUseEnable"));
            return;
         }
         if(this._model.canclickEnable)
         {
            this.eyepic.visible = true;
            Mouse.hide();
            this._model.clickEagleEye = true;
            param1.stopImmediatePropagation();
         }
      }
      
      private function __start() : void
      {
         TweenLite.to(this.newBoxView,0.5,{
            "alpha":0,
            "scaleX":0,
            "scaleY":0,
            "x":470,
            "y":300,
            "ease":Sine.easeInOut
         });
         this._timer = new Timer(500,1);
         this._timer.start();
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
      }
      
      private function showOutItem(param1:Event) : void
      {
         TweenLite.to(this.newBoxView,0.5,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "x":0,
            "y":0,
            "ease":Sine.easeInOut
         });
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.removeEventListener("showItems",this.showOutItem);
         removeChild(_loc2_);
         _loc2_ = null;
      }
      
      private function _timerComplete(param1:TimerEvent) : void
      {
         this.egg = ClassUtils.CreatInstance("asset.newChickenBox.dan") as MovieClip;
         this.egg.addEventListener("showItems",this.showOutItem);
         PositionUtils.setPos(this.egg,"newChickenBox.eggPos");
         addChild(this.egg);
         this.egg.mouseEnabled = false;
         this.egg.mouseChildren = false;
         var _loc2_:int = 0;
         while(_loc2_ < this._model.itemList.length)
         {
            this._model.itemList[_loc2_].setBg(3);
            _loc2_++;
         }
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
         this._timer = null;
         this.msgText.text = LanguageMgr.GetTranslation("newChickenBox.useMoneyMsg",this._model.openCardPrice[this._model.countTime]);
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
               NewChickenBoxManager.instance.firstEnter = true;
               this._model.countTime = 0;
               this._model.countTime = 0;
               if(this.eyepic)
               {
                  this.eyepic.visible = false;
               }
               Mouse.show();
               this._model.clickEagleEye = false;
               break;
            case FrameEvent.ESC_CLICK:
               this.dispose();
               NewChickenBoxManager.instance.firstEnter = true;
               this._model.countTime = 0;
               this._model.countTime = 0;
               if(this.eyepic)
               {
                  this.eyepic.visible = false;
               }
               Mouse.show();
               this._model.clickEagleEye = false;
         }
      }
      
      private function helpPageDispose() : void
      {
         if(this._helpPage)
         {
            if(this._helpPageCloseBtn)
            {
               ObjectUtils.disposeObject(this._helpPageCloseBtn);
            }
            this._helpPageCloseBtn = null;
            if(this._helpPageBg)
            {
               ObjectUtils.disposeObject(this._helpPageBg);
            }
            this._helpPageBg = null;
            if(this._helpWord)
            {
               ObjectUtils.disposeObject(this._helpWord);
            }
            this._helpWord = null;
            this._helpPage.dispose();
            if(this._helpPage && this._helpPage.parent)
            {
               this._helpPage.parent.removeChild(this._helpPage);
            }
            this._helpPage = null;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         TweenLite.killTweensOf(this.newBoxView);
         if(this.egg)
         {
            this.egg.removeEventListener("showItems",this.showOutItem);
            if(this.egg.parent)
            {
               removeChild(this.egg);
            }
            this.egg = null;
         }
         if(this._newBoxBG)
         {
            ObjectUtils.disposeObject(this._newBoxBG);
         }
         this._newBoxBG = null;
         if(this.countNum)
         {
            ObjectUtils.disposeObject(this.countNum);
         }
         this.countNum = null;
         if(this.flushBnt)
         {
            ObjectUtils.disposeObject(this.flushBnt);
         }
         this.flushBnt = null;
         if(this._help_btn)
         {
            ObjectUtils.disposeObject(this._help_btn);
         }
         this._help_btn = null;
         if(this.openCardTimes)
         {
            ObjectUtils.disposeObject(this.openCardTimes);
         }
         this.openCardTimes = null;
         if(this._newBoxBG)
         {
            ObjectUtils.disposeObject(this._newBoxBG);
         }
         this._newBoxBG = null;
         if(this.startBnt)
         {
            ObjectUtils.disposeObject(this.startBnt);
         }
         this.startBnt = null;
         if(this.msgText)
         {
            ObjectUtils.disposeObject(this.msgText);
         }
         this.msgText = null;
         if(this.newBoxView)
         {
            this.newBoxView.dispose();
         }
         this.newBoxView = null;
         if(this.frame)
         {
            this.frame.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this.frame.dispose();
         }
         this.helpPageDispose();
         if(this.eyepic)
         {
            ObjectUtils.disposeObject(this.eyepic);
            this.eyepic = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         LaterEquipmentGoodView.isShow = true;
         super.dispose();
      }
   }
}
