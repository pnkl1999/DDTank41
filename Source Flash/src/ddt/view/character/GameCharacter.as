package ddt.view.character
{
   import com.greensock.TweenMax;
   import com.greensock.events.TweenEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.PlayerAction;
   import ddt.data.player.PlayerInfo;
   import ddt.utils.BitmapUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import game.model.Player;
   import road7th.utils.StringHelper;
   
   public class GameCharacter extends BaseCharacter
   {
      
      private static const STAND_FRAME_1:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,7,7,8,8,9,9,9,9,8,8,7,7,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10];
      
      private static const STAND_FRAME_2:Array = [7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,6,6,7,7,8,8,9,9,9,9,8,8,7,7,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7];
      
      public static const STAND:PlayerAction = new PlayerAction("stand",[STAND_FRAME_1,STAND_FRAME_2],false,true,false);
      
      private static const LACK_FACE_DOWN:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
      
      private static const LACK_FACE_UP:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
      
      private static const STAND_LACK_HP_FRAME:Array = [0,0,1,1,2,2,3,3,3,3,3,2,2,1,1,0,0,0,0,0,1,1,2,2,3,3,3,3,3,2,2,1,1,0,0,0,0,0,0,1,1,2,2,3,3,3,3,3,2,2,1,1,0,0,0,0,0,1,1,2,2,3,3,3,3,3,2,2,1,1,0,0,0,0];
      
      private static const STAND_LACK_HP_FRAME_1:Array = [0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2];
      
      public static const STAND_LACK_HP:PlayerAction = new PlayerAction("standLackHP",[STAND_LACK_HP_FRAME,STAND_LACK_HP_FRAME_1],false,false,false);
      
      public static const WALK_LACK_HP:PlayerAction = new PlayerAction("walkLackHP",[[1,1,2,2,3,3,4,4,5,5]],false,true,false);
      
      public static const WALK:PlayerAction = new PlayerAction("walk",[[1,1,2,2,3,3,4,4,5,5]],false,true,false);
      
      public static const SHOT:PlayerAction = new PlayerAction("shot",[[22,23,26,27]],true,false,true);
      
      public static const STOPSHOT:PlayerAction = new PlayerAction("stopshot",[[23]],true,false,false);
      
      public static const SHOWGUN:PlayerAction = new PlayerAction("showgun",[[19,20,21,21,21]],true,false,true);
      
      public static const HIDEGUN:PlayerAction = new PlayerAction("hidegun",[[27]],true,false,false);
      
      public static const THROWS:PlayerAction = new PlayerAction("throws",[[31,32,33,34,35]],true,false,true);
      
      public static const STOPTHROWS:PlayerAction = new PlayerAction("stopthrows",[[34]],true,false,false);
      
      public static const SHOWTHROWS:PlayerAction = new PlayerAction("showthrows",[[28,29,30,30,30]],true,false,true);
      
      public static const HIDETHROWS:PlayerAction = new PlayerAction("hidethrows",[[35]],true,false,false);
      
      public static const SHAKE:PlayerAction = new PlayerAction("shake",[[6,6,7,7,8,8,9,9,8,8,7,7,6,6]],false,false,false);
      
      public static const HANDCLIP:PlayerAction = new PlayerAction("handclip",[[13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13]],true,false,false);
      
      public static const HANDCLIP_LACK_HP:PlayerAction = new PlayerAction("handclip",[[13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13]],true,false,false);
      
      public static const SOUL:PlayerAction = new PlayerAction("soul",[[0]],false,true,false);
      
      public static const SOUL_MOVE:PlayerAction = new PlayerAction("soulMove",[[1]],false,true,false);
      
      public static const SOUL_SMILE:PlayerAction = new PlayerAction("soulSmile",[[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]],false,false,false);
      
      public static const SOUL_CRY:PlayerAction = new PlayerAction("soulCry",[[3]],false,true,false);
      
      public static const CRY:PlayerAction = new PlayerAction("cry",[[16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18]],false,false,false);
      
      public static const HIT:PlayerAction = new PlayerAction("hit",[[12,12,24,24,24,24,24,24,24,24,25,25,38,38,38,38,11,11,11,11]],false,false,false);
      
      public static const SPECIAL_EFFECT_FRAMES:Array = [0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2];
      
      private static const grayFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
      
      public static const GAME_WING_WAIT:int = 1;
      
      public static const GAME_WING_MOVE:int = 2;
      
      public static const GAME_WING_CRY:int = 3;
      
      public static const GAME_WING_CLIP:int = 4;
      
      public static const GAME_WING_SHOOT:int = 5;
       
      
      private var _currentAction:PlayerAction;
      
      private var _defaultAction:PlayerAction;
      
      private var _wing:MovieClip;
      
      private var _ghostMovie:MovieClip;
      
      private var _ghostShine:MovieClip;
      
      private var _frameStartPoint:Point;
      
      private var _spBitmapData:Vector.<BitmapData>;
      
      private var _faceupBitmapData:BitmapData;
      
      private var _faceBitmapData:BitmapData;
      
      private var _lackHpFaceBitmapdata:Vector.<BitmapData>;
      
      private var _faceDownBitmapdata:BitmapData;
      
      private var _normalSuit:BitmapData;
      
      private var _lackHpSuit:BitmapData;
      
      private var _soulFace:BitmapData;
      
      private var _tempCryFace:BitmapData;
      
      private var _cryTypes:Array;
      
      private var _cryType:int;
      
      private var _specialType:int = 0;
      
      private var _state:int;
      
      private var _rect:Rectangle;
      
      private var _hasSuitSoul:Boolean = true;
      
      private var _cryFrace:Sprite;
      
      private var _cryBmps:Vector.<Bitmap>;
      
      protected var _colors:Array;
      
      private var _isLackHp:Boolean;
      
      private var _hasChangeToLackHp:Boolean;
      
      private var _index:int;
      
      private var _isPlaying:Boolean = false;
      
      private var black:Boolean;
      
      private var blackBm:Bitmap;
      
      private var blackEyes:MovieClip;
      
      private var _wingState:int = 0;
      
      private var closeEys:int;
      
      public function GameCharacter(param1:PlayerInfo)
      {
         this._frameStartPoint = new Point(0,0);
         this._cryTypes = [0,16,13,10];
         this._state = Player.FULL_HP;
         this._index = 90 * Math.random();
         super(param1,true);
         this._currentAction = this._defaultAction = STAND;
         _body.x -= 62;
         _body.y -= 83;
      }
      
      protected function CreateCryFrace(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ColorTransform = null;
         var _loc5_:Bitmap = null;
         ObjectUtils.disposeObject(this._tempCryFace);
         this._tempCryFace = null;
         if(this._cryBmps)
         {
            _loc2_ = 0;
            while(_loc2_ < this._cryBmps.length)
            {
               ObjectUtils.disposeObject(this._cryBmps[_loc2_]);
               this._cryBmps[_loc2_] = null;
               _loc2_++;
            }
            this._cryBmps = null;
         }
         ObjectUtils.disposeAllChildren(this._cryFrace);
         this._cryFrace = null;
         this._colors = param1.split("|");
         this._cryFrace = new Sprite();
         this._cryBmps = new Vector.<Bitmap>(3);
         this._cryBmps[0] = ComponentFactory.Instance.creatBitmap("asset.game.character.cryFaceAsset");
         this._cryFrace.addChild(this._cryBmps[0]);
         this._cryBmps[1] = ComponentFactory.Instance.creatBitmap("asset.game.character.cryChangeColorAsset");
         this._cryFrace.addChild(this._cryBmps[1]);
         this._cryBmps[1].visible = false;
         if(this._colors.length == this._cryBmps.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this._colors.length)
            {
               if(!StringHelper.isNullOrEmpty(this._colors[_loc3_]) && this._colors[_loc3_].toString() != "undefined" && this._colors[_loc3_].toString() != "null" && this._cryBmps[_loc3_])
               {
                  this._cryBmps[_loc3_].visible = true;
                  this._cryBmps[_loc3_].transform.colorTransform = BitmapUtils.getColorTransfromByColor(this._colors[_loc3_]);
                  _loc4_ = BitmapUtils.getHightlightColorTransfrom(this._colors[_loc3_]);
                  _loc5_ = new Bitmap(this._cryBmps[_loc3_].bitmapData,"auto",true);
                  if(_loc4_)
                  {
                     _loc5_.transform.colorTransform = _loc4_;
                  }
                  _loc5_.blendMode = BlendMode.HARDLIGHT;
                  this._cryFrace.addChild(_loc5_);
               }
               else if(this._cryBmps[_loc3_])
               {
                  this._cryBmps[_loc3_].transform.colorTransform = new ColorTransform();
               }
               _loc3_++;
            }
         }
         this._tempCryFace = new BitmapData(this._cryFrace.width,this._cryFrace.height,true,0);
         this._tempCryFace.draw(this._cryFrace,null,null,BlendMode.NORMAL);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.altKey)
         {
            this._currentAction = SOUL_SMILE;
         }
         else if(param1.ctrlKey)
         {
            this._currentAction = SOUL_MOVE;
         }
         else
         {
            this._currentAction = SOUL;
         }
      }
      
      public function set isLackHp(param1:Boolean) : void
      {
         this._isLackHp = param1;
      }
      
      public function get State() : int
      {
         return this._state;
      }
      
      public function set State(param1:int) : void
      {
         if(this._state == param1)
         {
            return;
         }
         this._state = param1;
      }
      
      override protected function initSizeAndPics() : void
      {
         setCharacterSize(114,95);
         setPicNum(3,13);
         this._rect = new Rectangle(0,0,_characterWidth,_characterHeight);
      }
      
      public function get weaponX() : int
      {
         return -_characterWidth / 2 - 5;
      }
      
      public function get weaponY() : int
      {
         return -_characterHeight + 12;
      }
      
      override protected function initLoader() : void
      {
         _loader = _factory.createLoader(_info,CharacterLoaderFactory.GAME);
      }
      
      override public function update() : void
      {
         if(this._isPlaying)
         {
            if(this._index < this._currentAction.frames[0].length)
            {
               if(this.isDead)
               {
                  this.drawFrame(this._currentAction.frames[0][this._index++],8,true);
               }
               else if(_info.getShowSuits())
               {
                  this.drawFrame(this._currentAction.frames[0][this._index++],6,true);
               }
               else if(this._currentAction == STAND_LACK_HP)
               {
                  this.drawFrame(LACK_FACE_DOWN[this._index],1,true);
                  this.drawFrame(this._currentAction.frames[this.STATES_ENUM[this._specialType][0] % 2][this._index],2,false);
                  this.drawFrame(LACK_FACE_UP[this._index],4,false);
                  this.drawFrame(SPECIAL_EFFECT_FRAMES[this._index++],5,false);
               }
               else if(this._currentAction == STAND)
               {
                  this.drawFrame(STAND.frames[0][this._index],1,true);
                  this.drawFrame(STAND.frames[0][this._index],3,false);
                  this.drawFrame(STAND.frames[1][this._index++],4,false);
               }
               else
               {
                  this.drawFrame(this._currentAction.frames[0][this._index],1,true);
                  this.drawFrame(this._currentAction.frames[0][this._index],3,false);
                  this.drawFrame(this._currentAction.frames[0][this._index++],4,false);
               }
            }
            else if(this._currentAction.repeat)
            {
               this._index = 0;
               if(this._currentAction == STAND && this._isLackHp)
               {
                  if(Math.random() < 0.33)
                  {
                     this.doAction(STAND_LACK_HP);
                  }
               }
            }
            else if(this._currentAction.stopAtEnd)
            {
               this._isPlaying = false;
            }
            else if(this.isDead)
            {
               this.doAction(SOUL);
            }
            else if(this._currentAction == CRY)
            {
               if(Math.random() < 0.33)
               {
                  this.doAction(STAND_LACK_HP);
               }
               else
               {
                  this.doAction(STAND);
               }
            }
            else if(this._isLackHp && this._currentAction == STAND)
            {
               if(Math.random() < 0.33)
               {
                  this.doAction(STAND_LACK_HP);
               }
            }
            else
            {
               this.doAction(STAND);
            }
         }
      }
      
      private function get STATES_ENUM() : Array
      {
         if(_info.Sex)
         {
            return GameCharacterLoader.MALE_STATES;
         }
         return GameCharacterLoader.FEMALE_STATES;
      }
      
      public function bombed() : void
      {
         if(this.black)
         {
            return;
         }
         this.black = true;
         this.blackBm.alpha = 1;
         addChild(this.blackBm);
         setTimeout(this.blackEyes.gotoAndPlay,300,1);
         addChild(this.blackEyes);
         if(contains(_body))
         {
            removeChild(_body);
         }
         this.switchWingVisible(false);
         setTimeout(this.changeToNormal,2000);
      }
      
      override protected function init() : void
      {
         _currentframe = -1;
         this.initSizeAndPics();
         createFrames();
         _body = new Bitmap(new BitmapData(_characterWidth,_characterHeight,true,0),"auto",true);
         addChild(_body);
         mouseEnabled = false;
         mouseChildren = false;
         _loadCompleted = false;
      }
      
      private function drawBlack(param1:BitmapData) : void
      {
         var _loc2_:Rectangle = new Rectangle(0,0,param1.width,param1.height);
         var _loc3_:Vector.<uint> = param1.getVector(_loc2_);
         var _loc4_:uint = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_[_loc5_] = _loc3_[_loc5_] >> 24 << 24 | 0 << 16 | 0 << 8 | 0;
            _loc5_++;
         }
         param1.setVector(_loc2_,_loc3_);
      }
      
      public function changeToNormal() : void
      {
         var _loc1_:TweenMax = TweenMax.to(this.blackBm,0.25,{"alpha":0});
         _loc1_.addEventListener(TweenEvent.COMPLETE,this.setBlack);
         if(this.blackEyes.parent)
         {
            removeChild(this.blackEyes);
         }
         addChild(_body);
         if(!this.isDead)
         {
            this.switchWingVisible(true);
         }
      }
      
      private function get isDead() : Boolean
      {
         return this._currentAction == SOUL || this._currentAction == SOUL_CRY || this._currentAction == SOUL_MOVE || this._currentAction == SOUL_SMILE;
      }
      
      private function setBlack(param1:TweenEvent) : void
      {
         TweenMax(param1.target).removeEventListener(TweenEvent.COMPLETE,this.setBlack);
         if(this.blackBm && this.blackBm.parent)
         {
            removeChild(this.blackBm);
         }
         this.black = false;
      }
      
      private function clearBomded() : void
      {
         this.black = false;
         if(this.blackEyes.parent)
         {
            removeChild(this.blackEyes);
         }
         if(this.blackBm.parent)
         {
            removeChild(this.blackBm);
         }
         addChild(_body);
      }
      
      public function get standAction() : PlayerAction
      {
         if(this.State == Player.FULL_HP || _info.getShowSuits())
         {
            return STAND;
         }
         return STAND_LACK_HP;
      }
      
      public function get walkAction() : PlayerAction
      {
         if(this.State == Player.FULL_HP || _info.getShowSuits())
         {
            return WALK;
         }
         return WALK_LACK_HP;
      }
      
      public function get handClipAction() : PlayerAction
      {
         if(this.State == Player.FULL_HP || _info.getShowSuits())
         {
            return HANDCLIP;
         }
         return HANDCLIP_LACK_HP;
      }
      
      public function randomCryType() : void
      {
         this._cryType = int(Math.random() * 4);
         if(!_info.getShowSuits())
         {
            this._specialType = int(Math.random() * this._lackHpFaceBitmapdata.length);
         }
      }
      
      override public function doAction(param1:*) : void
      {
         var _loc2_:String = null;
         if(this._currentAction.canReplace(param1))
         {
            this._currentAction = param1;
            this._index = 0;
         }
         if(this._currentAction == STAND || this._currentAction == STAND_LACK_HP)
         {
            if(this._ghostMovie && this._ghostMovie.parent)
            {
               this._ghostMovie.parent.removeChild(this._ghostMovie);
            }
            filters = null;
            if(this._ghostShine && this._ghostShine.parent)
            {
               this._ghostShine.parent.removeChild(this._ghostShine);
            }
         }
         else if(this.isDead)
         {
            this.switchWingVisible(false);
            this.clearBomded();
            if(this._ghostShine == null)
            {
               this._ghostShine = ClassUtils.CreatInstance("asset.game.ghostShineAsset") as MovieClip;
            }
            this._ghostShine.x = -28;
            this._ghostShine.y = -50;
            if(_info.getShowSuits())
            {
               if(this._hasSuitSoul)
               {
                  _loc2_ = !!_info.Sex ? "asset.game.ghostManMovieAsset1" : "asset.game.ghostGirlMovieAsset1";
                  if(this._ghostMovie == null)
                  {
                     this._ghostMovie = ClassUtils.CreatInstance(_loc2_) as MovieClip;
                  }
                  addChildAt(this._ghostMovie,0);
                  this._ghostMovie.x = -26;
                  this._ghostMovie.y = -50;
               }
               else
               {
                  if(this._ghostMovie == null)
                  {
                     this._ghostMovie = ClassUtils.CreatInstance("asset.game.ghostMovieAsset") as MovieClip;
                  }
                  addChildAt(this._ghostMovie,0);
               }
            }
            else
            {
               _loc2_ = !!_info.Sex ? "asset.game.ghostManMovieAsset" : "asset.game.ghostGirlMovieAsset";
               if(this._ghostMovie && this._ghostMovie.parent)
               {
                  this._ghostMovie.parent.removeChild(this._ghostMovie);
                  this._ghostMovie = null;
               }
               this._ghostMovie = ClassUtils.CreatInstance(_loc2_) as MovieClip;
               addChild(this._ghostMovie);
               this._ghostMovie.x = -26;
               this._ghostMovie.y = -50;
            }
            filters = [new GlowFilter(7564475,1,6,6,2)];
            addChild(this._ghostShine);
         }
         else
         {
            if(this._ghostMovie && this._ghostMovie.parent)
            {
               this._ghostMovie.parent.removeChild(this._ghostMovie);
            }
            filters = null;
            if(this._ghostShine && this._ghostShine.parent)
            {
               this._ghostShine.parent.removeChild(this._ghostShine);
            }
         }
         if(this.leftWing && this.leftWing.totalFrames == 2 && this.rightWing && this.rightWing.totalFrames == 2)
         {
            if(this._currentAction == STAND || this._currentAction == STAND_LACK_HP)
            {
               this.WingState = GAME_WING_WAIT;
               if(this.leftWing && this.leftWing["movie"] && this.rightWing && this.rightWing["movie"])
               {
                  this.leftWing["movie"].gotoAndStop(1);
                  this.rightWing["movie"].gotoAndStop(1);
               }
            }
            else if(this.leftWing && this.leftWing["movie"] && this.rightWing && this.rightWing["movie"])
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this._currentAction == STAND || this._currentAction == STAND_LACK_HP)
         {
            this.WingState = GAME_WING_WAIT;
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && this.rightWing["movie"])
            {
               this.leftWing["movie"].gotoAndStop(1);
               this.rightWing["movie"].gotoAndStop(1);
            }
         }
         else if(this._currentAction == WALK || this._currentAction == WALK_LACK_HP)
         {
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && this.rightWing["movie"])
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this._currentAction == CRY)
         {
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && this.rightWing["movie"])
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this._currentAction == HANDCLIP || this._currentAction == HANDCLIP_LACK_HP)
         {
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && this.rightWing["movie"])
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this._currentAction == SHOWGUN || this._currentAction == SHOWTHROWS)
         {
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && this.rightWing["movie"])
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this.leftWing && this.leftWing["movie"] && this.rightWing && this.rightWing["movie"])
         {
            this.leftWing["movie"].play();
            this.rightWing["movie"].play();
         }
         this._isPlaying = true;
      }
      
      override public function actionPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      override public function get currentAction() : *
      {
         return this._currentAction;
      }
      
      override public function setDefaultAction(param1:*) : void
      {
         if(param1 is PlayerAction)
         {
            this._currentAction = param1;
         }
      }
      
      override protected function setContent() : void
      {
         var _loc1_:Array = null;
         var _loc2_:BitmapData = null;
         var _loc3_:BitmapData = null;
         if(_loader != null)
         {
            if(this._ghostMovie)
            {
               ObjectUtils.disposeObject(this._ghostMovie);
            }
            this._ghostMovie = null;
            _loc1_ = _loader.getContent();
            if(_info.getShowSuits())
            {
               if(this._normalSuit && this._normalSuit != _loc1_[6])
               {
                  this._normalSuit.dispose();
               }
               this._normalSuit = _loc1_[6];
               if(this._lackHpSuit && this._lackHpSuit != _loc1_[7])
               {
                  this._lackHpSuit.dispose();
               }
               this._lackHpSuit = _loc1_[7];
               this._hasSuitSoul = this.checkHasSuitsSoul(this._lackHpSuit);
            }
            else
            {
               if(this._spBitmapData && this._spBitmapData != _loc1_[1])
               {
                  for each(_loc2_ in this._spBitmapData)
                  {
                     _loc2_.dispose();
                  }
               }
               this._spBitmapData = _loc1_[1];
               if(this._faceupBitmapData && this._faceupBitmapData != _loc1_[2])
               {
                  this._faceupBitmapData.dispose();
               }
               this._faceupBitmapData = _loc1_[2];
               if(this._faceBitmapData && this._faceBitmapData != _loc1_[3])
               {
                  this._faceBitmapData.dispose();
               }
               this._faceBitmapData = _loc1_[3];
               if(this._lackHpFaceBitmapdata && this._lackHpFaceBitmapdata != _loc1_[4])
               {
                  for each(_loc3_ in this._lackHpFaceBitmapdata)
                  {
                     _loc3_.dispose();
                  }
               }
               this._lackHpFaceBitmapdata = _loc1_[4];
               if(this._faceDownBitmapdata && this._faceDownBitmapdata != _loc1_[5])
               {
                  this._faceDownBitmapdata.dispose();
               }
               this._faceDownBitmapdata = _loc1_[5];
            }
            if(getQualifiedClassName(this._wing) != getQualifiedClassName(_loc1_[0]))
            {
               this.removeWing();
               this._wing = _loc1_[0];
               this.WingState = GAME_WING_WAIT;
            }
            this.drawBomd();
            this.drawSoul();
            this.CreateCryFrace(_info.Colors.split(",")[5]);
            this._isPlaying = true;
            this.update();
         }
      }
      
      private function checkHasSuitsSoul(param1:BitmapData) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Point = new Point(_characterWidth * 11 - _characterWidth / 2,_characterHeight * 3 - _characterHeight / 2);
         var _loc3_:int = _loc2_.x - 5;
         while(_loc3_ < _loc2_.x + 5)
         {
            _loc4_ = _loc2_.y - 5;
            while(_loc4_ < _loc2_.y + 5)
            {
               if(param1.getPixel(_loc3_,_loc4_) != 0)
               {
                  return true;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function removeWing() : void
      {
         if(this._wing == null)
         {
            return;
         }
         if(this.rightWing && this.rightWing.parent)
         {
            this.rightWing.parent.removeChild(this.rightWing);
         }
         if(this.leftWing && this.leftWing.parent)
         {
            this.leftWing.parent.removeChild(this.leftWing);
         }
         this._wing = null;
      }
      
      public function switchWingVisible(param1:Boolean) : void
      {
         if(this.leftWing && this.rightWing)
         {
            this.rightWing.visible = this.leftWing.visible = param1;
         }
      }
      
      public function setWingPos(param1:Number, param2:Number) : void
      {
         if(this.rightWing && this.leftWing)
         {
            this.rightWing.x = this.leftWing.x = param1;
            this.rightWing.y = this.leftWing.y = param2;
         }
      }
      
      public function setWingScale(param1:Number, param2:Number) : void
      {
         if(this.rightWing && this.leftWing)
         {
            this.leftWing.scaleX = this.rightWing.scaleX = param1;
            this.leftWing.scaleY = this.rightWing.scaleY = param2;
         }
      }
      
      public function set WingState(param1:int) : void
      {
         this._wingState = param1;
         if(this.leftWing && this.leftWing.totalFrames == 2 && this.rightWing && this.rightWing.totalFrames == 2)
         {
            if(this._wingState == GAME_WING_SHOOT)
            {
               this._wingState = 2;
            }
            else
            {
               this._wingState = 1;
            }
         }
         if(this.leftWing && this.rightWing)
         {
            this.leftWing.gotoAndStop(this._wingState);
            this.rightWing.gotoAndStop(this._wingState);
         }
      }
      
      public function get WingState() : int
      {
         return this._wingState;
      }
      
      public function get wing() : MovieClip
      {
         return this._wing;
      }
      
      public function get leftWing() : MovieClip
      {
         if(this._wing)
         {
            return this._wing["leftWing"];
         }
         return null;
      }
      
      public function get rightWing() : MovieClip
      {
         if(this._wing)
         {
            return this._wing["rightWing"];
         }
         return null;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeWing();
         ObjectUtils.disposeObject(this._ghostMovie);
         this._ghostMovie = null;
         ObjectUtils.disposeObject(this._ghostShine);
         this._ghostShine = null;
         ObjectUtils.disposeObject(this._spBitmapData);
         this._spBitmapData = null;
         ObjectUtils.disposeObject(this._faceupBitmapData);
         this._faceupBitmapData = null;
         ObjectUtils.disposeObject(this._faceBitmapData);
         this._faceBitmapData = null;
         ObjectUtils.disposeObject(this._lackHpFaceBitmapdata);
         this._lackHpFaceBitmapdata = null;
         ObjectUtils.disposeObject(this._faceDownBitmapdata);
         this._faceDownBitmapdata = null;
         ObjectUtils.disposeObject(this._normalSuit);
         this._normalSuit = null;
         ObjectUtils.disposeObject(this._lackHpSuit);
         this._lackHpSuit = null;
         ObjectUtils.disposeObject(this._soulFace);
         this._soulFace = null;
         ObjectUtils.disposeObject(this._tempCryFace);
         this._tempCryFace = null;
         if(this._cryBmps)
         {
            _loc1_ = 0;
            while(_loc1_ < this._cryBmps.length)
            {
               ObjectUtils.disposeObject(this._cryBmps[_loc1_]);
               this._cryBmps[_loc1_] = null;
               _loc1_++;
            }
         }
         ObjectUtils.disposeAllChildren(this._cryFrace);
         this._cryFrace = null;
         ObjectUtils.disposeObject(this.blackBm);
         this.blackBm = null;
         ObjectUtils.disposeObject(this.blackEyes);
         this.blackEyes = null;
         super.dispose();
         this._frameStartPoint = null;
         this._cryBmps = null;
      }
      
      private function drawSoul() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Matrix = null;
         var _loc5_:BitmapData = null;
         var _loc6_:int = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:Number = NaN;
         var _loc1_:Point = new Point(0,0);
         if(_info.getShowSuits())
         {
            this._soulFace = new BitmapData(this._normalSuit.width,this._normalSuit.height,true,0);
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               _loc1_.x = _characterWidth * _loc2_;
               this._soulFace.copyPixels(this._lackHpSuit,_frames[36],_loc1_,null,null,true);
               _loc2_++;
            }
         }
         else
         {
            this._soulFace = new BitmapData(this._faceBitmapData.width,this._faceBitmapData.height,true,0);
            _loc3_ = 0;
            _loc4_ = new Matrix();
            _loc5_ = new BitmapData(this._faceBitmapData.width,this._faceBitmapData.height,true,0);
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
               _loc1_.x = _characterWidth * _loc6_;
               switch(_loc6_)
               {
                  case 0:
                     _loc3_ = 0;
                     break;
                  case 1:
                     _loc3_ = 10;
                     break;
                  case 2:
                     _loc3_ = 14;
                     break;
                  case 3:
                     _loc3_ = 17;
                     break;
               }
               _loc1_.x = _characterWidth * _loc6_;
               this._soulFace.copyPixels(this._faceBitmapData,_frames[_loc3_],_loc1_,null,null,true);
               _loc6_++;
            }
            _loc4_.scale(0.75,0.75);
            _loc1_.x = _loc1_.y = 0;
            _loc5_.draw(this._soulFace,_loc4_,null,null,null,true);
            _loc7_ = new Rectangle(0,0,_characterWidth,_characterHeight);
            this._soulFace.fillRect(this._soulFace.rect,0);
            _loc8_ = 0;
            while(_loc8_ < 4)
            {
               _loc7_.x = _loc8_ * _characterWidth * 0.75;
               _loc1_.x = _characterWidth * _loc8_ + 7;
               _loc1_.y = 5;
               this._soulFace.copyPixels(this._faceDownBitmapdata,_frames[36],new Point(_loc8_ * _characterWidth,0),null,null,true);
               this._soulFace.copyPixels(_loc5_,_loc7_,_loc1_,null,null,true);
               this._soulFace.copyPixels(this._faceupBitmapData,_frames[36],new Point(_loc8_ * _characterWidth,0),null,null,true);
               _loc8_++;
            }
            _loc1_.x = _loc1_.y = 0;
            this._soulFace.applyFilter(this._soulFace,this._soulFace.rect,_loc1_,grayFilter);
            _loc5_.dispose();
         }
      }
      
      private function drawBomd() : void
      {
         var _loc1_:BitmapData = new BitmapData(_body.width,_body.height,true,0);
         _loc1_.fillRect(new Rectangle(0,0,_loc1_.height,_loc1_.height),0);
         if(_info.getShowSuits())
         {
            _loc1_.copyPixels(this._normalSuit,_frames[1],this._frameStartPoint,null,null,true);
         }
         else
         {
            _loc1_.copyPixels(this._faceDownBitmapdata,_frames[1],this._frameStartPoint,null,null,true);
            _loc1_.copyPixels(this._faceBitmapData,_frames[1],this._frameStartPoint,null,null,true);
            _loc1_.copyPixels(this._faceupBitmapData,_frames[1],this._frameStartPoint,null,null,true);
         }
         this.drawBlack(_loc1_);
         this.blackBm = new Bitmap(_loc1_);
         this.blackBm.x = _body.x;
         this.blackBm.y = _body.y;
         if(this.blackEyes == null)
         {
            this.blackEyes = ClassUtils.CreatInstance("asset.game.bombedAsset1") as MovieClip;
            this.blackEyes.x = 8;
            this.blackEyes.y = -10;
         }
      }
      
      override public function drawFrame(param1:int, param2:int = 0, param3:Boolean = true) : void
      {
         var _loc4_:BitmapData = null;
         if(param2 == 1)
         {
            _loc4_ = this._faceDownBitmapdata;
         }
         else if(param2 == 2)
         {
            _loc4_ = this._lackHpFaceBitmapdata[this._specialType];
         }
         else if(param2 == 3)
         {
            if(this._currentAction == CRY && this._cryType > 0)
            {
               _loc4_ = this._tempCryFace;
            }
            else
            {
               _loc4_ = this._faceBitmapData;
            }
         }
         else if(param2 == 4)
         {
            _loc4_ = this._faceupBitmapData;
         }
         else if(param2 == 5)
         {
            _loc4_ = this._spBitmapData[this._specialType];
         }
         else if(param2 == 6)
         {
            _loc4_ = this._normalSuit;
         }
         else if(param2 == 7)
         {
            _loc4_ = this._lackHpSuit;
         }
         else if(param2 == 8)
         {
            _loc4_ = this._soulFace;
         }
         if(this._currentAction == SOUL)
         {
            if(this.closeEys < 4)
            {
               param1 = 1;
            }
            else if(Math.random() < 0.008)
            {
               this.closeEys = 0;
            }
            ++this.closeEys;
         }
         if(_loc4_ != null)
         {
            if(param1 < 0 || param1 >= _frames.length)
            {
               param1 = 0;
            }
            _currentframe = param1;
            if(param3)
            {
               _body.bitmapData.fillRect(this._rect,0);
            }
            if(this._currentAction == CRY && (param2 == 2 || param2 == 3))
            {
               _body.bitmapData.copyPixels(_loc4_,_frames[param1 - this._cryTypes[this._cryType]],this._frameStartPoint,null,null,true);
            }
            else
            {
               _body.bitmapData.copyPixels(_loc4_,_frames[param1],this._frameStartPoint,null,null,true);
            }
         }
      }
   }
}
