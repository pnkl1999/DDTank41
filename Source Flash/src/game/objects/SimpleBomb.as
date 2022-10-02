package game.objects
{
   import ddt.manager.BallManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   import game.animations.PhysicalObjFocusAnimation;
   import game.animations.ShockMapAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.view.Bomb;
   import game.view.map.MapView;
   import game.view.smallMap.SmallBomb;
   import par.ParticleManager;
   import par.emitters.Emitter;
   import phy.bombs.BaseBomb;
   import phy.maps.Map;
   import phy.object.Physics;
   import phy.object.SmallObject;
   import road7th.utils.MovieClipWrapper;
   import room.model.RoomInfo;
   
   public class SimpleBomb extends BaseBomb
   {
       
      
      protected var _info:Bomb;
      
      protected var _lifeTime:int;
      
      protected var _owner:Living;
      
      protected var _emitters:Array;
      
      protected var _spinV:Number;
      
      protected var _blastMC:MovieClipWrapper;
      
      protected var _dir:int = 1;
      
      protected var _smallBall:SmallObject;
      
      private var _game:GameInfo;
      
      private var _bitmapNum:int;
      
      private var _refineryLevel:int;
      
      protected var _bullet:MovieClip;
      
      protected var _blastOut:MovieClip;
      
      protected var _crater:Bitmap;
      
      protected var _craterBrink:Bitmap;
      
      private var fastModel:Boolean;
      
      public function SimpleBomb(param1:Bomb, param2:Living, param3:int = 0)
      {
         this._info = param1;
         this._lifeTime = 0;
         this._owner = param2;
         this._bitmapNum = 0;
         this._refineryLevel = param3;
         this._emitters = new Array();
         this._smallBall = new SmallBomb();
         super(this._info.Id,param1.Template.Mass,param1.Template.Weight,param1.Template.Wind,param1.Template.DragIndex);
         this.createBallAsset();
      }
      
      public function get map() : MapView
      {
         return _map as MapView;
      }
      
      public function get info() : Bomb
      {
         return this._info;
      }
      
      public function get owner() : Living
      {
         return this._owner;
      }
      
      private function createBallAsset() : void
      {
         var _loc1_:BombAsset = null;
         this._bullet = BallManager.createBulletMovie(this.info.Template.ID);
         this._blastOut = BallManager.createBlastOutMovie(this.info.Template.blastOutID);
         if(BallManager.hasBombAsset(this.info.Template.craterID))
         {
            _loc1_ = BallManager.getBombAsset(this.info.Template.craterID);
            this._crater = _loc1_.crater;
            this._craterBrink = _loc1_.craterBrink;
         }
      }
      
      protected function initMovie() : void
      {
         super.setMovie(this._bullet,this._crater,this._craterBrink);
         if(this._blastOut)
         {
            this._blastOut.x = 0;
            this._blastOut.y = 0;
         }
         if(!this._info)
         {
            return;
         }
         this._blastMC = new MovieClipWrapper(this._blastOut,false,true);
         _testRect = new Rectangle(-3,-3,6,6);
         addSpeedXY(new Point(this._info.VX,this._info.VY));
         this._dir = this._info.VX >= 0 ? int(int(1)) : int(int(-1));
         x = this._info.X;
         y = this._info.Y;
         if(this._info.Template.SpinV > 0)
         {
            _movie.scaleX = this._dir;
         }
         else
         {
            _movie.scaleY = this._dir;
         }
         rotation = motionAngle * 180 / Math.PI;
         if(this.owner && !this.owner.isSelf && this._info.Template.ID == Bomb.FLY_BOMB && this.owner.isHidden)
         {
            this.visible = false;
            this._smallBall.visible = false;
         }
         mouseEnabled = false;
         mouseChildren = false;
         this.startMoving();
      }
      
      override public function setMap(param1:Map) : void
      {
         super.setMap(param1);
         if(param1)
         {
            this._game = this.map.game;
            this.initMovie();
         }
      }
      
      override public function startMoving() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Emitter = null;
         var _loc3_:Player = null;
         super.startMoving();
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         if(SharedManager.Instance.showParticle && visible)
         {
            _loc1_ = 0;
            if(this._info.changedPartical != "")
            {
               if(this.owner.isPlayer())
               {
                  _loc3_ = this.owner as Player;
                  _loc1_ = _loc3_.currentWeapInfo.refineryLevel;
               }
               _loc2_ = ParticleManager.creatEmitter(int(this._info.changedPartical));
            }
            if(_loc2_)
            {
               _map.particleEnginee.addEmitter(_loc2_);
               this._emitters.push(_loc2_);
            }
         }
         this._spinV = this._info.Template.SpinV * this._dir;
      }
      
      override public function get smallView() : SmallObject
      {
         return this._smallBall;
      }
      
      override public function moveTo(param1:Point) : void
      {
         var _loc2_:BombAction = null;
         var _loc3_:Emitter = null;
         while(this._info.Actions.length > 0)
         {
            if(this._info.Actions[0].time > this._lifeTime)
            {
               break;
            }
            _loc2_ = this._info.Actions.shift();
            this._info.UsedActions.push(_loc2_);
            _loc2_.execute(this,this._game);
            if(!_isLiving)
            {
               return;
            }
         }
         if(_isLiving)
         {
            if(_map.IsOutMap(param1.x,param1.y))
            {
               this.die();
            }
            else
            {
               this.map.smallMap.updatePos(this._smallBall,pos);
               for each(_loc3_ in this._emitters)
               {
                  _loc3_.x = x;
                  _loc3_.y = y;
                  _loc3_.angle = motionAngle;
               }
               pos = param1;
               if(GameManager.Instance.Current.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || GameManager.Instance.Current.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM && this._owner is Player && this._owner.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
               {
                  this.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this,25,0));
               }
            }
         }
      }
      
      public function clearWG() : void
      {
         _wf = 0;
         _gf = 0;
         _arf = 0;
      }
      
      override public function bomb() : void
      {
         var _loc2_:Physics = null;
         var _loc3_:uint = 0;
         this.map.transform.matrix = new Matrix();
         if(this._info.IsHole)
         {
            super.DigMap();
            this.map.smallMap.draw();
            this.map.resetMapChanged();
         }
         var _loc1_:Array = this.map.getPhysicalObjectByPoint(pos,100,this);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ is TombView || _loc2_ is GamePet)
            {
               _loc2_.startMoving();
            }
         }
         this.stopMoving();
         if(!this.fastModel)
         {
            if(this._info.Template.Shake)
            {
               _loc3_ = 7;
               if(this.info.damageMod < 1)
               {
                  _loc3_ = 4;
               }
               if(this.info.damageMod > 2)
               {
                  _loc3_ = 14;
               }
               this.map.animateSet.addAnimation(new ShockMapAnimation(this,_loc3_));
            }
            else if(GameManager.Instance.Current.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || GameManager.Instance.Current.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM && this._owner is Player && this._owner.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
            {
               this.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this,10));
            }
         }
         if(!this.fastModel)
         {
            if(_isLiving)
            {
               SoundManager.instance.play(this._info.Template.BombSound);
            }
            if(visible)
            {
               this._blastMC.movie.x = x;
               this._blastMC.movie.y = y;
               _map.addToPhyLayer(this._blastMC.movie);
               this._blastMC.addEventListener(Event.COMPLETE,this.__complete);
               this._blastMC.play();
            }
            else
            {
               this.die();
            }
         }
         else
         {
            this.die();
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      override public function bombAtOnce() : void
      {
         var _loc1_:BombAction = null;
         var _loc5_:BombAction = null;
         this.fastModel = true;
         var _loc2_:int = 0;
         while(_loc2_ < this._info.Actions.length)
         {
            if(this._info.Actions[_loc2_].type == ActionType.BOMB)
            {
               _loc1_ = this._info.Actions[_loc2_];
               break;
            }
            _loc2_++;
         }
         var _loc3_:int = this._info.Actions.indexOf(_loc1_);
         var _loc4_:Array = this._info.Actions.splice(_loc3_,1);
         if(_loc1_)
         {
            this._info.Actions.push(_loc1_);
         }
         while(this._info.Actions.length > 0)
         {
            _loc5_ = this._info.Actions.shift();
            this._info.UsedActions.push(_loc5_);
            _loc5_.execute(this,this._game);
            if(!_isLiving)
            {
               return;
            }
         }
         if(this._info)
         {
            this._info.Actions = [];
         }
      }
      
      private function __complete(param1:Event) : void
      {
         this.die();
      }
      
      override public function die() : void
      {
         super.die();
         this.dispose();
      }
      
      override public function stopMoving() : void
      {
         var _loc1_:Emitter = null;
         for each(_loc1_ in this._emitters)
         {
            _map.particleEnginee.removeEmitter(_loc1_);
         }
         this._emitters = [];
         super.stopMoving();
      }
      
      override protected function updatePosition(param1:Number) : void
      {
         this._lifeTime += 40;
         super.updatePosition(param1);
         if(!_isLiving)
         {
            return;
         }
         if(this._spinV > 1 || this._spinV < -1)
         {
            this._spinV = int(this._spinV * this._info.Template.SpinVA);
            _movie.rotation += this._spinV;
         }
         rotation = motionAngle * 180 / Math.PI;
      }
      
      public function get target() : Point
      {
         if(this._info)
         {
            return this._info.target;
         }
         return null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._blastMC)
         {
            this._blastMC.removeEventListener(Event.COMPLETE,this.__complete);
            this._blastMC.dispose();
            this._blastMC = null;
         }
         if(_map)
         {
            _map.removePhysical(this);
         }
         if(this._smallBall)
         {
            if(this._smallBall.parent)
            {
               this._smallBall.parent.removeChild(this._smallBall);
            }
            this._smallBall.dispose();
            this._smallBall = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this._crater = null;
         this._craterBrink = null;
         this._owner = null;
         this._emitters = null;
         this._info = null;
         this._game = null;
         this._bullet = null;
         this._blastOut = null;
      }
   }
}
