package farm.player
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import farm.player.vo.GiftPacksTips;
   import farm.player.vo.PlayerVO;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import vip.VipController;
   
   public class FarmPlayer extends FarmPlayerBase
   {
       
      
      private var _playerVO:PlayerVO;
      
      private var _currentWalkStartPoint:Point;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = false;
      
      private var _spName:Sprite;
      
      private var _lblName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _sceneScene:SceneScene;
      
      private var _chatBallView:ChatBallPlayer;
      
      private var _chatTimer:Timer;
      
      private var _giftPacks:GiftPacksTips;
      
      private var _clickFlag:Boolean;
      
      public function FarmPlayer(param1:PlayerVO, param2:Function = null)
      {
         this._playerVO = param1;
         this._currentWalkStartPoint = this._playerVO.playerPos;
         super(param1.playerInfo,param2);
         this.initialize();
      }
      
      private function initialize() : void
      {
         var _loc1_:int = 0;
         moveSpeed = this._playerVO.playerMoveSpeed;
         if(this._isShowName)
         {
            if(!this._lblName)
            {
               this._lblName = ComponentFactory.Instance.creat("farm.playerInfo.lblName");
            }
            this._lblName.mouseEnabled = false;
            this._lblName.text = this.playerVO && this.playerVO.playerInfo && this.playerVO.playerInfo.NickName ? this.playerVO.playerInfo.NickName : "";
            this._lblName.textColor = 6029065;
            if(!this._spName)
            {
               this._spName = new Sprite();
            }
            if(this.playerVO.playerInfo.IsVIP)
            {
               this._vipName = VipController.instance.getVipNameTxt(-1,this.playerVO.playerInfo.typeVIP);
               this._vipName.textSize = 16;
               this._vipName.x = this._lblName.x;
               this._vipName.y = this._lblName.y;
               this._vipName.text = this._lblName.text;
               this._spName.addChild(this._vipName);
               DisplayUtils.removeDisplay(this._lblName);
            }
            else
            {
               this._spName.addChild(this._lblName);
               DisplayUtils.removeDisplay(this._vipName);
            }
            if(this.playerVO.playerInfo.IsVIP && !this._vipIcon)
            {
               this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.farm.VipIcon");
               if(this.playerVO.playerInfo.typeVIP >= 2)
               {
                  this._vipIcon.y -= 5;
               }
               this._vipIcon.setInfo(this.playerVO.playerInfo,false);
            }
            if(this._vipIcon)
            {
               this._spName.addChild(this._vipIcon);
               this._lblName.x = this._vipIcon.x + this._vipIcon.width;
               if(this._vipName)
               {
                  this._vipName.x = this._lblName.x;
               }
            }
            this._spName.x = (playerWitdh - this._spName.width) / 2 - playerWitdh / 2;
            this._spName.y = -playerHeight;
            this._spName.graphics.beginFill(0,0.5);
            _loc1_ = !!Boolean(this._vipIcon) ? int(int(this._lblName.textWidth + this._vipIcon.width)) : int(int(this._lblName.textWidth + 8));
            if(this.playerVO.playerInfo.IsVIP)
            {
               _loc1_ = !!Boolean(this._vipIcon) ? int(int(this._vipName.width + this._vipIcon.width + 8)) : int(int(this._vipName.width + 8));
               this._spName.x = (playerWitdh - (this._vipIcon.width + this._vipName.width)) / 2 - playerWitdh / 2;
            }
            this._spName.graphics.drawRoundRect(-4,0,_loc1_,22,5,5);
            this._spName.graphics.endFill();
            addChildAt(this._spName,0);
            this._spName.visible = this._isShowName;
         }
         else
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
            ObjectUtils.disposeObject(this._lblName);
            this._lblName = null;
         }
         this.initEvent();
      }
      
      public function set isChatBall(param1:Boolean) : void
      {
         if(param1)
         {
            this._isChatBall = param1;
            if(!this._chatTimer)
            {
               this._chatTimer = new Timer(8000);
            }
            this.__onTimerHandle(null);
            this._chatTimer.addEventListener(TimerEvent.TIMER,this.__onTimerHandle);
            this._chatTimer.start();
            this.addGiftPacks();
         }
         else
         {
            this.deleteChatTimer();
         }
      }
      
      private function deleteChatTimer() : void
      {
         if(this._chatTimer)
         {
            this._chatTimer.stop();
            this._chatTimer.reset();
            this._chatTimer.removeEventListener(TimerEvent.TIMER,this.__onTimerHandle);
            this._chatTimer = null;
         }
      }
      
      public function get isChatBall() : Boolean
      {
         return this._isChatBall;
      }
      
      private function addGiftPacks() : void
      {
         this.deleteGiftPacks();
         this._giftPacks = new GiftPacksTips();
         PositionUtils.setPos(this._giftPacks,"farm.player.getPacks");
         LayerManager.Instance.addToLayer(this._giftPacks,LayerManager.GAME_DYNAMIC_LAYER);
         this._giftPacks.visible = false;
         addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function __onTimerHandle(param1:TimerEvent) : void
      {
         this.deleteChatBallView();
         this._chatBallView = new ChatBallPlayer();
         this._chatBallView.x = (playerWitdh - this._chatBallView.width) / 2 - playerWitdh / 2;
         this._chatBallView.y = -playerHeight + 40;
         addChildAt(this._chatBallView,this.getChildIndex(character) + 1);
         this._chatBallView.setText(LanguageMgr.GetTranslation("ddt.farms.playerSpeakInfo"),this._playerVO.playerInfo.paopaoType);
      }
      
      private function initEvent() : void
      {
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
         if(this._giftPacks)
         {
            SoundManager.instance.play("008");
            param1.stopImmediatePropagation();
            this._giftPacks.visible = true;
            this._giftPacks.addEventListener(MouseEvent.CLICK,this.__onGiftPacksClick);
            stage.addEventListener(MouseEvent.CLICK,this.__clearGiftPacks);
         }
      }
      
      protected function __clearGiftPacks(param1:MouseEvent) : void
      {
         this._giftPacks.visible = false;
      }
      
      protected function __onGiftPacksClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._giftPacks.removeEventListener(MouseEvent.CLICK,this.__onGiftPacksClick);
         this._giftPacks.visible = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.farms.playerGiftPacksText"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.giftPacks(this._playerVO.playerInfo.ID);
         }
      }
      
      private function characterDirectionChange(param1:SceneCharacterEvent) : void
      {
         SoundManager.instance.play("008");
         this._playerVO.scenePlayerDirection = sceneCharacterDirection;
         if(Boolean(param1.data))
         {
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkBack";
               }
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkFront";
               }
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
         }
      }
      
      public function updatePlayer() : void
      {
         this.refreshCharacterState();
         this.characterMirror();
         this.playerWalkPath();
         update();
      }
      
      public function refreshCharacterState() : void
      {
         if((sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkBack";
         }
         else if((sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkFront";
         }
         moveSpeed = this._playerVO.playerMoveSpeed;
      }
      
      private function characterMirror() : void
      {
         if(!isDefaultCharacter)
         {
            this.character.scaleX = !!sceneCharacterDirection.isMirror ? Number(Number(-1)) : Number(Number(1));
            this.character.x = !!sceneCharacterDirection.isMirror ? Number(Number(playerWitdh / 2)) : Number(Number(-playerWitdh / 2));
         }
         else
         {
            this.character.scaleX = 1;
            this.character.x = -playerWitdh / 2;
         }
         this.character.y = -playerHeight + 12;
      }
      
      private function playerWalkPath() : void
      {
         if(_walkPath != null && _walkPath.length > 0 && this._playerVO.walkPath.length > 0 && _walkPath != this._playerVO.walkPath)
         {
            this.fixPlayerPath();
         }
         if(this._playerVO && this._playerVO.walkPath && this._playerVO.walkPath.length <= 0 && !_tween.isPlaying)
         {
            return;
         }
         this.playerWalk(this._playerVO.walkPath);
      }
      
      override public function playerWalk(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         if(_walkPath != null && _tween.isPlaying && _walkPath == this._playerVO.walkPath)
         {
            return;
         }
         _walkPath = this._playerVO.walkPath;
         if(_walkPath && _walkPath.length > 0)
         {
            this._currentWalkStartPoint = _walkPath[0];
            sceneCharacterDirection = SceneCharacterDirection.getDirection(playerPoint,this._currentWalkStartPoint);
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,true));
            _loc2_ = Point.distance(this._currentWalkStartPoint,playerPoint);
            _tween.start(_loc2_ / _moveSpeed,"x",this._currentWalkStartPoint.x,"y",this._currentWalkStartPoint.y);
            _walkPath.shift();
         }
         else
         {
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         }
      }
      
      public function set setSceneCharacterDirectionDefault(param1:SceneCharacterDirection) : void
      {
         if(param1 == SceneCharacterDirection.LT || param1 == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(param1 == SceneCharacterDirection.LB || param1 == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
         }
      }
      
      private function fixPlayerPath() : void
      {
         var _loc3_:Array = null;
         if(this._playerVO.currentWalkStartPoint == null)
         {
            return;
         }
         var _loc1_:int = -1;
         var _loc2_:int = 0;
         while(_loc2_ < _walkPath.length)
         {
            if(_walkPath[_loc2_].x == this._playerVO.currentWalkStartPoint.x && _walkPath[_loc2_].y == this._playerVO.currentWalkStartPoint.y)
            {
               _loc1_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         if(_loc1_ > 0)
         {
            _loc3_ = _walkPath.slice(0,_loc1_);
            this._playerVO.walkPath = _loc3_.concat(this._playerVO.walkPath);
         }
      }
      
      private function deleteChatBallView() : void
      {
         if(this._chatBallView)
         {
            this._chatBallView.clear();
            if(this._chatBallView.parent)
            {
               this._chatBallView.parent.removeChild(this._chatBallView);
            }
            this._chatBallView.dispose();
         }
         this._chatBallView = null;
      }
      
      private function deleteGiftPacks() : void
      {
         if(this._giftPacks)
         {
            if(this._giftPacks.parent)
            {
               this._giftPacks.parent.removeChild(this._giftPacks);
            }
            this._giftPacks.dispose();
         }
         this._giftPacks = null;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         removeEventListener(MouseEvent.CLICK,this.__onClick);
         if(this._giftPacks)
         {
            this._giftPacks.removeEventListener(MouseEvent.CLICK,this.__onGiftPacksClick);
         }
         stage.removeEventListener(MouseEvent.CLICK,this.__clearGiftPacks);
      }
      
      public function get currentWalkStartPoint() : Point
      {
         return this._currentWalkStartPoint;
      }
      
      public function get isShowName() : Boolean
      {
         return this._isShowName;
      }
      
      public function set isShowName(param1:Boolean) : void
      {
         this._isShowName = param1;
         if(!this._spName)
         {
            return;
         }
         this._spName.visible = this._isShowName;
      }
      
      public function get playerVO() : PlayerVO
      {
         return this._playerVO;
      }
      
      public function set playerVO(param1:PlayerVO) : void
      {
         this._playerVO = param1;
      }
      
      public function get sceneScene() : SceneScene
      {
         return this._sceneScene;
      }
      
      public function set sceneScene(param1:SceneScene) : void
      {
         this._sceneScene = param1;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.isChatBall = false;
         if(this._playerVO)
         {
            this._playerVO = null;
         }
         if(this._currentWalkStartPoint)
         {
            this._currentWalkStartPoint = null;
         }
         if(this._spName)
         {
            ObjectUtils.disposeObject(this._spName);
            this._spName = null;
         }
         if(this._lblName)
         {
            this._lblName.dispose();
            this._lblName = null;
         }
         if(this._vipName)
         {
            this._vipName.dispose();
            this._vipName = null;
         }
         if(this._vipIcon)
         {
            this._vipIcon.dispose();
            this._vipIcon = null;
         }
         if(this._sceneScene)
         {
            this._sceneScene.dispose();
            this._sceneScene = null;
         }
         this.deleteChatBallView();
         this.deleteGiftPacks();
         this.deleteChatTimer();
         super.dispose();
      }
      
      public function get giftPacks() : GiftPacksTips
      {
         return this._giftPacks;
      }
   }
}
