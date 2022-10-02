package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffType;
   import ddt.events.LivingCommandEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import ddt.view.chat.chatBall.ChatBallBase;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   import game.actions.BaseAction;
   import game.actions.LivingFallingAction;
   import game.actions.LivingJumpAction;
   import game.actions.LivingMoveAction;
   import game.actions.LivingTurnAction;
   import game.animations.ShockMapAnimation;
   import game.model.Living;
   import game.model.Player;
   import game.view.AutoPropEffect;
   import game.view.EffectIconContainer;
   import game.view.IDisplayPack;
   import game.view.LeftPlayerCartoonView;
   import game.view.buff.FightBuffBar;
   import game.view.effects.BaseMirariEffectIcon;
   import game.view.effects.MirariEffectIconManager;
   import game.view.effects.ShootPercentView;
   import game.view.effects.ShowEffect;
   import game.view.map.MapView;
   import game.view.smallMap.SmallLiving;
   import game.view.smallMap.SmallPlayer;
   import phy.object.PhysicalObj;
   import phy.object.PhysicsLayer;
   import phy.object.SmallObject;
   import road.game.resource.ActionMovie;
   import road.game.resource.ActionMovieEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.data.StringObject;
   import road7th.utils.AutoDisappear;
   import road7th.utils.MovieClipWrapper;
   import tank.events.ActionEvent;
   
   public class GameLiving extends PhysicalObj
   {
      
      protected static var SHOCK_EVENT:String = "shockEvent";
      
      protected static var SHOCK_EVENT2:String = "shockEvent2";
      
      protected static var SHIELD:String = "shield";
      
      protected static var BOMB_EVENT:String = "bombEvent";
      
      public static var SHOOT_PREPARED:String = "shootPrepared";
      
      protected static var RENEW:String = "renew";
      
      protected static var NEED_FOCUS:String = "focus";
      
      protected static var ATTACK_COMPLETE_FOCUS:String = "attackCompleteFocus";
      
      public static const stepY:int = 7;
      
      public static const npcStepX:int = 1;
      
      public static const npcStepY:int = 3;
      
      protected static var PLAY_EFFECT:String = "playeffect";
      
      protected static var PLAYER_EFFECT:String = "effect";
       
      
      protected var _info:Living;
      
      protected var _actionMovie:ActionMovie;
      
      protected var _chatballview:ChatBallBase;
      
      protected var _smallView:SmallLiving;
      
      protected var speedMult:int = 1;
      
      protected var _nickName:FilterFrameText;
      
      protected var _targetBlood:int;
      
      protected var targetAttackEffect:int;
      
      protected var _originalHeight:Number;
      
      protected var _originalWidth:Number;
      
      public var bodyWidth:Number;
      
      public var bodyHeight:Number;
      
      public var isExist:Boolean = true;
      
      protected var _turns:int;
      
      private var _offsetX:Number = 0;
      
      private var _offsetY:Number = 0;
      
      private var _speedX:Number = 3;
      
      private var _speedY:Number = 7;
      
      protected var _bloodStripBg:Bitmap;
      
      protected var _HPStrip:ScaleFrameImage;
      
      protected var _bloodWidth:int;
      
      protected var _buffBar:FightBuffBar;
      
      private var _effectIconContainer:EffectIconContainer;
      
      private var _buffEffect:DictionaryData;
      
      protected var counter:int = 1;
      
      protected var ap:Number = 0;
      
      protected var effectForzen:Sprite;
      
      protected var lock:MovieClip;
      
      protected var _isDie:Boolean = false;
      
      protected var _effRect:Rectangle;
      
      private var _attackEffectPlayer:PhysicalObj;
      
      private var _attackEffectPlaying:Boolean = false;
      
      protected var _attackEffectPos:Point;
      
      protected var _moviePool:Object;
      
      private var _hiddenByServer:Boolean;
      
      protected var _propArray:Array;
      
      private var _onSmallMap:Boolean = true;
      
      protected var danhhieu:Sprite;
      
      public function GameLiving(param1:Living)
      {
         this._buffEffect = new DictionaryData();
         this._attackEffectPos = new Point(0,5);
         this._moviePool = new Object();
         this._info = param1;
         this.initView();
         this.initListener();
         super(param1.LivingID);
      }
      
      public static function getAttackEffectAssetByID(param1:int) : MovieClip
      {
         return ClassUtils.CreatInstance("asset.game.AttackEffect" + param1.toString()) as MovieClip;
      }
      
      public function get stepX() : int
      {
         return this._speedX * this.speedMult;
      }
      
      public function get stepY() : int
      {
         return this._speedY * this.speedMult;
      }
      
      override public function get x() : Number
      {
         return super.x + this._offsetX;
      }
      
      override public function get y() : Number
      {
         return super.y + this._offsetY;
      }
      
      public function get EffectIcon() : EffectIconContainer
      {
         if(this._effectIconContainer == null)
         {
         }
         return this._effectIconContainer;
      }
      
      override public function get layer() : int
      {
         if(this.info.isBottom)
         {
            return PhysicsLayer.AppointBottom;
         }
         return PhysicsLayer.GameLiving;
      }
      
      public function get info() : Living
      {
         return this._info;
      }
      
      public function get map() : MapView
      {
         return _map as MapView;
      }
      
      protected function initView() : void
      {
         this._bloodStripBg = ComponentFactory.Instance.creatBitmap("asset.game.smallHPStripBgAsset");
         this._HPStrip = ComponentFactory.Instance.creatComponentByStylename("asset.game.HPStrip");
         this._HPStrip.x += this._bloodStripBg.x = -this._bloodStripBg.width / 2 + 2;
         this._HPStrip.y += this._bloodStripBg.y = 20;
         this._bloodWidth = this._HPStrip.width;
         addChild(this._bloodStripBg);
         addChild(this._HPStrip);
         this._HPStrip.setFrame(this.info.team);
         this._nickName = ComponentFactory.Instance.creatComponentByStylename("GameLiving.nickName");
         if(this.info.playerInfo != null)
         {
            this._nickName.text = this.info.playerInfo.NickName;
         }
         else
         {
            this._nickName.text = this.info.name;
         }
         this._nickName.setFrame(this.info.team);
         this._nickName.x = -this._nickName.width / 2 + 2;
         this._nickName.y = this._bloodStripBg.y + this._bloodStripBg.height / 2 + 4;
         this._buffBar = new FightBuffBar();
         this._buffBar.y = -98;
         addChild(this._buffBar);
         this._buffBar.update(this._info.turnBuffs);
         this._buffBar.x = -(this._buffBar.width / 2);
         addChild(this._nickName);
         this.initSmallMapObject();
         mouseChildren = mouseEnabled = false;
         if(this.info.playerInfo != null && this.info.playerInfo.honor != "")
         {
            if(this.info.playerInfo.honor == "Kẻ Nào Không Phục")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Giáng Sinh Tuyết Trắng")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu1") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Tiểu Ác Ma")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu2") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Hoa Ngọt Ngào")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu3") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Vô Song")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu4") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Nhất Chi Hoa")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu5") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Soái Ca")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu6") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Bối Rối")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu8") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Bá Chủ")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu9") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Nữ Hoàng Vương Quốc")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu10") as MovieClip;
            }
            else if(this.info.playerInfo.honor == "Điện Nước Đầy Đủ")
            {
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu7") as MovieClip;
            }
            else
            {
               if(this.info.playerInfo.honor != "Vozer")
               {
                  return;
               }
               this.danhhieu = ClassUtils.CreatInstance("asset.danhhieu11") as MovieClip;
            }
            this.danhhieu.y = -20;
            this.danhhieu.x = -5;
            addChild(this.danhhieu);
         }
      }
      
      protected function initSmallMapObject() : void
      {
         var _loc1_:SmallPlayer = null;
         if(this._info.isPlayer())
         {
            _loc1_ = new SmallPlayer();
            this._smallView = _loc1_;
         }
         else
         {
            this._smallView = new SmallLiving();
         }
         this._smallView.info = this._info;
      }
      
      protected function initEffectIcon() : void
      {
      }
      
      protected function initFreezonRect() : void
      {
         this._effRect = new Rectangle(0,24,200,200);
      }
      
      public function addChildrenByPack(param1:IDisplayPack) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in param1.content)
         {
            addChild(_loc2_);
         }
      }
      
      protected function initListener() : void
      {
         this._info.addEventListener(LivingEvent.BEAT,this.__beat);
         this._info.addEventListener(LivingEvent.BEGIN_NEW_TURN,this.__beginNewTurn);
         this._info.addEventListener(LivingEvent.BLOOD_CHANGED,this.__bloodChanged);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
         this._info.addEventListener(LivingEvent.DIR_CHANGED,this.__dirChanged);
         this._info.addEventListener(LivingEvent.FALL,this.__fall);
         this._info.addEventListener(LivingEvent.FORZEN_CHANGED,this.__forzenChanged);
         this._info.addEventListener(LivingEvent.HIDDEN_CHANGED,this.__hiddenChanged);
         this._info.addEventListener(LivingEvent.PLAY_MOVIE,this.__playMovie);
         this._info.addEventListener(LivingEvent.TURN_ROTATION,this.__turnRotation);
         this._info.addEventListener(LivingEvent.JUMP,this.__jump);
         this._info.addEventListener(LivingEvent.MOVE_TO,this.__moveTo);
         this._info.addEventListener(LivingEvent.MAX_HP_CHANGED,this.__maxHpChanged);
         this._info.addEventListener(LivingEvent.LOCK_STATE,this.__lockStateChanged);
         this._info.addEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this._info.addEventListener(LivingEvent.SHOOT,this.__shoot);
         this._info.addEventListener(LivingEvent.TRANSMIT,this.__transmit);
         this._info.addEventListener(LivingEvent.SAY,this.__say);
         this._info.addEventListener(LivingEvent.START_MOVING,this.__startMoving);
         this._info.addEventListener(LivingEvent.CHANGE_STATE,this.__changeState);
         this._info.addEventListener(LivingEvent.SHOW_ATTACK_EFFECT,this.__showAttackEffect);
         this._info.addEventListener(LivingEvent.BOMBED,this.__bombed);
         this._info.addEventListener(LivingEvent.PLAYSKILLMOVIE,this.__playSkillMovie);
         this._info.addEventListener(LivingEvent.BUFF_CHANGED,this.__buffChanged);
         this._info.addEventListener(LivingEvent.PLAY_CONTINUOUS_EFFECT,this.__playContinuousEffect);
         this._info.addEventListener(LivingEvent.REMOVE_CONTINUOUS_EFFECT,this.__removeContinuousEffect);
         this._info.addEventListener(LivingEvent.GEM_DEFENSE_CHANGED,this.__gemDefenseChanged);
         this._info.addEventListener(LivingCommandEvent.COMMAND,this.__onLivingCommand);
         this._chatballview.addEventListener(Event.COMPLETE,this.onChatBallComplete);
         if(this._actionMovie)
         {
            this._actionMovie.addEventListener("renew",this.__renew);
            this._actionMovie.addEventListener(SHOCK_EVENT2,this.__shockMap2);
            this._actionMovie.addEventListener(SHOCK_EVENT,this.__shockMap);
            this._actionMovie.addEventListener(NEED_FOCUS,this.__needFocus);
            this._actionMovie.addEventListener(SHIELD,this.__showDefence);
            this._actionMovie.addEventListener(ATTACK_COMPLETE_FOCUS,this.__attackCompleteFocus);
            this._actionMovie.addEventListener(BOMB_EVENT,this.__startBlank);
            this._actionMovie.addEventListener(PLAY_EFFECT,this.__playEffect);
            this._actionMovie.addEventListener(PLAYER_EFFECT,this.__playerEffect);
         }
      }
      
      protected function __maxHpChanged(param1:LivingEvent) : void
      {
         this.updateBloodStrip();
      }
      
      protected function __playContinuousEffect(param1:LivingEvent) : void
      {
         this.showBuffEffect(param1.paras[0],int(param1.paras[1]));
      }
      
      protected function __removeContinuousEffect(param1:LivingEvent) : void
      {
         this.removeBuffEffect(int(param1.paras[0]));
      }
      
      protected function __playEffect(param1:ActionMovieEvent) : void
      {
      }
      
      protected function __playerEffect(param1:ActionMovieEvent) : void
      {
      }
      
      private function __buffChanged(param1:LivingEvent) : void
      {
         if(param1.paras[0] == BuffType.Turn && this._info)
         {
            this._buffBar.update(this._info.turnBuffs);
            if(this._info.turnBuffs.length > 0)
            {
               this._buffBar.x = 5 - this._buffBar.width / 2;
               this._buffBar.y = this.bodyHeight * -1 - 23;
               addChild(this._buffBar);
            }
            else if(this._buffBar.parent)
            {
               this._buffBar.parent.removeChild(this._buffBar);
            }
         }
      }
      
      protected function __removeSkillMovie(param1:LivingEvent) : void
      {
      }
      
      protected function __applySkill(param1:LivingEvent) : void
      {
      }
      
      protected function __playSkillMovie(param1:LivingEvent) : void
      {
         var _loc3_:MovieClipWrapper = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:Point = null;
         var _loc2_:MovieClip = ClassUtils.CreatInstance("asset.game.propanimation." + param1.paras[0]);
         if(_loc2_)
         {
            _loc3_ = new MovieClipWrapper(_loc2_,true,true);
            _loc3_.addEventListener(Event.COMPLETE,this.__skillMovieComplete);
            if(param1.paras[0] == "guild")
            {
               _loc4_ = _map;
               _loc5_ = parent.localToGlobal(this._info.pos);
               _loc5_ = _loc4_.globalToLocal(_loc5_);
               _loc3_.movie.x = _loc5_.x;
               _loc3_.movie.y = _loc5_.y;
               _loc4_.addChild(_loc3_.movie);
            }
            else
            {
               addChild(_loc3_.movie);
            }
         }
      }
      
      protected function __skillMovieComplete(param1:Event) : void
      {
         var _loc2_:MovieClipWrapper = param1.currentTarget as MovieClipWrapper;
         _loc2_.removeEventListener(Event.COMPLETE,this.__skillMovieComplete);
      }
      
      protected function __bombed(param1:LivingEvent) : void
      {
      }
      
      protected function removeListener() : void
      {
         this._info.removeEventListener(LivingEvent.BEAT,this.__beat);
         this._info.removeEventListener(LivingEvent.BEGIN_NEW_TURN,this.__beginNewTurn);
         this._info.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__bloodChanged);
         this._info.removeEventListener(LivingEvent.DIE,this.__die);
         this._info.removeEventListener(LivingEvent.DIR_CHANGED,this.__dirChanged);
         this._info.removeEventListener(LivingEvent.FALL,this.__fall);
         this._info.removeEventListener(LivingEvent.FORZEN_CHANGED,this.__forzenChanged);
         this._info.removeEventListener(LivingEvent.HIDDEN_CHANGED,this.__hiddenChanged);
         this._info.removeEventListener(LivingEvent.PLAY_MOVIE,this.__playMovie);
         this._info.removeEventListener(LivingEvent.TURN_ROTATION,this.__turnRotation);
         this._info.removeEventListener(LivingEvent.PLAYSKILLMOVIE,this.__playSkillMovie);
         this._info.removeEventListener(LivingEvent.REMOVESKILLMOVIE,this.__removeSkillMovie);
         this._info.removeEventListener(LivingEvent.JUMP,this.__jump);
         this._info.removeEventListener(LivingEvent.MOVE_TO,this.__moveTo);
         this._info.removeEventListener(LivingEvent.MAX_HP_CHANGED,this.__maxHpChanged);
         this._info.removeEventListener(LivingEvent.LOCK_STATE,this.__lockStateChanged);
         this._info.removeEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this._info.removeEventListener(LivingEvent.SHOOT,this.__shoot);
         this._info.removeEventListener(LivingEvent.TRANSMIT,this.__transmit);
         this._info.removeEventListener(LivingEvent.SAY,this.__say);
         this._info.removeEventListener(LivingEvent.START_MOVING,this.__startMoving);
         this._info.removeEventListener(LivingEvent.CHANGE_STATE,this.__changeState);
         this._info.removeEventListener(LivingEvent.SHOW_ATTACK_EFFECT,this.__showAttackEffect);
         this._info.removeEventListener(LivingEvent.BOMBED,this.__bombed);
         this._info.removeEventListener(LivingEvent.APPLY_SKILL,this.__applySkill);
         this._info.removeEventListener(LivingEvent.BUFF_CHANGED,this.__buffChanged);
         this._info.removeEventListener(LivingEvent.GEM_DEFENSE_CHANGED,this.__gemDefenseChanged);
         this._chatballview.removeEventListener(Event.COMPLETE,this.onChatBallComplete);
         if(this._actionMovie)
         {
            this._actionMovie.removeEventListener("renew",this.__renew);
            this._actionMovie.removeEventListener(SHOCK_EVENT2,this.__shockMap2);
            this._actionMovie.removeEventListener(SHOCK_EVENT,this.__shockMap);
            this._actionMovie.removeEventListener(NEED_FOCUS,this.__needFocus);
            this._actionMovie.removeEventListener(SHIELD,this.__showDefence);
            this._actionMovie.removeEventListener(BOMB_EVENT,this.__startBlank);
            this._actionMovie.removeEventListener(PLAY_EFFECT,this.__playEffect);
            this._actionMovie.removeEventListener(PLAYER_EFFECT,this.__playerEffect);
         }
      }
      
      protected function __shockMap(param1:ActionEvent) : void
      {
         if(this.map)
         {
            this.map.animateSet.addAnimation(new ShockMapAnimation(this,param1.param as int,20));
         }
      }
      
      protected function __shockMap2(param1:Event) : void
      {
         if(this.map)
         {
            this.map.animateSet.addAnimation(new ShockMapAnimation(this,30,20));
         }
      }
      
      protected function __renew(param1:Event) : void
      {
         this._info.showAttackEffect(2);
      }
      
      protected function __startBlank(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.drawBlank);
      }
      
      protected function drawBlank(param1:Event) : void
      {
         if(this.counter <= 15)
         {
            graphics.clear();
            this.ap = 1 / 225 * (this.counter * this.counter);
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else if(this.counter <= 23)
         {
            graphics.clear();
            this.ap = 1;
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else if(this.counter <= 75)
         {
            graphics.clear();
            this.ap -= 0.02;
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else
         {
            graphics.clear();
            removeEventListener(Event.ENTER_FRAME,this.drawBlank);
         }
         ++this.counter;
      }
      
      protected function __showDefence(param1:Event) : void
      {
         var _loc2_:ShowEffect = null;
         _loc2_ = null;
         _loc2_ = new ShowEffect(ShowEffect.GUARD);
         _loc2_.x = this.x + this.offset();
         _loc2_.y = this.y - 50 + this.offset(25);
         _map.addChild(_loc2_);
      }
      
      protected function __addEffectHandler(param1:DictionaryEvent) : void
      {
         var _loc2_:BaseMirariEffectIcon = param1.data as BaseMirariEffectIcon;
         this.EffectIcon.handleEffect(_loc2_.mirariType,_loc2_.getEffectIcon());
      }
      
      protected function __removeEffectHandler(param1:DictionaryEvent) : void
      {
         var _loc2_:BaseMirariEffectIcon = param1.data as BaseMirariEffectIcon;
         this.EffectIcon.removeEffect(_loc2_.mirariType);
      }
      
      protected function __clearEffectHandler(param1:DictionaryEvent) : void
      {
         this.EffectIcon.clearEffectIcon();
      }
      
      protected function __sizeChangeHandler(param1:Event) : void
      {
         this.EffectIcon.x = 5 - this.EffectIcon.width / 2;
         this.EffectIcon.y = this.bodyHeight * -1 - this.EffectIcon.height;
      }
      
      protected function __changeState(param1:LivingEvent) : void
      {
      }
      
      protected function initMovie() : void
      {
         var _loc1_:Class = null;
         if(ModuleLoader.hasDefinition(this.info.actionMovieName))
         {
            _loc1_ = ModuleLoader.getDefinition(this.info.actionMovieName) as Class;
            this._actionMovie = new _loc1_();
            this._info.actionMovieBitmap = new Bitmap(this.getBodyBitmapData("show2"));
            this._info.thumbnail = this.getBodyBitmapData("show");
            this._actionMovie.mouseEnabled = false;
            this._actionMovie.mouseChildren = false;
            this._actionMovie.scrollRect = null;
            addChild(this._actionMovie);
            this._actionMovie.gotoAndStop(1);
            this._actionMovie.scaleX = -this._info.direction;
            this.initChatball();
            return;
         }
         throw new Error("找不到 info.actionMovieName : " + this.info.actionMovieName);
      }
      
      protected function initChatball() : void
      {
         this._chatballview = new ChatBallPlayer();
         this._originalHeight = this._actionMovie.height;
         this._originalWidth = this._actionMovie.width;
         addChild(this._chatballview);
      }
      
      protected function __startMoving(param1:LivingEvent) : void
      {
         var _loc2_:Point = _map.findYLineNotEmptyPointDown(this.x,this.y,_map.height);
         if(_loc2_ == null)
         {
            _loc2_ = new Point(this.x,_map.height + 1);
         }
         this._info.fallTo(_loc2_,20);
      }
      
      protected function __say(param1:LivingEvent) : void
      {
         if(this._info.isHidden)
         {
            return;
         }
         this._chatballview.x = 0;
         this._chatballview.y = 0;
         addChild(this._chatballview);
         var _loc2_:String = param1.paras[0] as String;
         var _loc3_:int = 0;
         if(param1.paras[1])
         {
            _loc3_ = param1.paras[1];
         }
         this._chatballview.setText(_loc2_,_loc3_);
         this.fitChatBallPos();
      }
      
      protected function fitChatBallPos() : void
      {
         this._chatballview.x = this.popPos.x;
         this._chatballview.y = this.popPos.y;
         this._chatballview.directionX = this.movie.scaleX;
         if(this.popDir)
         {
            this._chatballview.directionY = this.popDir.y - this._chatballview.y;
         }
      }
      
      protected function get popPos() : Point
      {
         if(this.movie["popupPos"])
         {
            return new Point(this.movie["popupPos"].x,this.movie["popupPos"].y);
         }
         return new Point(-(this._originalWidth * 0.4) * this.movie.scaleX,-(this._originalHeight * 0.8) * this.movie.scaleY);
      }
      
      protected function get popDir() : Point
      {
         if(this.movie["popupDir"])
         {
            return new Point(this.movie["popupDir"].x,this.movie["popupDir"].y);
         }
         return this.popPos;
      }
      
      override public function collidedByObject(param1:PhysicalObj) : void
      {
      }
      
      protected function __beat(param1:LivingEvent) : void
      {
         if(_isLiving)
         {
            this.targetAttackEffect = param1.paras[0][0].attackEffect;
            this._actionMovie.doAction(param1.paras[0][0].action,this.updateTargetsBlood,param1.paras);
         }
      }
      
      protected function updateTargetsBlood(param1:Array) : void
      {
         var _loc4_:Living = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] && param1[_loc3_].target && param1[_loc3_].target.isLiving)
            {
               _loc4_ = param1[_loc3_].target;
               _loc4_.isHidden = false;
               _loc4_.showAttackEffect(param1[_loc3_].attackEffect);
               _loc4_.updateBlood(param1[_loc3_].targetBlood,3,param1[_loc3_].damage);
               if(!_loc2_)
               {
                  this.map.setCenter(_loc4_.pos.x,_loc4_.pos.y - 150,true);
               }
               if(_loc4_.isSelf)
               {
                  _loc2_ = true;
               }
            }
            _loc3_++;
         }
      }
      
      protected function __beginNewTurn(param1:LivingEvent) : void
      {
      }
      
      protected function __playMovie(param1:LivingEvent) : void
      {
         this._actionMovie.doAction(param1.paras[0]);
      }
      
      protected function __turnRotation(param1:LivingEvent) : void
      {
         this.act(new LivingTurnAction(this,param1.paras[0],param1.paras[1],param1.paras[2]));
      }
      
      protected function __bloodChanged(param1:LivingEvent) : void
      {
         var _loc3_:ShootPercentView = null;
         var _loc5_:int = 0;
         if(!this.isExist || !_map)
         {
            return;
         }
         var _loc2_:Number = param1.value - param1.old;
         var _loc6_:int = param1.paras[0];
         switch(_loc6_)
         {
            case 0:
               _loc2_ = param1.paras[1];
               if(_loc2_ != 0 && this._info.blood != 0)
               {
                  _loc3_ = new ShootPercentView(Math.abs(_loc2_),1,true);
                  _loc3_.x = this.x + this.offset();
                  _loc3_.y = this.y - 50 + this.offset(25);
                  _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(_loc3_);
                  if(this._info.isHidden)
                  {
                     if(this._info.team == GameManager.Instance.Current.selfGamePlayer.team)
                     {
                        _loc3_.alpha == 0.5;
                     }
                     else
                     {
                        this.visible = false;
                        _loc3_.alpha = 0;
                     }
                  }
               }
               break;
            case 90:
               _loc3_ = new ShootPercentView(0,2);
               _loc3_.x = this.x + this.offset();
               _loc3_.y = this.y - 50 + this.offset(25);
               _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
               _map.addToPhyLayer(_loc3_);
               break;
            case 5:
               break;
            case 3:
               _loc5_ = param1.paras[1];
               _loc2_ = _loc5_;
               if(_loc2_ != 0)
               {
                  _loc3_ = new ShootPercentView(Math.abs(_loc2_),1,false);
                  _loc3_.x = this.x + this.offset();
                  _loc3_.y = this.y - 50 + this.offset(25);
                  _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(_loc3_);
               }
               break;
            case 11:
               _loc5_ = param1.paras[1];
               if(_loc5_ < 0)
               {
                  _loc2_ = _loc5_;
               }
               if(_loc2_ != 0)
               {
                  _loc3_ = new ShootPercentView(Math.abs(_loc2_),param1.paras[0],false);
                  _loc3_.x = this.x - 70;
                  _loc3_.y = this.y - 80;
                  _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(_loc3_);
               }
               break;
            default:
               _loc5_ = param1.paras[1];
               if(_loc5_ < 0)
               {
                  _loc2_ = _loc5_;
               }
               if(_loc2_ != 0)
               {
                  _loc3_ = new ShootPercentView(Math.abs(_loc2_),param1.paras[0],false);
                  _loc3_.x = this.x + this.offset();
                  _loc3_.y = this.y - 50 + this.offset(25);
                  _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(_loc3_);
               }
         }
         this.updateBloodStrip();
      }
      
      protected function updateBloodStrip() : void
      {
         if(this.info.blood < 0)
         {
            this._HPStrip.width = 0;
         }
         else
         {
            this._HPStrip.width = Math.floor(this._bloodWidth / this.info.maxBlood * this.info.blood);
         }
      }
      
      private function offset(param1:int = 30) : int
      {
         var _loc2_:int = int(Math.random() * 10);
         if(_loc2_ % 2 == 0)
         {
            return -int(Math.random() * param1);
         }
         return int(Math.random() * param1);
      }
      
      protected function __die(param1:LivingEvent) : void
      {
         if(_isLiving)
         {
            this._info.MirariEffects.removeEventListener(DictionaryEvent.ADD,this.__addEffectHandler);
            this._info.MirariEffects.removeEventListener(DictionaryEvent.REMOVE,this.__removeEffectHandler);
            this._info.MirariEffects.removeEventListener(DictionaryEvent.CLEAR,this.__clearEffectHandler);
            _isLiving = false;
            this.die();
         }
      }
      
      override public function die() : void
      {
         this.info.isFrozen = false;
         this.info.isNoNole = false;
         this.info.isHidden = false;
         if(this._bloodStripBg && this._bloodStripBg.parent)
         {
            this._bloodStripBg.parent.removeChild(this._bloodStripBg);
         }
         if(this._HPStrip && this._HPStrip.parent)
         {
            this._HPStrip.parent.removeChild(this._HPStrip);
         }
         this.removeAllPetBuffEffects();
      }
      
      protected function __dirChanged(param1:LivingEvent) : void
      {
         if(this._info.direction > 0)
         {
            this.movie.scaleX = -1;
         }
         else
         {
            this.movie.scaleX = 1;
         }
      }
      
      protected function __forzenChanged(param1:LivingEvent) : void
      {
         if(this._info.isFrozen)
         {
            this.effectForzen = ClassUtils.CreatInstance("asset.gameFrostEffectAsset") as MovieClip;
            this.effectForzen.y = 24;
            addChild(this.effectForzen);
         }
         else if(this.effectForzen)
         {
            removeChild(this.effectForzen);
            this.effectForzen = null;
         }
      }
      
      protected function __gemDefenseChanged(param1:LivingEvent) : void
      {
      }
      
      protected function __noholeChanged(param1:LivingEvent) : void
      {
         var _loc2_:BaseMirariEffectIcon = MirariEffectIconManager.getInstance().createEffectIcon(MirariType.NoHole);
         if(this._info.isNoNole)
         {
            this._info.handleMirariEffect(_loc2_);
         }
         else
         {
            this._info.removeMirariEffect(_loc2_);
         }
      }
      
      protected function __lockStateChanged(param1:LivingEvent) : void
      {
         if(this._info.LockState)
         {
            this.lock = ClassUtils.CreatInstance("asset.gameII.LockAsset") as MovieClip;
            this.lock.x = 10;
            this.lock.y = 5;
            addChild(this.lock);
            if(param1.paras[0] == 2)
            {
               this.lock.y += 50;
               this.lock.scaleY = 0.8;
               this.lock.scaleX = 0.8;
               this.lock.stop();
               this.lock.alpha = 0.7;
            }
         }
         else if(this.lock)
         {
            removeChild(this.lock);
            this.lock = null;
         }
      }
      
      protected function __hiddenChanged(param1:LivingEvent) : void
      {
         if(this._info.isHidden)
         {
            if(this._info.team != GameManager.Instance.Current.selfGamePlayer.team)
            {
               this.visible = false;
               if(this._smallView)
               {
                  this._smallView.visible = false;
                  this._smallView.alpha = 0;
               }
               alpha = 0;
            }
            else
            {
               alpha = 0.5;
               if(this._smallView)
               {
                  this._smallView.alpha = 0.5;
               }
            }
         }
         else
         {
            alpha = 1;
            this.visible = true;
            if(this._smallView)
            {
               this._smallView.visible = true;
               this._smallView.alpha = 1;
            }
            parent.addChild(this);
         }
      }
      
      protected function __posChanged(param1:LivingEvent) : void
      {
         var _loc2_:Number = NaN;
         pos = this._info.pos;
         if(_isLiving)
         {
            _loc2_ = calcObjectAngle(16);
            this._info.playerAngle = _loc2_;
         }
         if(this.map)
         {
            this.map.smallMap.updatePos(this._smallView,pos);
         }
      }
      
      protected function __jump(param1:LivingEvent) : void
      {
         this.doAction(param1.paras[2]);
         this.act(new LivingJumpAction(this,param1.paras[0],param1.paras[1],param1.paras[3]));
      }
      
      protected function __moveTo(param1:LivingEvent) : void
      {
         var _loc13_:Point = null;
         var _loc2_:String = param1.paras[4];
         this.doAction(_loc2_);
         var _loc3_:int = param1.paras[5];
         if(_loc3_ == 0)
         {
            _loc3_ = 7;
         }
         var _loc4_:Point = param1.paras[1] as Point;
         var _loc5_:int = param1.paras[2];
         var _loc6_:String = param1.paras[6];
         if(this.x == _loc4_.x && this.y == _loc4_.y)
         {
            return;
         }
         var _loc7_:Array = [];
         var _loc8_:int = this.x;
         var _loc9_:int = this.y;
         var _loc10_:Point = new Point(this.x,this.y);
         var _loc11_:int = _loc4_.x > _loc8_ ? int(int(1)) : int(int(-1));
         var _loc12_:Point = new Point(this.x,this.y);
         if(_loc2_.substr(0,3) == "fly")
         {
            _loc13_ = new Point(_loc4_.x - _loc12_.x,_loc4_.y - _loc12_.y);
            while(_loc13_.length > _loc3_)
            {
               _loc13_.normalize(_loc3_);
               _loc12_ = new Point(_loc12_.x + _loc13_.x,_loc12_.y + _loc13_.y);
               _loc13_ = new Point(_loc4_.x - _loc12_.x,_loc4_.y - _loc12_.y);
               if(!_loc12_)
               {
                  _loc7_.push(_loc4_);
               }
               _loc7_.push(_loc12_);
            }
         }
         else
         {
            while((_loc4_.x - _loc8_) * _loc11_ > 0)
            {
               _loc12_ = _map.findNextWalkPoint(_loc8_,_loc9_,_loc11_,_loc3_ * npcStepX,_loc3_ * npcStepY);
               if(!_loc12_)
               {
                  break;
               }
               _loc7_.push(_loc12_);
               _loc8_ = _loc12_.x;
               _loc9_ = _loc12_.y;
            }
         }
         if(_loc7_.length > 0)
         {
            this._info.act(new LivingMoveAction(this,_loc7_,_loc5_,_loc6_));
         }
         else if(_loc6_ != "")
         {
            this.doAction(_loc6_);
         }
         else
         {
            this._info.doDefaultAction();
         }
      }
      
      public function canMoveDirection(param1:Number) : Boolean
      {
         return !this.map.IsOutMap(this.x + (15 + Player.MOVE_SPEED) * param1,this.y);
      }
      
      public function canStand(param1:int, param2:int) : Boolean
      {
         return !this.map.IsEmpty(param1 - 1,param2) || !this.map.IsEmpty(param1 + 1,param2);
      }
      
      public function getNextWalkPoint(param1:int) : Point
      {
         if(this.canMoveDirection(param1))
         {
            return _map.findNextWalkPoint(this.x,this.y,param1,this.stepX,this.stepY);
         }
         return null;
      }
      
      private function __needFocus(param1:ActionMovieEvent) : void
      {
         if(param1.data)
         {
            this.needFocus(param1.data.x,param1.data.y,param1.data);
         }
      }
      
      public function needFocus(param1:int = 0, param2:int = 0, param3:Object = null) : void
      {
         this.map.livingSetCenter(this.x + param1,this.y + param2 - 150,true,2,param3);
      }
      
      private function __attackCompleteFocus(param1:ActionMovieEvent) : void
      {
         this.map.setSelfCenter(true,2,param1.data);
      }
      
      protected function __shoot(param1:LivingEvent) : void
      {
      }
      
      protected function __transmit(param1:LivingEvent) : void
      {
         this.info.pos = param1.paras[0];
      }
      
      protected function __fall(param1:LivingEvent) : void
      {
         this._info.act(new LivingFallingAction(this,param1.paras[0],param1.paras[1],param1.paras[3]));
      }
      
      public function get actionMovie() : ActionMovie
      {
         return this._actionMovie;
      }
      
      public function get movie() : Sprite
      {
         return this._actionMovie;
      }
      
      public function doAction(param1:*) : void
      {
         if(this._actionMovie != null)
         {
            this._actionMovie.doAction(param1);
         }
      }
      
      public function act(param1:BaseAction) : void
      {
         this._info.act(param1);
      }
      
      public function traceCurrentAction() : void
      {
         this._info.traceCurrentAction();
      }
      
      override public function update(param1:Number) : void
      {
         if(this._isDie)
         {
            return;
         }
         super.update(param1);
         this._info.update();
      }
      
      private function getBodyBitmapData(param1:String = "") : BitmapData
      {
         var _loc2_:Number = this._actionMovie.width;
         var _loc3_:Sprite = new Sprite();
         this.bodyWidth = this._actionMovie.width;
         this.bodyHeight = this._actionMovie.height;
         this._actionMovie.gotoAndStop(param1);
         var _loc4_:Boolean = false;
         if(LeftPlayerCartoonView.SHOW_BITMAP_WIDTH < this._actionMovie.width)
         {
            this._actionMovie.width = LeftPlayerCartoonView.SHOW_BITMAP_WIDTH;
            this._actionMovie.scaleY = this._actionMovie.scaleX;
            _loc4_ = true;
         }
         _loc3_.addChild(this._actionMovie);
         var _loc5_:Rectangle = this._actionMovie.getBounds(this._actionMovie);
         this._actionMovie.x = -_loc5_.x * this._actionMovie.scaleX;
         this._actionMovie.y = -_loc5_.y * this._actionMovie.scaleX;
         var _loc6_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,true,0);
         _loc6_.draw(_loc3_);
         if(_loc4_)
         {
            this._actionMovie.width = _loc2_;
            this._actionMovie.scaleY = this._actionMovie.scaleX = 1;
         }
         this._actionMovie.doAction("stand");
         this._actionMovie.x = this._actionMovie.y = 0;
         _loc3_.removeChild(this._actionMovie);
         return _loc6_;
      }
      
      protected function deleteSmallView() : void
      {
         if(this._bloodStripBg)
         {
            if(this._bloodStripBg.parent)
            {
               this._bloodStripBg.parent.removeChild(this._bloodStripBg);
            }
            this._bloodStripBg.bitmapData.dispose();
            this._bloodStripBg = null;
         }
         if(this._HPStrip)
         {
            if(this._HPStrip.parent)
            {
               this._HPStrip.parent.removeChild(this._HPStrip);
            }
            this._HPStrip.dispose();
            this._HPStrip = null;
         }
         if(this._nickName)
         {
            if(this._nickName.parent)
            {
               this._nickName.parent.removeChild(this._nickName);
            }
         }
         if(this._smallView)
         {
            this._smallView.dispose();
            this._smallView.visible = false;
         }
         this._smallView = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeListener();
         this._info = null;
         this.deleteSmallView();
         this.removeAllPetBuffEffects();
         if(this._buffBar)
         {
            ObjectUtils.disposeObject(this._buffBar);
            this._buffBar = null;
         }
         if(this._nickName)
         {
            this._nickName.dispose();
         }
         this._nickName = null;
         if(this._chatballview)
         {
            this._chatballview.dispose();
            if(this._chatballview.parent)
            {
               this._chatballview.parent.removeChild(this._chatballview);
            }
         }
         if(this._actionMovie)
         {
            this._actionMovie.dispose();
            this._actionMovie = null;
         }
         if(_map)
         {
            _map.removePhysical(this);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this.cleanMovies();
         this.isExist = false;
      }
      
      public function get EffectRect() : Rectangle
      {
         return this._effRect;
      }
      
      override public function get smallView() : SmallObject
      {
         return this._smallView;
      }
      
      protected function __showAttackEffect(param1:LivingEvent) : void
      {
         if(this._attackEffectPlaying)
         {
            return;
         }
         if(this._info == null)
         {
            return;
         }
         this._attackEffectPlaying = true;
         var _loc2_:int = param1.paras[0];
         var _loc3_:MovieClip = this.creatAttackEffectAssetByID(_loc2_);
         _loc3_.scaleX = -1 * this._info.direction;
         var _loc4_:MovieClipWrapper = new MovieClipWrapper(_loc3_,true,true);
         _loc4_.addEventListener(Event.COMPLETE,this.__playComplete);
         _loc4_.gotoAndPlay(1);
         this._attackEffectPlayer = new PhysicalObj(-1);
         this._attackEffectPlayer.addChild(_loc4_.movie);
         var _loc5_:Point = _map.globalToLocal(this.movie.localToGlobal(this._attackEffectPos));
         this._attackEffectPlayer.x = _loc5_.x;
         this._attackEffectPlayer.y = _loc5_.y;
         _map.addPhysical(this._attackEffectPlayer);
      }
      
      private function __playComplete(param1:Event) : void
      {
         if(param1.currentTarget)
         {
            param1.currentTarget.removeEventListener(Event.COMPLETE,this.__playComplete);
         }
         if(_map)
         {
            _map.removePhysical(this._attackEffectPlayer);
         }
         if(this._attackEffectPlayer && this._attackEffectPlayer.parent)
         {
            this._attackEffectPlayer.parent.removeChild(this._attackEffectPlayer);
         }
         this._attackEffectPlaying = false;
         this._attackEffectPlayer = null;
      }
      
      public function showEffect(param1:String) : void
      {
         var _loc2_:AutoDisappear = null;
         if(param1 && ModuleLoader.hasDefinition(param1))
         {
            _loc2_ = new AutoDisappear(ClassUtils.CreatInstance(param1));
            addChild(_loc2_);
         }
      }
      
      private function removeAllPetBuffEffects() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._buffEffect)
         {
            for each(_loc1_ in this._buffEffect.list)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
            this._buffEffect = null;
         }
      }
      
      public function showBuffEffect(param1:String, param2:int) : void
      {
         var _loc3_:DisplayObject = null;
         if(param1 && ModuleLoader.hasDefinition(param1))
         {
            if(!this._buffEffect)
            {
               return;
            }
            if(this._buffEffect && this._buffEffect.hasKey(param2))
            {
               this.removeBuffEffect(param2);
            }
            _loc3_ = ClassUtils.CreatInstance(param1) as DisplayObject;
            addChild(_loc3_);
            this._buffEffect.add(param2,_loc3_);
         }
      }
      
      public function removeBuffEffect(param1:int) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._buffEffect && this._buffEffect.hasKey(param1))
         {
            _loc2_ = this._buffEffect[param1] as DisplayObject;
            if(_loc2_ && _loc2_.parent)
            {
               removeChild(_loc2_);
            }
            this._buffEffect.remove(param1);
         }
      }
      
      protected function hasMovie(param1:String) : Boolean
      {
         return this._moviePool.hasOwnProperty(param1);
      }
      
      protected function creatAttackEffectAssetByID(param1:int) : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc2_:String = "asset.game.AttackEffect" + param1;
         if(this.hasMovie(_loc2_))
         {
            return this._moviePool[_loc2_] as MovieClip;
         }
         _loc3_ = ClassUtils.CreatInstance("asset.game.AttackEffect" + param1.toString()) as MovieClip;
         this._moviePool[_loc2_] = _loc3_;
         return _loc3_;
      }
      
      private function cleanMovies() : void
      {
         var _loc1_:* = null;
         var _loc2_:MovieClip = null;
         for(_loc1_ in this._moviePool)
         {
            _loc2_ = this._moviePool[_loc1_];
            _loc2_.stop();
            ObjectUtils.disposeObject(_loc2_);
            delete this._moviePool[_loc1_];
         }
      }
      
      public function showBlood(param1:Boolean) : void
      {
         this._bloodStripBg.visible = this._HPStrip.visible = param1;
         this._nickName.visible = param1;
      }
      
      override public function setActionMapping(param1:String, param2:String) : void
      {
         this._actionMovie.setActionMapping(param1,param2);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(this.hiddenByServer)
         {
            return;
         }
         super.visible = param1;
         if(this._onSmallMap == false)
         {
            return;
         }
         if(this._smallView)
         {
            this._smallView.visible = param1;
         }
      }
      
      private function get hiddenByServer() : Boolean
      {
         return this._hiddenByServer;
      }
      
      private function set hiddenByServer(param1:Boolean) : void
      {
         if(param1)
         {
            super.visible = false;
         }
         else
         {
            super.visible = true;
         }
         this._hiddenByServer = param1;
      }
      
      protected function __onLivingCommand(param1:LivingCommandEvent) : void
      {
         switch(param1.commandType)
         {
            case "focusSelf":
               this.map.setCenter(GameManager.Instance.Current.selfGamePlayer.pos.x,GameManager.Instance.Current.selfGamePlayer.pos.x,false);
               break;
            case "focus":
               this.needFocus(param1.object.x,param1.object.y);
               return;
         }
      }
      
      protected function onChatBallComplete(param1:Event) : void
      {
         if(this._chatballview && this._chatballview.parent)
         {
            this._chatballview.parent.removeChild(this._chatballview);
         }
      }
      
      override public function startMoving() : void
      {
         super.startMoving();
         if(this._info)
         {
            this._info.isMoving = true;
         }
      }
      
      override public function stopMoving() : void
      {
         super.stopMoving();
         if(this._info)
         {
            this._info.isMoving = false;
         }
      }
      
      protected function headPropEffect() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:AutoPropEffect = null;
         var _loc3_:String = null;
         if(this._propArray && this._propArray.length > 0)
         {
            if(this._propArray[0] is String)
            {
               _loc3_ = this._propArray.shift();
               if(_loc3_ == "-1")
               {
                  _loc1_ = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.specialKillAsset");
               }
               else
               {
                  _loc1_ = PropItemView.createView(_loc3_,60,60);
               }
               _loc2_ = new AutoPropEffect(_loc1_);
               _loc2_.x = -5;
               _loc2_.y = -140;
            }
            else
            {
               _loc1_ = this._propArray.shift() as DisplayObject;
               _loc2_ = new AutoPropEffect(_loc1_);
               _loc2_.x = 5;
               _loc2_.y = -140;
            }
            addChild(_loc2_);
         }
      }
      
      protected function doUseItemAnimation(param1:Boolean = false) : void
      {
         var _loc2_:MovieClipWrapper = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset")),true,true);
         _loc2_.addFrameScriptAt(12,this.headPropEffect);
         SoundManager.instance.play("039");
         _loc2_.movie.x = 0;
         _loc2_.movie.y = -10;
         if(!param1)
         {
            addChild(_loc2_.movie);
         }
      }
      
      public function setProperty(param1:String, param2:String) : void
      {
         var _loc3_:StringObject = new StringObject(param2);
         switch(param1)
         {
            case "visible":
               this.hiddenByServer = !_loc3_.getBoolean();
               return;
            case "offsetX":
               this._offsetX = _loc3_.getInt();
               this.map.smallMap.updatePos(this._smallView,new Point(this.x,this.y));
               return;
            case "offsetY":
               this._offsetY = _loc3_.getInt();
               this.map.smallMap.updatePos(this._smallView,new Point(this.x,this.y));
               return;
            case "speedX":
               this.speedMult = _loc3_.getInt() / this._speedX;
               break;
            case "speedY":
               this.speedMult = _loc3_.getInt() / this._speedY;
               break;
            case "onSmallMap":
               this.smallView.visible = _loc3_.getBoolean();
               this._onSmallMap = _loc3_.getBoolean();
               if(this._onSmallMap)
               {
                  this._smallView.info = this._info;
               }
               break;
            default:
               this.info.setProperty(param1,param2);
         }
      }
   }
}
