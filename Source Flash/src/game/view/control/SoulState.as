package game.view.control
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatFacePanel;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import game.model.LocalPlayer;
   import game.view.GameViewBase;
   import game.view.prop.CustomPropBar;
   import game.view.prop.SoulPropBar;
   import im.IMController;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import trainer.data.Step;
   
   public class SoulState extends ControlState
   {
       
      
      private var _psychicBar:PsychicBar;
      
      private var _propBar:SoulPropBar;
      
      private var _customPropBar:CustomPropBar;
      
      private var _tweenMax:TweenMax;
      
      private var _msgShape:DisplayObject;
      
      private var _fastChatBtn:SimpleBitmapButton;
      
      private var _faceBtn:SimpleBitmapButton;
      
      private var _fastMovie:MovieClip;
      
      private var _facePanel:ChatFacePanel;
      
      private var _facePanelPos:Point;
      
      private var _isREleaseFours:Boolean;
      
      public function SoulState(param1:LocalPlayer)
      {
         super(param1);
         mouseEnabled = false;
      }
      
      override protected function configUI() : void
      {
         _background = ComponentFactory.Instance.creatBitmap("asset.game.SoulState.Back");
         addChild(_background);
         this._tweenMax = TweenMax.to(_background,0.7,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":3305215,
               "alpha":0.8,
               "blurX":8,
               "blurY":8,
               "strength":2
            }
         });
         this._psychicBar = ComponentFactory.Instance.creatCustomObject("PsychicBar",[_self]);
         addChild(this._psychicBar);
         this._customPropBar = ComponentFactory.Instance.creatCustomObject("SoulCustomPropBar",[_self,FightControlBar.SOUL]);
         addChild(this._customPropBar);
         this._propBar = ComponentFactory.Instance.creatCustomObject("SoulPropBar",[_self]);
         addChild(this._propBar);
         this._faceBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.faceButton");
         this.setTip(this._faceBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.face"));
         addChild(this._faceBtn);
         this._facePanel = ComponentFactory.Instance.creatCustomObject("chat.FacePanel",[true]);
         this._facePanelPos = ComponentFactory.Instance.creatCustomObject("asset.soulState.facePanelPos");
         this._fastChatBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.chatButton");
         this.setTip(this._fastChatBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.chat"));
         addChild(this._fastChatBtn);
         this._fastMovie = ClassUtils.CreatInstance("asset.game.prop.chatMoive") as MovieClip;
         PositionUtils.setPos(this._fastMovie,"asset.game.chatmoviePos");
         this._fastChatBtn.addChild(this._fastMovie);
         if(IMController.Instance.hasUnreadMessage() && !IMController.Instance.cancelflashState)
         {
            this._fastMovie.gotoAndPlay(1);
         }
         else
         {
            this._fastMovie.gotoAndStop(this._fastMovie.totalFrames);
         }
         PositionUtils.setPos(this._faceBtn,"asset.soulState.facebtnPos");
         PositionUtils.setPos(this._fastChatBtn,"asset.soulState.fastbtnPos");
         super.configUI();
      }
      
      private function setTip(param1:BaseButton, param2:String) : void
      {
         param1.tipStyle = "ddt.view.tips.OneLineTip";
         param1.tipDirctions = "0";
         param1.tipGapV = 5;
         param1.tipData = param2;
      }
      
      override protected function addEvent() : void
      {
         StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.__onFrame);
         this._fastChatBtn.addEventListener(MouseEvent.CLICK,this.__fastChat);
         this._fastChatBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._fastChatBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._faceBtn.addEventListener(MouseEvent.CLICK,this.__face);
         this._facePanel.addEventListener(Event.SELECT,this.__onFaceSelect);
         IMController.Instance.addEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewHandler);
         IMController.Instance.addEventListener(IMController.NO_MESSAGE,this.__noMessageHandler);
      }
      
      protected function __noMessageHandler(param1:Event) : void
      {
         this._fastMovie.gotoAndStop(this._fastMovie.totalFrames);
      }
      
      protected function __hasNewHandler(param1:Event) : void
      {
         this._fastMovie.gotoAndPlay(1);
      }
      
      protected function __onFaceSelect(param1:Event) : void
      {
         ChatManager.Instance.sendFace(this._facePanel.selected);
         this._facePanel.setVisible = false;
         StageReferance.stage.focus = null;
      }
      
      protected function __face(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._facePanel.x = localToGlobal(new Point(this._facePanelPos.x,this._facePanelPos.y)).x;
         this._facePanel.y = localToGlobal(new Point(this._facePanelPos.x,this._facePanelPos.y)).y;
         this._facePanel.setVisible = true;
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         IMController.Instance.hideMessageBox();
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         if(KeyboardManager.isDown(Keyboard.SPACE))
         {
            return;
         }
         IMController.Instance.showMessageBox(this._fastChatBtn);
      }
      
      protected function __fastChat(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         ChatManager.Instance.switchVisible();
      }
      
      private function __onFrame(param1:Event) : void
      {
         if(!(StageReferance.stage.focus is TextField) && KeyboardManager.isDown(KeyStroke.VK_SPACE.getCode()))
         {
            _self.setCenter(_self.pos.x,_self.pos.y,true);
            (StateManager.getState(StateType.FIGHTING) as GameViewBase).map.lockFocusAt(new Point(_self.pos.x,_self.pos.y));
            this._isREleaseFours = false;
         }
         else if(!this._isREleaseFours)
         {
            (StateManager.getState(StateType.FIGHTING) as GameViewBase).map.releaseFocus();
            this._isREleaseFours = true;
         }
      }
      
      override protected function removeEvent() : void
      {
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__onFrame);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUpInStep1);
         if(this._fastChatBtn)
         {
            this._fastChatBtn.removeEventListener(MouseEvent.CLICK,this.__fastChat);
            this._fastChatBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this._fastChatBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         }
         if(this._faceBtn)
         {
            this._faceBtn.removeEventListener(MouseEvent.CLICK,this.__face);
         }
         if(this._facePanel)
         {
            this._facePanel.removeEventListener(Event.SELECT,this.__onFaceSelect);
         }
         IMController.Instance.removeEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewHandler);
         IMController.Instance.removeEventListener(IMController.NO_MESSAGE,this.__noMessageHandler);
      }
      
      override public function enter(param1:DisplayObjectContainer) : void
      {
         this._psychicBar.enter();
         this._customPropBar.enter();
         this._propBar.enter();
         if(this._tweenMax)
         {
            this._tweenMax.play();
         }
         super.enter(param1);
      }
      
      override public function leaving(param1:Function = null) : void
      {
         if(this._tweenMax)
         {
            this._tweenMax.pause();
         }
         super.leaving(param1);
      }
      
      override protected function tweenIn() : void
      {
         y = 600;
         TweenLite.to(this,0.3,{
            "y":503,
            "onComplete":this.enterComplete
         });
      }
      
      override protected function enterComplete() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GHOST_FIRST))
         {
            this._msgShape = ComponentFactory.Instance.creatBitmap("asset.game.ghost.msg1");
            this._msgShape.x = StageReferance.stageWidth - this._msgShape.width >> 1;
            this._msgShape.y = (StageReferance.stageHeight - this._msgShape.height >> 1) + this._msgShape.height * 2;
            this._msgShape.alpha = 0;
            _container.addChild(this._msgShape);
            TweenLite.to(this._msgShape,0.3,{
               "alpha":1,
               "y":StageReferance.stageHeight - this._msgShape.height >> 1
            });
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUpInStep1);
            SocketManager.Instance.out.syncWeakStep(Step.GHOST_FIRST);
         }
      }
      
      protected function __mouseUpInStep1(param1:MouseEvent) : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUpInStep1);
         if(this._msgShape)
         {
            TweenLite.killTweensOf(this._msgShape);
         }
         ObjectUtils.disposeObject(this._msgShape);
         this._msgShape = null;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._fastChatBtn);
         this._fastChatBtn = null;
         ObjectUtils.disposeObject(this._faceBtn);
         this._faceBtn = null;
         ObjectUtils.disposeObject(this._fastMovie);
         this._fastMovie = null;
         ObjectUtils.disposeObject(this._facePanel);
         this._facePanel = null;
         ObjectUtils.disposeObject(this._psychicBar);
         this._psychicBar = null;
         ObjectUtils.disposeObject(this._customPropBar);
         this._customPropBar = null;
         ObjectUtils.disposeObject(this._propBar);
         this._propBar = null;
         if(this._msgShape)
         {
            TweenLite.killTweensOf(this._msgShape);
         }
         ObjectUtils.disposeObject(this._msgShape);
         this._msgShape = null;
         if(this._tweenMax)
         {
            this._tweenMax.kill();
         }
         this._tweenMax = null;
         super.dispose();
      }
   }
}
