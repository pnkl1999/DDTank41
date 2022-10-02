package church.view.churchScene
{
   import church.events.WeddingRoomEvent;
   import church.model.ChurchRoomModel;
   import church.player.ChurchPlayer;
   import church.view.churchFire.ChurchFireEffectPlayer;
   import church.vo.PlayerVO;
   import church.vo.SceneMapVO;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class SceneMap extends Sprite
   {
      
      public static const SCENE_ALLOW_FIRES:int = 6;
       
      
      private const CLICK_INTERVAL:Number = 200;
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      protected var skyLayer:Sprite;
      
      public var sceneScene:SceneScene;
      
      protected var _data:DictionaryData;
      
      protected var _characters:DictionaryData;
      
      protected var _selfPlayer:ChurchPlayer;
      
      private var last_click:Number;
      
      private var current_display_fire:int = 0;
      
      private var _mouseMovie:MovieClip;
      
      private var _currentLoadingPlayer:ChurchPlayer;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _sceneMapVO:SceneMapVO;
      
      private var _model:ChurchRoomModel;
      
      protected var reference:ChurchPlayer;
      
      public function SceneMap(param1:ChurchRoomModel, param2:SceneScene, param3:DictionaryData, param4:Sprite, param5:Sprite, param6:Sprite = null, param7:Sprite = null)
      {
         super();
         this._model = param1;
         this.sceneScene = param2;
         this._data = param3;
         if(param4 == null)
         {
            this.bgLayer = new Sprite();
         }
         else
         {
            this.bgLayer = param4;
         }
         this.meshLayer = param5 == null ? new Sprite() : param5;
         this.meshLayer.alpha = 0;
         this.articleLayer = param6 == null ? new Sprite() : param6;
         this.skyLayer = param7 == null ? new Sprite() : param7;
         this.addChild(this.meshLayer);
         this.addChild(this.bgLayer);
         this.addChild(this.articleLayer);
         this.addChild(this.skyLayer);
         this.init();
         this.addEvent();
      }
      
      public function get sceneMapVO() : SceneMapVO
      {
         return this._sceneMapVO;
      }
      
      public function set sceneMapVO(param1:SceneMapVO) : void
      {
         this._sceneMapVO = param1;
      }
      
      protected function init() : void
      {
         this._characters = new DictionaryData(true);
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.church.room.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this.last_click = 0;
      }
      
      protected function addEvent() : void
      {
         this._model.addEventListener(WeddingRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.addEventListener(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         this._model.addEventListener(WeddingRoomEvent.PLAYER_FIRE_VISIBLE,this.menuChange);
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
      }
      
      private function menuChange(param1:WeddingRoomEvent) : void
      {
         switch(param1.type)
         {
            case WeddingRoomEvent.PLAYER_NAME_VISIBLE:
               this.nameVisible();
               break;
            case WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE:
               this.chatBallVisible();
               break;
            case WeddingRoomEvent.PLAYER_FIRE_VISIBLE:
               this.fireVisible();
         }
      }
      
      public function nameVisible() : void
      {
         var _loc1_:ChurchPlayer = null;
         for each(_loc1_ in this._characters)
         {
            _loc1_.isShowName = this._model.playerNameVisible;
         }
      }
      
      public function chatBallVisible() : void
      {
         var _loc1_:ChurchPlayer = null;
         for each(_loc1_ in this._characters)
         {
            _loc1_.isChatBall = this._model.playerChatBallVisible;
         }
      }
      
      public function fireVisible() : void
      {
      }
      
      protected function updateMap(param1:Event) : void
      {
         var _loc2_:ChurchPlayer = null;
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(_loc2_ in this._characters)
         {
            _loc2_.updatePlayer();
            _loc2_.isChatBall = this._model.playerChatBallVisible;
            _loc2_.isShowName = this._model.playerNameVisible;
         }
         this.BuildEntityDepth();
      }
      
      protected function __click(param1:MouseEvent) : void
      {
         if(!this._selfPlayer)
         {
            return;
         }
         var _loc2_:Point = this.globalToLocal(new Point(param1.stageX,param1.stageY));
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this.sceneScene.hit(_loc2_))
            {
               this._selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this._selfPlayer.playerPoint,_loc2_);
               this._selfPlayer.playerVO.walkPath.shift();
               this._selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this._selfPlayer.playerPoint,this._selfPlayer.playerVO.walkPath[0]);
               this._selfPlayer.playerVO.currentWalkStartPoint = this._selfPlayer.currentWalkStartPoint;
               this.sendMyPosition(this._selfPlayer.playerVO.walkPath.concat());
               this._mouseMovie.x = _loc2_.x;
               this._mouseMovie.y = _loc2_.y;
               this._mouseMovie.play();
            }
         }
      }
      
      public function sendMyPosition(param1:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = [];
         while(_loc3_ < param1.length)
         {
            _loc2_.push(int(param1[_loc3_].x),int(param1[_loc3_].y));
            _loc3_++;
         }
         var _loc4_:String = _loc2_.toString();
         SocketManager.Instance.out.sendChurchMove(param1[param1.length - 1].x,param1[param1.length - 1].y,_loc4_);
      }
      
      public function useFire(param1:int, param2:int) : void
      {
         var _loc3_:ChurchFireEffectPlayer = null;
         _loc3_ = null;
         if(this._characters[param1] == null)
         {
            return;
         }
         if(this._characters[param1])
         {
            if(param1 == PlayerManager.Instance.Self.ID)
            {
               this._model.fireEnable = false;
               if(!this._model.playerFireVisible)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.scene.SceneMap.lihua"));
               }
            }
            _loc3_ = new ChurchFireEffectPlayer(param2);
            _loc3_.addEventListener(Event.COMPLETE,this.fireCompleteHandler);
            _loc3_.owerID = param1;
            if(this._model.playerFireVisible)
            {
               _loc3_.x = (this._characters[param1] as ChurchPlayer).x;
               _loc3_.y = (this._characters[param1] as ChurchPlayer).y - 190;
               addChild(_loc3_);
            }
            _loc3_.firePlayer();
         }
      }
      
      protected function fireCompleteHandler(param1:Event) : void
      {
         var _loc2_:ChurchFireEffectPlayer = param1.currentTarget as ChurchFireEffectPlayer;
         _loc2_.removeEventListener(Event.COMPLETE,this.fireCompleteHandler);
         if(_loc2_.owerID == PlayerManager.Instance.Self.ID)
         {
            this._model.fireEnable = true;
         }
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         var _loc3_:ChurchPlayer = null;
         if(this._characters[param1])
         {
            _loc3_ = this._characters[param1] as ChurchPlayer;
            _loc3_.playerVO.walkPath = param2;
            _loc3_.playerWalk(param2);
         }
      }
      
      public function setCenter(param1:SceneCharacterEvent = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.reference)
         {
            _loc2_ = -(this.reference.x - MoonSceneMap.GAME_WIDTH / 2);
            _loc3_ = -(this.reference.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         else
         {
            _loc2_ = -(this._sceneMapVO.defaultPos.x - MoonSceneMap.GAME_WIDTH / 2);
            _loc3_ = -(this._sceneMapVO.defaultPos.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         if(_loc2_ > 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ < MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW)
         {
            _loc2_ = MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW;
         }
         if(_loc3_ > 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ < MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH)
         {
            _loc3_ = MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH;
         }
         x = _loc2_;
         y = _loc3_;
      }
      
      public function addSelfPlayer() : void
      {
         var _loc1_:PlayerVO = null;
         if(!this._selfPlayer)
         {
            _loc1_ = new PlayerVO();
            _loc1_.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new ChurchPlayer(_loc1_,this.addPlayerCallBack);
         }
      }
      
      protected function ajustScreen(param1:ChurchPlayer) : void
      {
         if(param1 == null)
         {
            if(this.reference)
            {
               this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
               this.reference = null;
            }
            return;
         }
         if(this.reference)
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         this.reference = param1;
         this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      protected function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerVO = param1.data as PlayerVO;
         this._currentLoadingPlayer = new ChurchPlayer(_loc2_,this.addPlayerCallBack);
      }
      
      private function addPlayerCallBack(param1:ChurchPlayer, param2:Boolean) : void
      {
         if(!this.articleLayer || !param1)
         {
            return;
         }
         this._currentLoadingPlayer = null;
         param1.sceneScene = this.sceneScene;
         param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.playerVO.scenePlayerDirection;
         if(!this._selfPlayer && param1.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            param1.playerVO.playerPos = this._sceneMapVO.defaultPos;
            this._selfPlayer = param1;
            this.articleLayer.addChild(this._selfPlayer);
            this.ajustScreen(this._selfPlayer);
            this.setCenter();
            this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         else
         {
            this.articleLayer.addChild(param1);
         }
         param1.playerPoint = param1.playerVO.playerPos;
         param1.sceneCharacterStateType = "natural";
         this._characters.add(param1.playerVO.playerInfo.ID,param1);
         param1.isShowName = this._model.playerNameVisible;
         param1.isChatBall = this._model.playerChatBallVisible;
      }
      
      private function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
         }
      }
      
      protected function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:int = (param1.data as PlayerVO).playerInfo.ID;
         var _loc3_:ChurchPlayer = this._characters[_loc2_] as ChurchPlayer;
         this._characters.remove(_loc2_);
         if(_loc3_)
         {
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            _loc3_.dispose();
         }
         _loc3_ = null;
      }
      
      protected function BuildEntityDepth() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc1_:int = this.articleLayer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_ - 1)
         {
            _loc3_ = this.articleLayer.getChildAt(_loc2_);
            _loc4_ = this.getPointDepth(_loc3_.x,_loc3_.y);
            _loc6_ = Number.MAX_VALUE;
            _loc7_ = _loc2_ + 1;
            while(_loc7_ < _loc1_)
            {
               _loc8_ = this.articleLayer.getChildAt(_loc7_);
               _loc9_ = this.getPointDepth(_loc8_.x,_loc8_.y);
               if(_loc9_ < _loc6_)
               {
                  _loc5_ = _loc7_;
                  _loc6_ = _loc9_;
               }
               _loc7_++;
            }
            if(_loc4_ > _loc6_)
            {
               this.articleLayer.swapChildrenAt(_loc2_,_loc5_);
            }
            _loc2_++;
         }
      }
      
      protected function getPointDepth(param1:Number, param2:Number) : Number
      {
         return this.sceneMapVO.mapW * param2 + param1;
      }
      
      public function setSalute(param1:int) : void
      {
      }
      
      protected function removeEvent() : void
      {
         this._model.removeEventListener(WeddingRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.removeEventListener(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         this._model.removeEventListener(WeddingRoomEvent.PLAYER_FIRE_VISIBLE,this.menuChange);
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         if(this.reference)
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(this._selfPlayer)
         {
            this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
      }
      
      public function dispose() : void
      {
         var p:ChurchPlayer = null;
         var i:int = 0;
         var player:ChurchPlayer = null;
         this.removeEvent();
         this._data.clear();
         this._data = null;
         this._sceneMapVO = null;
         for each(p in this._characters)
         {
            if(p.parent)
            {
               p.parent.removeChild(p);
            }
            p.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            p.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            p.dispose();
            p = null;
         }
         this._characters.clear();
         this._characters = null;
         if(this.articleLayer)
         {
            i = this.articleLayer.numChildren;
            while(i > 0)
            {
               player = this.articleLayer.getChildAt(i - 1) as ChurchPlayer;
               if(player)
               {
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
                  if(player.parent)
                  {
                     player.parent.removeChild(player);
                  }
                  player.dispose();
               }
               player = null;
               try
               {
                  this.articleLayer.removeChildAt(i - 1);
               }
               catch(e:RangeError)
               {
               }
               i--;
            }
            if(this.articleLayer && this.articleLayer.parent)
            {
               this.articleLayer.parent.removeChild(this.articleLayer);
            }
         }
         this.articleLayer = null;
         if(this._selfPlayer)
         {
            if(this._selfPlayer.parent)
            {
               this._selfPlayer.parent.removeChild(this._selfPlayer);
            }
            this._selfPlayer.dispose();
         }
         this._selfPlayer = null;
         if(this._currentLoadingPlayer)
         {
            if(this._currentLoadingPlayer.parent)
            {
               this._currentLoadingPlayer.parent.removeChild(this._currentLoadingPlayer);
            }
            this._currentLoadingPlayer.dispose();
         }
         this._currentLoadingPlayer = null;
         if(this._mouseMovie && this._mouseMovie.parent)
         {
            this._mouseMovie.parent.removeChild(this._mouseMovie);
         }
         this._mouseMovie = null;
         if(this.meshLayer && this.meshLayer.parent)
         {
            this.meshLayer.parent.removeChild(this.meshLayer);
         }
         this.meshLayer = null;
         if(this.bgLayer && this.bgLayer.parent)
         {
            this.bgLayer.parent.removeChild(this.bgLayer);
         }
         this.bgLayer = null;
         if(this.skyLayer && this.skyLayer.parent)
         {
            this.skyLayer.parent.removeChild(this.skyLayer);
         }
         this.skyLayer = null;
         this.sceneScene = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
