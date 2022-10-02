package game.view.map
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.PathInfo;
   import ddt.data.map.MapInfo;
   import ddt.events.GameEvent;
   import ddt.loader.MapLoader;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.view.FaceContainer;
   import ddt.view.chat.ChatEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Transform;
   import flash.system.IME;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import game.GameManager;
   import game.actions.ActionManager;
   import game.actions.BaseAction;
   import game.animations.AnimationLevel;
   import game.animations.AnimationSet;
   import game.animations.BaseSetCenterAnimation;
   import game.animations.IAnimate;
   import game.animations.NewHandAnimation;
   import game.animations.ShockingSetCenterAnimation;
   import game.animations.SpellSkillAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.TurnedLiving;
   import game.objects.GameLiving;
   import game.objects.GamePlayer;
   import game.objects.GameSimpleBoss;
   import game.view.GameViewBase;
   import game.view.smallMap.SmallMapView;
   import im.IMController;
   import phy.maps.Ground;
   import phy.maps.Map;
   import phy.object.PhysicalObj;
   import phy.object.Physics;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.controller.NewHandGuideManager;
   
   public class MapView extends Map
   {
      
      public static const ADD_BOX:String = "addBox";
      
      public static const FRAMERATE_OVER_COUNT:int = 25;
      
      public static const OVER_FRAME_GAPE:int = 46;
       
      
      private var _game:GameInfo;
      
      private var _info:MapInfo;
      
      private var _animateSet:AnimationSet;
      
      private var _minX:Number;
      
      private var _minY:Number;
      
      private var _minScaleX:Number;
      
      private var _minScaleY:Number;
      
      private var _minSkyScaleX:Number;
      
      private var _minScale:Number;
      
      private var _smallMap:SmallMapView;
      
      private var _actionManager:ActionManager;
      
      public var gameView:GameViewBase;
      
      public var currentFocusedLiving:GameLiving;
      
      private var _currentTurn:int;
      
      private var _y:Number;
      
      private var _x:Number;
      
      private var _currentFocusedLiving:GameLiving;
      
      private var _currentFocusLevel:int;
      
      private var _currentPlayer:TurnedLiving;
      
      private var _smallObjs:Array;
      
      private var _scale:Number = 1;
      
      private var _frameRateCounter:int;
      
      private var _currentFrameRateOverCount:int = 0;
      
      private var _frameRateAlert:BaseAlerFrame;
      
      private var _objects:Dictionary;
      
      public var _gamePlayerList:Vector.<GamePlayer>;
      
      private var expName:Vector.<String>;
      
      private var expDic:Dictionary;
      
      private var _currentTopLiving:GameLiving;
      
      private var _container:Sprite;
      
      private var _bigBox:MovieClipWrapper;
      
      private var _isPickBigBox:Boolean;
      
      private var _picIdList:Array;
      
      private var _picMoveDelay:int;
      
      private var _picList:Array;
      
      private var _picStartPoint:Point;
      
      private var _lastPic:BaseCell;
      
      private var _boxTimer:Timer;
      
      public function MapView(param1:GameInfo, param2:MapLoader)
      {
         this._objects = new Dictionary();
         this._gamePlayerList = new Vector.<GamePlayer>();
         this.expName = new Vector.<String>();
         this.expDic = new Dictionary();
         GameManager.Instance.Current.selfGamePlayer.currentMap = this;
         this._game = param1;
         var _loc3_:Bitmap = new Bitmap(param2.backBmp.bitmapData);
         var _loc4_:Ground = !!Boolean(param2.foreBmp) ? new Ground(param2.foreBmp.bitmapData.clone(),true) : null;
         var _loc5_:Ground = !!Boolean(param2.deadBmp) ? new Ground(param2.deadBmp.bitmapData.clone(),false) : null;
         var _loc6_:MapInfo = param2.info;
         super(_loc3_,_loc4_,_loc5_,param2.middle);
         airResistance = _loc6_.DragIndex;
         gravity = _loc6_.Weight;
         this._info = _loc6_;
         this._animateSet = new AnimationSet(this,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT);
         this._smallMap = new SmallMapView(this,GameManager.Instance.Current.missionInfo);
         this._smallMap.update();
         this._smallObjs = new Array();
         this._minX = -bound.width + PathInfo.GAME_WIDTH;
         this._minY = -bound.height + PathInfo.GAME_HEIGHT;
         this._minScaleX = PathInfo.GAME_WIDTH / bound.width;
         this._minScaleY = PathInfo.GAME_HEIGHT / bound.height;
         this._minSkyScaleX = PathInfo.GAME_WIDTH / _sky.width;
         if(this._minScaleX < this._minScaleY)
         {
            this._minScale = this._minScaleY;
         }
         else
         {
            this._minScale = this._minScaleX;
         }
         if(this._minScaleX < this._minSkyScaleX)
         {
            this._minScale = this._minSkyScaleX;
         }
         else
         {
            this._minScale = this._minScaleX;
         }
         this._actionManager = new ActionManager();
         this.setCenter(this._info.ForegroundWidth / 2,this._info.ForegroundHeight / 2,false);
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         ChatManager.Instance.addEventListener(ChatEvent.SET_FACECONTIANER_LOCTION,this.__setFacecontainLoctionAction);
      }
      
      public function set currentTurn(param1:int) : void
      {
         this._currentTurn = param1;
         dispatchEvent(new GameEvent(GameEvent.TURN_CHANGED,this._currentTurn));
      }
      
      public function get currentTurn() : int
      {
         return this._currentTurn;
      }
      
      public function requestForFocus(param1:GameLiving, param2:int = 0) : void
      {
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         var _loc3_:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
         if(this._currentFocusedLiving)
         {
            if(Math.abs(param1.pos.x - _loc3_) > Math.abs(this._currentFocusedLiving.x - _loc3_))
            {
               return;
            }
         }
         if(param2 < this._currentFocusLevel)
         {
            return;
         }
         this._currentFocusedLiving = param1;
         this._currentFocusLevel = param2;
         this._currentFocusedLiving.needFocus(0,0,{
            "strategy":"directly",
            "priority":param2
         });
      }
      
      public function cancelFocus(param1:GameLiving = null) : void
      {
         if(param1 == null)
         {
            this._currentFocusedLiving = null;
            this._currentFocusLevel = 0;
         }
         if(param1 == this._currentFocusedLiving)
         {
            this._currentFocusedLiving = null;
            this._currentFocusLevel = 0;
         }
      }
      
      public function get currentPlayer() : TurnedLiving
      {
         return this._currentPlayer;
      }
      
      public function set currentPlayer(param1:TurnedLiving) : void
      {
         this._currentPlayer = param1;
      }
      
      public function get game() : GameInfo
      {
         return this._game;
      }
      
      public function get info() : MapInfo
      {
         return this._info;
      }
      
      public function get smallMap() : SmallMapView
      {
         return this._smallMap;
      }
      
      public function get animateSet() : AnimationSet
      {
         return this._animateSet;
      }
      
      private function __setFacecontainLoctionAction(param1:Event) : void
      {
         this.setExpressionLoction();
      }
      
      private function get minX() : Number
      {
         return -bound.width * this.scale + PathInfo.GAME_WIDTH;
      }
      
      private function get minY() : Number
      {
         return -bound.height * this.scale + PathInfo.GAME_HEIGHT;
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         stage.focus = this;
         if(ChatManager.Instance.input.parent && !NewHandGuideManager.Instance.isNewHandFB())
         {
            SoundManager.instance.play("008");
            ChatManager.Instance.switchVisible();
         }
      }
      
      public function spellKill(param1:GamePlayer) : IAnimate
      {
         var _loc2_:SpellSkillAnimation = null;
         if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            _loc2_ = new SpellSkillAnimation(param1.x,param1.y,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT,this._info.ForegroundWidth - 100,this._info.ForegroundHeight + 600,param1,this.gameView);
         }
         else
         {
            _loc2_ = new SpellSkillAnimation(param1.x,param1.y,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT,this._info.ForegroundWidth,this._info.ForegroundHeight,param1,this.gameView);
         }
         this.animateSet.addAnimation(_loc2_);
         SoundManager.instance.play("097");
         return _loc2_;
      }
      
      public function get isPlayingMovie() : Boolean
      {
         return this._animateSet.current is SpellSkillAnimation;
      }
      
      override public function set x(param1:Number) : void
      {
         param1 = param1 < this.minX ? Number(Number(this.minX)) : (param1 > 0 ? Number(Number(0)) : Number(Number(param1)));
         this._x = param1;
         super.x = this._x;
      }
      
      override public function set y(param1:Number) : void
      {
         param1 = param1 < this.minY ? Number(Number(this.minY)) : (param1 > 0 ? Number(Number(0)) : Number(Number(param1)));
         this._y = param1;
         super.y = this._y;
      }
      
      override public function get x() : Number
      {
         return this._x;
      }
      
      override public function get y() : Number
      {
         return this._y;
      }
      
      override public function set transform(param1:Transform) : void
      {
         super.transform = param1;
      }
      
      public function set scale(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 < this._minScale)
         {
            param1 = this._minScale;
         }
         this._scale = param1;
         var _loc2_:Matrix = new Matrix();
         _loc2_.scale(this._scale,this._scale);
         transform.matrix = _loc2_;
         _sky.scaleX = _sky.scaleY = Math.pow(this._scale,-1 / 2);
         this.updateSky();
      }
      
      public function get minScale() : Number
      {
         return this._minScale;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function setCenter(param1:Number, param2:Number, param3:Boolean) : void
      {
         this._animateSet.addAnimation(new BaseSetCenterAnimation(param1,param2,50,!param3,AnimationLevel.MIDDLE));
      }
      
      public function scenarioSetCenter(param1:Number, param2:Number, param3:int) : void
      {
         switch(param3)
         {
            case 3:
               this._animateSet.addAnimation(new ShockingSetCenterAnimation(param1,param2,50,false,AnimationLevel.HIGHT,9));
               break;
            case 2:
               this._animateSet.addAnimation(new ShockingSetCenterAnimation(param1,param2,165,false,AnimationLevel.HIGHT,9));
               break;
            default:
               this._animateSet.addAnimation(new BaseSetCenterAnimation(param1,param2,100,false,AnimationLevel.HIGHT,4));
         }
      }
      
      public function livingSetCenter(param1:Number, param2:Number, param3:Boolean, param4:int = 2, param5:Object = null) : void
      {
         if(this._animateSet)
         {
            this._animateSet.addAnimation(new BaseSetCenterAnimation(param1,param2,25,!param3,param4,0,param5));
         }
      }
      
      public function setSelfCenter(param1:Boolean, param2:int = 2, param3:Object = null) : void
      {
         var _loc4_:Living = this._game.livings[this._game.selfGamePlayer.LivingID];
         if(_loc4_ == null)
         {
            return;
         }
         this._animateSet.addAnimation(new BaseSetCenterAnimation(_loc4_.pos.x - 50,_loc4_.pos.y - 150,25,!param1,param2,0,param3));
      }
      
      public function act(param1:BaseAction) : void
      {
         this._actionManager.act(param1);
      }
      
      public function get getOneSimpleBoss() : GameSimpleBoss
      {
         var _loc1_:PhysicalObj = null;
         for each(_loc1_ in this._objects)
         {
            if(_loc1_ is GameSimpleBoss)
            {
               return _loc1_ as GameSimpleBoss;
            }
         }
         return null;
      }
      
      override protected function update() : void
      {
         super.update();
         if(!IMController.Instance.privateChatFocus)
         {
            if(ChatManager.Instance.input.parent == null)
            {
               if(IME.enabled)
               {
                  IMEManager.disable();
               }
               if(stage && stage.focus == null)
               {
                  stage.focus = this;
               }
            }
            if(StageReferance.stage.focus is TextField && TextField(StageReferance.stage.focus).type == TextFieldType.INPUT)
            {
               if(!IME.enabled)
               {
                  IMEManager.enable();
               }
            }
            else if(IME.enabled)
            {
               IMEManager.disable();
            }
         }
         else if(!IME.enabled)
         {
            IMEManager.enable();
         }
         if(this._animateSet.update())
         {
            this.updateSky();
         }
         this._actionManager.execute();
         this.checkOverFrameRate();
      }
      
      private function checkOverFrameRate() : void
      {
         if(SharedManager.Instance.hasCheckedOverFrameRate)
         {
            return;
         }
         if(this._game == null)
         {
            return;
         }
         if(this._game.PlayerCount <= 4)
         {
            return;
         }
         if(this._currentPlayer && this._currentPlayer.LivingID == this._game.selfGamePlayer.LivingID)
         {
            return;
         }
         var _loc1_:int = getTimer();
         if(_loc1_ - this._frameRateCounter > OVER_FRAME_GAPE && this._frameRateCounter != 0)
         {
            ++this._currentFrameRateOverCount;
            if(this._currentFrameRateOverCount > FRAMERATE_OVER_COUNT)
            {
               if(this._frameRateAlert == null && SharedManager.Instance.showParticle)
               {
                  this._frameRateAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.game.map.smallMapView.slow"),"",LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  this._frameRateAlert.addEventListener(FrameEvent.RESPONSE,this.__onRespose);
                  SharedManager.Instance.hasCheckedOverFrameRate = true;
                  SharedManager.Instance.save();
               }
            }
         }
         else
         {
            this._currentFrameRateOverCount = 0;
         }
         this._frameRateCounter = _loc1_;
      }
      
      private function __onRespose(param1:FrameEvent) : void
      {
         this._frameRateAlert.removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
         this._frameRateAlert.dispose();
         SharedManager.Instance.showParticle = false;
      }
      
      private function overFrameOk() : void
      {
         SharedManager.Instance.showParticle = false;
      }
      
      public function get mapBitmap() : Bitmap
      {
         var _loc1_:BitmapData = new BitmapData(StageReferance.stageWidth,StageReferance.stageHeight);
         var _loc2_:Point = globalToLocal(new Point(0,0));
         _loc1_.draw(this,new Matrix(1,0,0,1,-_loc2_.x,-_loc2_.y),null,null);
         return new Bitmap(_loc1_,"auto",true);
      }
      
      private function updateSky() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this._scale < 1)
         {
         }
         var _loc1_:Number = (sky.height * this._scale - PathInfo.GAME_HEIGHT) / (bound.height * this._scale - PathInfo.GAME_HEIGHT);
         var _loc2_:Number = (sky.width * this._scale - PathInfo.GAME_WIDTH) / (bound.width * this._scale - PathInfo.GAME_WIDTH);
         _loc1_ = isNaN(_loc1_) || _loc1_ == Number.NEGATIVE_INFINITY || _loc1_ == Number.POSITIVE_INFINITY ? Number(Number(1)) : Number(Number(_loc1_));
         _loc2_ = isNaN(_loc2_) || _loc2_ == Number.NEGATIVE_INFINITY || _loc2_ == Number.POSITIVE_INFINITY ? Number(Number(1)) : Number(Number(_loc2_));
         _sky.y = this.y * (_loc1_ - 1) / this._scale;
         _sky.x = this.x * (_loc2_ - 1) / this._scale;
         if(_middle)
         {
            _loc3_ = (_middle.height * this._scale - PathInfo.GAME_HEIGHT) / (bound.height * this._scale - PathInfo.GAME_HEIGHT);
            _loc4_ = (_middle.width * this._scale - PathInfo.GAME_WIDTH) / (bound.width * this._scale - PathInfo.GAME_WIDTH);
            _loc3_ = isNaN(_loc3_) || _loc3_ == Number.NEGATIVE_INFINITY || _loc3_ == Number.POSITIVE_INFINITY ? Number(Number(1)) : Number(Number(_loc3_));
            _loc4_ = isNaN(_loc4_) || _loc4_ == Number.NEGATIVE_INFINITY || _loc4_ == Number.POSITIVE_INFINITY ? Number(Number(1)) : Number(Number(_loc4_));
            _middle.y = this.y * (_loc3_ - 1) / this._scale;
            _middle.x = this.x * (_loc4_ - 1) / this._scale;
         }
         this._smallMap.setScreenPos(this.x,this.y);
      }
      
      public function getPhysical(param1:int) : PhysicalObj
      {
         return this._objects[param1];
      }
      
      override public function addPhysical(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         super.addPhysical(param1);
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            this._objects[_loc2_.Id] = _loc2_;
            if(_loc2_.smallView)
            {
               this._smallMap.addObj(_loc2_.smallView);
               this._smallMap.updatePos(_loc2_.smallView,_loc2_.pos);
            }
         }
         if(param1 is GamePlayer)
         {
            this._gamePlayerList.push(param1);
         }
      }
      
      private function controlExpNum(param1:GamePlayer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:FaceContainer = null;
         if(this.expName.length < 2)
         {
            if(this.expName.indexOf(param1.facecontainer.nickName.text) < 0)
            {
               this.expName.push(param1.facecontainer.nickName.text);
               this.expDic[param1.facecontainer.nickName.text] = param1.facecontainer;
            }
         }
         else if(this.expName.indexOf(param1.facecontainer.nickName.text) < 0)
         {
            _loc2_ = int(Math.random() * 2);
            _loc3_ = this.expName[_loc2_];
            _loc4_ = this.expDic[_loc3_] as FaceContainer;
            if(_loc4_.isActingExpression)
            {
               _loc4_.doClearFace();
            }
            this.expName[_loc2_] = param1.facecontainer.nickName.text;
            delete this.expDic[_loc3_];
            this.expDic[param1.facecontainer.nickName.text] = param1.facecontainer;
         }
      }
      
      private function resetDicAndVec(param1:GamePlayer) : void
      {
         var _loc2_:int = this.expName.indexOf(param1.facecontainer.nickName.text);
         if(_loc2_ >= 0)
         {
            delete this.expDic[this.expName[_loc2_]];
            this.expName.splice(_loc2_,1);
         }
      }
      
      public function setExpressionLoction() : void
      {
         var _loc2_:GamePlayer = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         if(this._gamePlayerList.length == 0)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._gamePlayerList.length)
         {
            _loc2_ = this._gamePlayerList[_loc1_];
            if(_loc2_ == null || !_loc2_.isLiving || _loc2_.facecontainer == null)
            {
               this._gamePlayerList.splice(_loc1_,1);
            }
            else if(_loc2_.facecontainer.isActingExpression)
            {
               if(!(_loc2_.facecontainer.expressionID >= 49 || _loc2_.facecontainer.expressionID <= 0))
               {
                  _loc3_ = this.localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  _loc4_ = this.onStageFlg(_loc3_);
                  if(_loc4_ == 0)
                  {
                     _loc2_.facecontainer.x = 0;
                     _loc2_.facecontainer.y = -100;
                     this.resetDicAndVec(_loc2_);
                     _loc2_.facecontainer.isShowNickName = false;
                  }
                  else if(_loc4_ == 1)
                  {
                     _loc2_.facecontainer.x = _loc2_.facecontainer.width / 2 + 30 - _loc3_.x;
                     _loc2_.facecontainer.y = 270 + _loc2_.facecontainer.height / 2 - _loc3_.y;
                     this.controlExpNum(_loc2_);
                     _loc2_.facecontainer.isShowNickName = true;
                  }
                  if(this.expName.length == 2)
                  {
                     (this.expDic[this.expName[1]] as FaceContainer).x += 80;
                  }
               }
            }
            else
            {
               _loc2_.facecontainer.x = 0;
               _loc2_.facecontainer.y = -100;
               _loc2_.facecontainer.isShowNickName = false;
               this.resetDicAndVec(_loc2_);
            }
            _loc1_++;
         }
      }
      
      private function onStageFlg(param1:Point) : int
      {
         if(param1 == null)
         {
            return 100;
         }
         if(param1.x >= 0 && param1.x <= 1000 && param1.y >= 0 && param1.y <= 600)
         {
            return 0;
         }
         return 1;
      }
      
      public function addObject(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            this._objects[_loc2_.Id] = _loc2_;
         }
      }
      
      public function bringToFront(param1:Living) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:Physics = this._objects[param1.LivingID] as Physics;
         if(_loc2_)
         {
            super.addPhysical(_loc2_);
         }
      }
      
      public function phyBringToFront(param1:PhysicalObj) : void
      {
         if(param1)
         {
            super.addChild(param1);
         }
      }
      
      override public function removePhysical(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         super.removePhysical(param1);
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            if(this._objects && this._objects[_loc2_.Id])
            {
               delete this._objects[_loc2_.Id];
            }
            if(this._smallMap && _loc2_.smallView)
            {
               this._smallMap.removeObj(_loc2_.smallView);
            }
         }
      }
      
      override public function addMapThing(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         super.addMapThing(param1);
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            this._objects[_loc2_.Id] = _loc2_;
            if(_loc2_.smallView)
            {
               this._smallMap.addObj(_loc2_.smallView);
               this._smallMap.updatePos(_loc2_.smallView,_loc2_.pos);
            }
         }
      }
      
      override public function removeMapThing(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         super.removeMapThing(param1);
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            if(this._objects[_loc2_.Id])
            {
               delete this._objects[_loc2_.Id];
            }
            if(_loc2_.smallView)
            {
               this._smallMap.removeObj(_loc2_.smallView);
            }
         }
      }
      
      public function get actionCount() : int
      {
         return this._actionManager.actionCount;
      }
      
      public function lockFocusAt(param1:Point) : void
      {
         this.animateSet.addAnimation(new NewHandAnimation(param1.x,param1.y - 150,int.MAX_VALUE,false,AnimationLevel.HIGHEST));
      }
      
      public function releaseFocus() : void
      {
         this.animateSet.clear();
      }
      
      public function executeAtOnce() : void
      {
         this._actionManager.executeAtOnce();
         this._animateSet.clear();
      }
      
      public function bringToStageTop(param1:PhysicalObj) : void
      {
         if(this._currentTopLiving)
         {
            this.addPhysical(this._currentTopLiving);
         }
         if(this._container && this._container.parent)
         {
            this._container.parent.removeChild(this._container);
         }
         this._currentTopLiving = this._objects[param1.Id] as GameLiving;
         if(this._container == null)
         {
            this._container = new Sprite();
            this._container.x = this.x;
            this._container.y = this.y;
         }
         if(this._currentTopLiving)
         {
            this._container.addChild(this._currentTopLiving);
         }
         LayerManager.Instance.addToLayer(this._container,LayerManager.GAME_BASE_LAYER,false,0,false);
      }
      
      public function restoreStageTopLiving() : void
      {
         if(this._currentTopLiving && this._currentTopLiving.isExist)
         {
            this.addPhysical(this._currentTopLiving);
         }
         if(this._container && this._container.parent)
         {
            this._container.parent.removeChild(this._container);
         }
         this._currentTopLiving = null;
      }
      
      public function setMatrx(param1:Matrix) : void
      {
         transform.matrix = param1;
         if(this._container)
         {
            this._container.transform.matrix = param1;
         }
      }
      
      public function dropOutBox(param1:Array) : void
      {
         this._picIdList = param1;
         this.setSelfCenter(false);
         this._isPickBigBox = false;
         this._bigBox = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.dropOut.bigBox.red"),true);
         _livingLayer.addChild(this._bigBox.movie);
         var _loc2_:Point = this.getTwoHundredDisPoint(this._game.selfGamePlayer.pos.x,this._game.selfGamePlayer.pos.y,this._bigBox.movie.width / 2,this._bigBox.movie.height / 2,this._game.selfGamePlayer.direction);
         this._bigBox.movie.x = _loc2_.x;
         this._bigBox.movie.y = _loc2_.y;
         this._bigBox.endFrame = 29;
         this._bigBox.addEventListener(Event.COMPLETE,this.dropEndHandler,false,0,true);
         this._bigBox.movie.addEventListener(MouseEvent.CLICK,this.__onBigBoxClick);
         this._bigBox.movie.buttonMode = true;
         this._bigBox.gotoAndPlay(1);
         this._bigBox.movie.addEventListener(Event.ENTER_FRAME,this.playSoundEffect);
         this._boxTimer = new Timer(1000,9);
         this._boxTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__openBox);
         this._boxTimer.start();
      }
      
      protected function __openBox(param1:TimerEvent) : void
      {
         if(this._boxTimer)
         {
            this._boxTimer.stop();
            this._boxTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__openBox);
            this._boxTimer = null;
         }
         this.pickBigBoxSuccessHandler();
      }
      
      protected function __onBigBoxClick(param1:MouseEvent) : void
      {
         if(this._boxTimer)
         {
            this._boxTimer.stop();
            this._boxTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__openBox);
            this._boxTimer = null;
         }
         this._bigBox.movie.buttonMode = false;
         this._bigBox.movie.removeEventListener(MouseEvent.CLICK,this.__onBigBoxClick);
         this.pickBigBoxSuccessHandler();
      }
      
      public function pickBigBoxSuccessHandler() : void
      {
         this._bigBox.gotoAndPlay("open");
         this._picStartPoint = new Point(this._bigBox.movie.x - 22.5,this._bigBox.movie.y - 120 - 22.5);
         this._picMoveDelay = 4;
         this._bigBox.movie.addEventListener(Event.ENTER_FRAME,this.playPickBoxAwardMove,false,0,true);
         GameInSocketOut.sendGameSkipNext(0);
      }
      
      private function playPickBoxAwardMove(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         var _loc6_:BaseCell = null;
         var _loc7_:Number = NaN;
         if(this._bigBox.movie.currentFrame == 37)
         {
            this._picList = [];
            _loc2_ = this._picIdList.length;
            _loc3_ = -1;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = new Bitmap(new BitmapData(45,45,true,0));
               _loc6_ = new BaseCell(_loc5_,ItemManager.Instance.getTemplateById(this._picIdList[_loc4_]));
               _loc6_.x = this._picStartPoint.x;
               _loc6_.y = this._picStartPoint.y;
               this._picList.push(_loc6_);
               addChild(_loc6_);
               if(_loc2_ % 2 == 0)
               {
                  _loc7_ = int(_loc4_ / 2) * _loc3_ * 50 + 25 * _loc3_ + _loc6_.x;
               }
               else
               {
                  _loc7_ = int((_loc4_ + 1) / 2) * _loc3_ * 50 + _loc6_.x;
               }
               TweenLite.to(_loc6_,0.2,{"x":_loc7_});
               _loc3_ *= -1;
               _loc4_++;
            }
         }
         else if(this._bigBox.movie.currentFrame == 50)
         {
            this._picList.sortOn("x",Array.NUMERIC);
            this._lastPic = this._picList[this._picList.length - 1];
            addEventListener(Event.ENTER_FRAME,this.playPickBoxAwardMove2);
         }
         else if(this._bigBox.movie.currentFrame == 84)
         {
            this._bigBox.gotoAndStop(84);
            this._bigBox.movie.removeEventListener(Event.ENTER_FRAME,this.playPickBoxAwardMove);
         }
      }
      
      private function playPickBoxAwardMove2(param1:Event) : void
      {
         ++this._picMoveDelay;
         if(this._picMoveDelay < 5)
         {
            return;
         }
         this._picMoveDelay = 0;
         this.pickBigBoxSuccessHandler2(this._picList.shift());
         if(this._picList.length == 0)
         {
            removeEventListener(Event.ENTER_FRAME,this.playPickBoxAwardMove2);
         }
      }
      
      private function pickBigBoxSuccessHandler2(param1:BaseCell) : void
      {
         TweenLite.to(param1,0.5,{
            "y":param1.y - 60,
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.upMoveEndHandler,
            "onCompleteParams":[param1]
         });
      }
      
      private function upMoveEndHandler(param1:BaseCell) : void
      {
         this.lightCartoonPlayEndHandler(param1);
      }
      
      private function lightCartoonPlayEndHandler(param1:BaseCell) : void
      {
         if(!this._game || !this._game.selfGamePlayer || !this._game.selfGamePlayer.pos)
         {
            return;
         }
         var _loc2_:Point = new Point(this._game.selfGamePlayer.pos.x,this._game.selfGamePlayer.pos.y);
         var _loc3_:Number = (param1.x + _loc2_.x) / 2;
         var _loc4_:Number = Math.min(param1.y,_loc2_.y) - 200;
         TweenMax.to(param1,1,{
            "scaleX":0.1,
            "scaleY":0.1,
            "bezier":[{
               "x":_loc3_,
               "y":_loc4_
            },{
               "x":_loc2_.x,
               "y":_loc2_.y
            }],
            "onComplete":this.pickBigBoxEndHandler,
            "onCompleteParams":[param1]
         });
      }
      
      private function pickBigBoxEndHandler(param1:BaseCell) : void
      {
         if(!param1)
         {
            return;
         }
         param1.dispose();
         param1 = null;
      }
      
      private function playSoundEffect(param1:Event) : void
      {
         if(this._bigBox.movie.currentFrame == 13)
         {
            SoundManager.instance.play("164");
            this._bigBox.movie.removeEventListener(Event.ENTER_FRAME,this.playSoundEffect);
            this._bigBox.movie.buttonMode = true;
            this._bigBox.movie.mouseChildren = false;
            this._bigBox.movie.addEventListener(MouseEvent.CLICK,this.openBigBox,false,0,true);
         }
      }
      
      private function openBigBox(param1:MouseEvent) : void
      {
         this._bigBox.movie.buttonMode = false;
         this._bigBox.movie.removeEventListener(MouseEvent.CLICK,this.openBigBox);
         this._isPickBigBox = true;
      }
      
      private function dropEndHandler(param1:Event) : void
      {
         this._bigBox.removeEventListener(Event.COMPLETE,this.dropEndHandler);
         this._bigBox.gotoAndStop("stop");
      }
      
      private function getTwoHundredDisPoint(param1:Number, param2:Number, param3:Number, param4:Number, param5:int) : Point
      {
         var _loc8_:Point = null;
         param2 = 150;
         var _loc6_:Number = param1 + 200 * param5 + param3 * param5;
         if(!this.IsOutMap(_loc6_,param2) && this.IsEmpty(_loc6_,param2))
         {
            return findYLineNotEmptyPointDown(param1 + 200 * param5,param2,this.bound.height);
         }
         param5 *= -1;
         _loc6_ = param1 + 200 * param5 + param3 * param5;
         return findYLineNotEmptyPointDown(param1 + 200 * param5,param2,this.bound.height);
      }
      
      override public function dispose() : void
      {
         var _loc1_:PhysicalObj = null;
         super.dispose();
         this._currentTopLiving = null;
         ChatManager.Instance.removeEventListener(ChatEvent.SET_FACECONTIANER_LOCTION,this.__setFacecontainLoctionAction);
         if(this._container && this._container.parent)
         {
            this._container.parent.removeChild(this._container);
         }
         this._container = null;
         if(this._frameRateAlert != null)
         {
            this._frameRateAlert.removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
            this._frameRateAlert.dispose();
            this._frameRateAlert = null;
         }
         for each(_loc1_ in this._objects)
         {
            _loc1_.dispose();
            this._objects = null;
         }
         this._game = null;
         this._info = null;
         this._currentFocusedLiving = null;
         this.currentFocusedLiving = null;
         this._currentPlayer = null;
         this._smallMap.dispose();
         this._smallMap = null;
         this._animateSet.dispose();
         this._animateSet = null;
         this._actionManager.clear();
         this._actionManager = null;
         this.gameView = null;
      }
   }
}
