package hotSpring.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.Helpers;
   import ddt.view.FaceContainer;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatInputView;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Sprite;
   import flash.geom.Point;
   import hotSpring.event.HotSpringRoomPlayerEvent;
   import hotSpring.view.HotSpringRoomView;
   import hotSpring.vo.PlayerVO;
   import vip.VipController;
   
   public class HotSpringPlayer extends HotSpringPlayerBase
   {
       
      
      private var _playerVO:PlayerVO;
      
      private var _wavePlayerAsset:ScaleFrameImage;
      
      private var _inWaterShowAsset:ScaleFrameImage;
      
      private var _sceneScene:SceneScene;
      
      private var _spName:Sprite;
      
      private var _lblName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _isShowPlayer:Boolean = true;
      
      private var _chatBallView:ChatBallPlayer;
      
      private var _face:FaceContainer;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _currentWalkStartPoint:Point;
      
      public function HotSpringPlayer(param1:PlayerVO, param2:Function = null)
      {
         this._playerVO = param1;
         this._currentWalkStartPoint = this._playerVO.playerPos;
         super(this._playerVO.playerInfo,param2);
         this.initialize();
         this.setEvent();
      }
      
      private function initialize() : void
      {
         moveSpeed = this._playerVO.playerMoveSpeed;
         this.initPlayerName();
         if(this._isChatBall)
         {
            if(!this._chatBallView)
            {
               this._chatBallView = new ChatBallPlayer();
            }
            this._chatBallView.x = (playerWitdh - this._chatBallView.width) / 2 - playerWitdh / 2;
            this._chatBallView.y = -playerHeight + 40;
            addChild(this._chatBallView);
         }
         else
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
         this._face = new FaceContainer(true);
         this._face.x = (playerWitdh - this._face.width) / 2 - playerWitdh / 2;
         this._face.y = -90;
         addChild(this._face);
      }
      
      private function initPlayerName() : void
      {
         var _loc1_:int = 0;
         if(!this.playerVO.playerInfo)
         {
            return;
         }
         if(this._isShowName)
         {
            if(!this._lblName)
            {
               this._lblName = ComponentFactory.Instance.creat("asset.hotSpring.room.playerNickName");
            }
            this._lblName.mouseEnabled = false;
            this._lblName.text = this.playerVO && this.playerVO.playerInfo && this.playerVO.playerInfo.NickName ? this.playerVO.playerInfo.NickName : "";
            if(this._spName && this._spName.parent)
            {
               removeChild(this._spName);
            }
            this._spName = null;
            this._spName = new Sprite();
            if(this.playerVO.playerInfo.IsVIP)
            {
               if(!this._vipName)
               {
                  this._vipName = VipController.instance.getVipNameTxt(-1,this.playerVO.playerInfo.typeVIP);
               }
               this._vipName.textSize = 16;
               this._vipName.x = this._lblName.x;
               this._vipName.y = this._lblName.y;
               this._vipName.text = this._lblName.text;
               this._spName.addChild(this._vipName);
               this._lblName.visible = false;
               this._vipName.visible = true;
            }
            else
            {
               this._spName.addChild(this._lblName);
               this._lblName.visible = true;
               if(this._vipName)
               {
                  this._vipName.visible = false;
               }
               if(this._vipIcon)
               {
                  this._vipIcon.visible = false;
               }
            }
            if(this.playerVO.playerInfo.IsVIP && !this._vipIcon)
            {
               this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.hotSpring.VipIcon");
               if(this.playerVO.playerInfo.typeVIP >= 2)
               {
                  this._vipIcon.y -= 5;
               }
               this._vipIcon.setInfo(this.playerVO.playerInfo,false);
            }
            if(this.playerVO.playerInfo.IsVIP && this._vipIcon)
            {
               this._vipIcon.visible = true;
               this._spName.addChild(this._vipIcon);
               if(this._vipName)
               {
                  this._vipName.x = this._vipIcon.x + this._vipIcon.width;
               }
            }
            this._spName.x = (playerWitdh - this._spName.width) / 2 - playerWitdh / 2;
            this._spName.y = -playerHeight + 10;
            this._spName.graphics.beginFill(0,0.5);
            _loc1_ = this.playerVO.playerInfo.IsVIP && this._vipIcon ? int(int(this._lblName.textWidth + this._vipIcon.width)) : int(int(this._lblName.textWidth + 8));
            if(this.playerVO.playerInfo.IsVIP)
            {
               _loc1_ = !!Boolean(this._vipIcon) ? int(int(this._vipName.width + this._vipIcon.width + 8)) : int(int(this._vipName.width + 8));
               this._spName.x = (playerWitdh - (this._vipIcon.width + this._vipName.width)) / 2 - playerWitdh / 2;
            }
            this._spName.graphics.drawRoundRect(-4,0,_loc1_,22,5,5);
            this._spName.graphics.endFill();
            addChild(this._spName);
         }
         else
         {
            if(this._spName)
            {
               ObjectUtils.disposeObject(this._spName);
            }
            this._spName = null;
            if(this._vipName)
            {
               ObjectUtils.disposeObject(this._vipName);
            }
            this._vipName = null;
            if(this._lblName)
            {
               ObjectUtils.disposeObject(this._lblName);
            }
            this._lblName = null;
            if(this._vipIcon)
            {
               ObjectUtils.disposeObject(this._vipIcon);
            }
            this._vipIcon = null;
         }
      }
      
      private function setEvent() : void
      {
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         this._playerVO.addEventListener(HotSpringRoomPlayerEvent.PLAYER_POS_CHANGE,this.__onplayerPosChangeImp);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         this._playerVO.playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
      }
      
      private function __changeHandler(param1:PlayerPropertyEvent) : void
      {
         if(!this._playerVO)
         {
            return;
         }
         this.initPlayerName();
      }
      
      private function __onplayerPosChangeImp(param1:HotSpringRoomPlayerEvent) : void
      {
         playerPoint = this._playerVO.playerPos;
      }
      
      private function characterDirectionChange(param1:SceneCharacterEvent) : void
      {
         this._playerVO.scenePlayerDirection = sceneCharacterDirection;
         if(Boolean(param1.data))
         {
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkBack";
               }
               else
               {
                  sceneCharacterActionType = "waterBack";
               }
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkFront";
               }
               else
               {
                  sceneCharacterActionType = "waterFront";
               }
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
            else
            {
               sceneCharacterActionType = "waterStandBack";
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
            else
            {
               sceneCharacterActionType = "waterFrontEyes";
            }
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
            else
            {
               sceneCharacterActionType = "waterStandBack";
            }
         }
         else if(param1 == SceneCharacterDirection.LB || param1 == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
            else
            {
               sceneCharacterActionType = "waterFrontEyes";
            }
         }
      }
      
      public function updatePlayer() : void
      {
         this.areaTest();
         this.characterMirror();
         this.setPlayer();
         this.playerWalkPath();
         update();
      }
      
      private function characterMirror() : void
      {
         if(character)
         {
            character.scaleX = !!sceneCharacterDirection.isMirror ? Number(Number(-1)) : Number(Number(1));
            character.x = !!sceneCharacterDirection.isMirror ? Number(Number(playerWitdh / 2)) : Number(Number(-playerWitdh / 2));
            character.y = this._playerVO.currentlyArea == 1 ? Number(Number(-playerHeight + 12)) : Number(Number(-playerHeight + 63));
         }
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
         if(this._playerVO)
         {
            this.playerWalk(this._playerVO.walkPath);
         }
      }
      
      override public function playerWalk(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         if(_walkPath != null && _tween.isPlaying && _walkPath == this._playerVO.walkPath)
         {
            return;
         }
         _walkPath = this._playerVO.walkPath;
         if(_walkPath.length > 0)
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
      
      public function get currentWalkStartPoint() : Point
      {
         return this._currentWalkStartPoint;
      }
      
      private function setPlayer() : void
      {
         if(this._playerVO)
         {
            if(this._playerVO.currentlyArea == 2)
            {
               if(!this._wavePlayerAsset)
               {
                  this._wavePlayerAsset = ComponentFactory.Instance.creat("hotSpring.room.wavePlayerAsset");
                  this._wavePlayerAsset.setFrame(this._wavePlayerAsset.getFrame + 1);
                  this._wavePlayerAsset.y = -playerHeight + 103;
               }
               if(!this._wavePlayerAsset.parent)
               {
                  addChild(this._wavePlayerAsset);
               }
               if(this._wavePlayerAsset.getFrame >= this._wavePlayerAsset.totalFrames)
               {
                  this._wavePlayerAsset.setFrame(1);
               }
               this._wavePlayerAsset.setFrame(this._wavePlayerAsset.getFrame + 1);
               if(sceneCharacterDirection.isMirror)
               {
                  this._wavePlayerAsset.scaleX = !!this._playerVO.playerInfo.Sex ? Number(Number(-1.1)) : Number(Number(-1));
                  if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
                  {
                     this._wavePlayerAsset.x = !!this._playerVO.playerInfo.Sex ? Number(Number(playerWitdh / 2 + 4)) : Number(Number(playerWitdh / 2 - 2));
                  }
                  else
                  {
                     this._wavePlayerAsset.x = !!this._playerVO.playerInfo.Sex ? Number(Number(playerWitdh / 2 + 4)) : Number(Number(playerWitdh / 2));
                  }
               }
               else
               {
                  this._wavePlayerAsset.scaleX = !!this._playerVO.playerInfo.Sex ? Number(Number(1.1)) : Number(Number(1));
                  if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
                  {
                     this._wavePlayerAsset.x = !!this._playerVO.playerInfo.Sex ? Number(Number(-playerWitdh / 2 - 4)) : Number(Number(-playerWitdh / 2 + 2));
                  }
                  else
                  {
                     this._wavePlayerAsset.x = !!this._playerVO.playerInfo.Sex ? Number(Number(-playerWitdh / 2 - 4)) : Number(Number(-playerWitdh / 2));
                  }
               }
               if(this._inWaterShowAsset)
               {
                  this._inWaterShowAsset.y = -playerHeight + 63;
               }
               if(this._spName)
               {
                  this._spName.y = -playerHeight + 63;
               }
               if(this._face)
               {
                  this._face.y = -38;
               }
               if(this._chatBallView)
               {
                  this._chatBallView.y = -playerHeight + 90;
               }
               addChildAt(this._chatBallView,numChildren);
            }
            else
            {
               if(this._wavePlayerAsset)
               {
                  if(this._wavePlayerAsset.parent)
                  {
                     this._wavePlayerAsset.parent.removeChild(this._wavePlayerAsset);
                  }
                  this._wavePlayerAsset.setFrame(1);
               }
               if(this._inWaterShowAsset)
               {
                  this._inWaterShowAsset.y = -playerHeight;
               }
               if(this._spName)
               {
                  this._spName.y = -playerHeight + 10;
               }
               if(this._face)
               {
                  this._face.y = -90;
               }
               if(this._chatBallView)
               {
                  this._chatBallView.y = -playerHeight + 40;
               }
               addChildAt(this._chatBallView,numChildren);
            }
         }
      }
      
      private function areaTest() : void
      {
         if(!HotSpringRoomView || !this._playerVO)
         {
            return;
         }
         var _loc1_:int = HotSpringRoomView.getCurrentAreaType(x,y);
         if(_loc1_ != this._playerVO.currentlyArea)
         {
            this.playChangeStateMovie();
         }
         else
         {
            this.checkHidePlayerStageChangeMovie();
         }
         this._playerVO.currentlyArea = _loc1_;
         this.refreshCharacterState();
      }
      
      private function playChangeStateMovie() : void
      {
         if(this._inWaterShowAsset)
         {
            ObjectUtils.disposeObject(this._inWaterShowAsset);
            this._inWaterShowAsset = null;
         }
         character.visible = false;
         if(this._spName)
         {
            this._spName.visible = false;
         }
         this._face.visible = false;
         if(this._chatBallView && this._chatBallView.parent)
         {
            this._chatBallView.parent.removeChild(this._chatBallView);
         }
         this._inWaterShowAsset = ComponentFactory.Instance.creat("hotSpring.room.inWaterAsset");
         this._inWaterShowAsset.x = -(playerWitdh / 2);
         this._inWaterShowAsset.y = -playerHeight;
         addChild(this._inWaterShowAsset);
      }
      
      private function checkHidePlayerStageChangeMovie() : void
      {
         if(this._inWaterShowAsset)
         {
            this._inWaterShowAsset.setFrame(this._inWaterShowAsset.getFrame + 1);
            if(this._inWaterShowAsset.getFrame >= this._inWaterShowAsset.totalFrames)
            {
               this.showPlayer();
               ObjectUtils.disposeObject(this._inWaterShowAsset);
               this._inWaterShowAsset = null;
            }
         }
      }
      
      public function refreshCharacterState() : void
      {
         if(this._playerVO.currentlyArea == 1)
         {
            sceneCharacterStateType = "natural";
            if((sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT) && _tween.isPlaying)
            {
               sceneCharacterActionType = "naturalWalkBack";
            }
            else if((sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB) && _tween.isPlaying)
            {
               sceneCharacterActionType = "naturalWalkFront";
            }
         }
         else
         {
            sceneCharacterStateType = "water";
            if((sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT) && _tween.isPlaying)
            {
               sceneCharacterActionType = "waterBack";
            }
            else if((sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB) && _tween.isPlaying)
            {
               sceneCharacterActionType = "waterFront";
            }
         }
         moveSpeed = this._playerVO.playerMoveSpeed;
      }
      
      private function showPlayer() : void
      {
         if(this._playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            character.visible = true;
         }
         else
         {
            character.visible = this._isShowPlayer;
         }
         this.initPlayerName();
         this._face.visible = true;
         if(this._isChatBall)
         {
            addChildAt(this._chatBallView,0);
         }
         else if(this._chatBallView && this._chatBallView.parent)
         {
            this._chatBallView.parent.removeChild(this._chatBallView);
         }
      }
      
      private function __getChat(param1:ChatEvent) : void
      {
         if(!this._isChatBall || !param1.data)
         {
            return;
         }
         var _loc2_:ChatData = ChatData(param1.data).clone();
         if(!_loc2_)
         {
            return;
         }
         _loc2_.msg = Helpers.deCodeString(_loc2_.msg);
         if(_loc2_.channel == ChatInputView.PRIVATE || _loc2_.channel == ChatInputView.CONSORTIA)
         {
            return;
         }
         if(_loc2_ && this._playerVO.playerInfo && _loc2_.senderID == this._playerVO.playerInfo.ID)
         {
            this._chatBallView.setText(_loc2_.msg,this._playerVO.playerInfo.paopaoType);
         }
      }
      
      private function __getFace(param1:ChatEvent) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_["playerid"] == this._playerVO.playerInfo.ID)
         {
            this._face.setFace(_loc2_["faceid"]);
         }
      }
      
      public function get playerVO() : PlayerVO
      {
         return this._playerVO;
      }
      
      public function set playerVO(param1:PlayerVO) : void
      {
         this._playerVO = param1;
      }
      
      public function get isShowName() : Boolean
      {
         return this._isShowName;
      }
      
      public function set isShowName(param1:Boolean) : void
      {
         this._isShowName = param1;
         this.initPlayerName();
      }
      
      public function get isChatBall() : Boolean
      {
         return this._isChatBall;
      }
      
      public function set isChatBall(param1:Boolean) : void
      {
         if(this._isChatBall == param1 || !this._chatBallView)
         {
            return;
         }
         this._isChatBall = param1;
         if(this._isChatBall)
         {
            addChildAt(this._chatBallView,0);
         }
         else if(this._chatBallView && this._chatBallView.parent)
         {
            this._chatBallView.parent.removeChild(this._chatBallView);
         }
      }
      
      public function get isShowPlayer() : Boolean
      {
         return this._isShowPlayer;
      }
      
      public function set isShowPlayer(param1:Boolean) : void
      {
         this._isShowPlayer = param1;
         this.visible = this._isShowPlayer;
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
         removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         if(this._playerVO)
         {
            this._playerVO.removeEventListener(HotSpringRoomPlayerEvent.PLAYER_POS_CHANGE,this.__onplayerPosChangeImp);
         }
         if(this._playerVO && this._playerVO.playerInfo)
         {
            this._playerVO.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
         }
         this._sceneScene = null;
         ObjectUtils.disposeObject(this._inWaterShowAsset);
         this._inWaterShowAsset = null;
         ObjectUtils.disposeObject(this._wavePlayerAsset);
         this._wavePlayerAsset = null;
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
         if(this._face)
         {
            this._face.clearFace();
            if(this._face.parent)
            {
               this._face.parent.removeChild(this._face);
            }
            this._face.dispose();
         }
         this._face = null;
         if(this._vipIcon)
         {
            this._vipIcon.dispose();
         }
         this._vipIcon = null;
         if(this._playerVO)
         {
            this._playerVO.dispose();
         }
         this._playerVO = null;
         ObjectUtils.disposeObject(this._lblName);
         this._lblName = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this._spName && this._spName.parent)
         {
            this._spName.parent.removeChild(this._spName);
         }
         this._spName = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
